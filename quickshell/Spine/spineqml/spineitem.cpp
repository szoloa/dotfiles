#include "spineitem.h"

#include <spine/spine.h>

#include <QOpenGLFunctions>
#include <QImage>
#include <QFileInfo>
#include <QDir>
#include <QQuickWindow>
#include <QOpenGLFramebufferObject>
#include <QQmlContext>
#include <QQmlEngine>
#include <QDebug>

// Spine requires the consuming runtime to provide getDefaultExtension()
namespace spine {
    SpineExtension *getDefaultExtension() {
        return new DefaultSpineExtension();
    }
}

// ===========================================================================
// QtTextureLoader
// ===========================================================================

class QtTextureLoader : public spine::TextureLoader {
public:
    QtTextureLoader(QOpenGLFunctions *gl, const QString &atlasDir)
        : m_gl(gl), m_atlasDir(atlasDir) {}

    void load(spine::AtlasPage &page, const spine::String &path) override {
        // path is already fully resolved by Spine's Atlas (dir + name), no need to prepend m_atlasDir
        QString filePath = path.buffer();
        QImage img(filePath);
        if (img.isNull()) {
            qWarning("Spine: failed to load texture: %s", qPrintable(filePath));
            return;
        }
        qDebug("Spine: loaded image %s  size=%dx%d  format=%d",
               qPrintable(filePath), img.width(), img.height(), (int)img.format());

        img = img.convertToFormat(QImage::Format_RGBA8888);
        qDebug("Spine: converted to RGBA8888  byteCount=%lld",
               (long long)img.sizeInBytes());

        GLuint textureId;
        m_gl->glGenTextures(1, &textureId);
        m_gl->glBindTexture(GL_TEXTURE_2D, textureId);
        m_gl->glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8,
                           img.width(), img.height(), 0,
                           GL_RGBA, GL_UNSIGNED_BYTE, img.constBits());
        GLenum err = m_gl->glGetError();
        if (err != GL_NO_ERROR) {
            qWarning("Spine: glTexImage2D error: 0x%x", err);
        }
        m_gl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        m_gl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        m_gl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        m_gl->glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

        qDebug("Spine: created texture id=%u for page=%p", textureId, (void*)&page);

        page.setRendererObject((void *)(intptr_t)textureId);
        page.width = img.width();
        page.height = img.height();
    }

    void unload(void *texture) override {
        GLuint id = (GLuint)(intptr_t)texture;
        m_gl->glDeleteTextures(1, &id);
    }

private:
    QOpenGLFunctions *m_gl;
    QString m_atlasDir;
};

// ===========================================================================
// SpineFboRenderer
// ===========================================================================

class SpineFboRenderer : public QQuickFramebufferObject::Renderer,
                          protected QOpenGLFunctions
{
public:
    SpineFboRenderer(const SpineItem *item)
        : m_item(item)
        , m_atlas(nullptr), m_skeletonData(nullptr), m_skeleton(nullptr)
        , m_stateData(nullptr), m_state(nullptr), m_textureLoader(nullptr)
        , m_worldVertices(nullptr), m_indices(nullptr)
        , m_initialized(false), m_pendingLoad(false)
        , m_pendingAnimation(false), m_pendingQueueAnimation(false)
    {
        m_worldVertices = new float[10000];
        m_indices = new unsigned int[10000];
    }

    ~SpineFboRenderer() override {
        cleanupSpine();
        delete[] m_worldVertices;
        delete[] m_indices;
    }

    void initializeGL() {
        if (m_initialized) return;
        initializeOpenGLFunctions();
        m_initialized = true;
    }

    void synchronize(QQuickFramebufferObject *item) override {
        const SpineItem *spineItem = static_cast<const SpineItem *>(item);

        // Detect load request (first load or URL change)
        if (spineItem->m_resolvedAtlasPath != m_loadedAtlasPath ||
            spineItem->m_resolvedSkeletonPath != m_loadedSkeletonPath) {
            m_pendingLoad = true;
        }

        // Detect animation change
        if (!spineItem->m_animationName.isEmpty() &&
            spineItem->m_animationName != m_currentAnimation) {
            m_pendingAnimation = true;
        }

        // Detect queued animation
        if (!spineItem->m_queuedAnimation.isEmpty() &&
            spineItem->m_queuedAnimation != m_currentQueued) {
            m_pendingQueueAnimation = true;
        }

        // Sync timeScale
        if (m_state) {
            m_state->setTimeScale((float)spineItem->m_timeScale);
        }
    }

    void render() override {
        if (!m_initialized) {
            initializeGL();
        }

        // First-load or reload
        if (m_pendingLoad) {
            m_pendingLoad = false;
            doLoad();
        }

        if (!m_skeleton) {
            glClearColor(0, 0, 0, 0);
            glClear(GL_COLOR_BUFFER_BIT);
            return;
        }

        if (m_pendingAnimation) {
            m_pendingAnimation = false;
            doSetAnimation();
        }

        if (m_pendingQueueAnimation) {
            m_pendingQueueAnimation = false;
            doQueueAnimation();
        }

        // Delta time
        qint64 now = m_timer.isValid() ? m_timer.elapsed() : 0;
        if (!m_timer.isValid()) {
            m_timer.start();
            now = 0;
        }
        float delta = (float)(now - m_lastTime) / 1000.0f;
        if (delta < 0) delta = 0;
        if (delta > 0.1f) delta = 0.1f;
        m_lastTime = now;

        m_state->update(delta);
        m_state->apply(*m_skeleton);
        m_skeleton->updateWorldTransform();

        QOpenGLFramebufferObject *fbo = framebufferObject();
        int fboWidth = fbo ? fbo->width() : 800;
        int fboHeight = fbo ? fbo->height() : 600;

        glViewport(0, 0, fboWidth, fboHeight);
        glClearColor(0, 0, 0, 0);
        glClear(GL_COLOR_BUFFER_BIT);

        // Projection: Y-up (matches Spine convention)
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrtho(0, fboWidth, 0, fboHeight, -1, 1);
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();

        // Center skeleton: root (0,0) at bottom-center of viewport.
        // Shift up by -minY so the lowest point of the skeleton sits at y=0.
        float offsetY = (m_boundsMinY < 0) ? -m_boundsMinY : 0.0f;
        glTranslatef((float)fboWidth / 2.0f, offsetY, 0.0f);

        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        drawSkeleton();

        glBindFramebuffer(GL_FRAMEBUFFER, 0);

        // Keep rendering if animation is playing
        if (m_state && m_state->getCurrent(0)) {
            QMetaObject::invokeMethod(
                const_cast<SpineItem *>(m_item), "update", Qt::QueuedConnection);
        }
    }

private:
    void doLoad() {
        cleanupSpine();

        const SpineItem *item = m_item;
        QString atlasPath = item->m_resolvedAtlasPath;
        QString skeletonPath = item->m_resolvedSkeletonPath;

        qDebug("Spine: loading atlas=%s skeleton=%s",
               qPrintable(atlasPath), qPrintable(skeletonPath));

        if (atlasPath.isEmpty() || skeletonPath.isEmpty()) {
            qDebug("Spine: paths not yet resolved, waiting...");
            return;
        }

        if (!QFileInfo::exists(atlasPath)) {
            qWarning("Spine: atlas not found: %s", qPrintable(atlasPath));
            emitLoadError("Atlas not found: " + atlasPath);
            return;
        }

        QString atlasDir = QFileInfo(atlasPath).absolutePath();
        m_textureLoader = new QtTextureLoader(this, atlasDir);

        // Load atlas
        m_atlas = new spine::Atlas(atlasPath.toUtf8().constData(), m_textureLoader);
        if (m_atlas->getPages().size() == 0) {
            qWarning("Spine: atlas empty: %s", qPrintable(atlasPath));
            emitLoadError("Atlas empty: " + atlasPath);
            cleanupSpine();
            return;
        }

        // Load skeleton
        if (skeletonPath.endsWith(".json", Qt::CaseInsensitive)) {
            spine::SkeletonJson json(m_atlas);
            json.setScale((float)item->m_scale);
            m_skeletonData = json.readSkeletonDataFile(skeletonPath.toUtf8().constData());
        } else {
            spine::SkeletonBinary binary(m_atlas);
            binary.setScale((float)item->m_scale);
            m_skeletonData = binary.readSkeletonDataFile(skeletonPath.toUtf8().constData());
        }

        if (!m_skeletonData) {
            qWarning("Spine: failed to load skeleton: %s", qPrintable(skeletonPath));
            emitLoadError("Failed to load skeleton: " + skeletonPath);
            cleanupSpine();
            return;
        }

        m_skeleton = new spine::Skeleton(m_skeletonData);
        m_skeleton->setToSetupPose();
        m_skeleton->updateWorldTransform();

        // Log bounds
        spine::Vector<float> bounds;
        float bx, by, bw, bh;
        m_skeleton->getBounds(bx, by, bw, bh, bounds);
        qDebug("Spine: bounds x=%.0f y=%.0f w=%.0f h=%.0f  bones=%zu slots=%zu animations=%zu",
               bx, by, bw, bh,
               m_skeletonData->getBones().size(),
               m_skeletonData->getSlots().size(),
               m_skeletonData->getAnimations().size());

        // Store min Y for render offset (Spine root at (0,0), skeleton extends below)
        m_boundsMinY = by;
        m_boundsMaxY = by + bh;

        // Log available animation names
        auto &anims = m_skeletonData->getAnimations();
        for (size_t i = 0; i < anims.size(); ++i) {
            qDebug("Spine: animation[%zu] = '%s'", i, anims[i]->getName().buffer());
        }

        m_stateData = new spine::AnimationStateData(m_skeletonData);
        m_state = new spine::AnimationState(m_stateData);
        m_state->setTimeScale((float)item->m_timeScale);

        m_loadedAtlasPath = atlasPath;
        m_loadedSkeletonPath = skeletonPath;

        emitLoaded();

        if (item->m_autoPlay && !item->m_animationName.isEmpty()) {
            m_pendingAnimation = true;
        }
    }

    void doSetAnimation() {
        if (!m_state) return;
        const SpineItem *item = m_item;
        spine::Animation *anim = m_skeletonData->findAnimation(
            item->m_animationName.toUtf8().constData());
        if (anim) {
            m_state->setAnimation(0, anim, item->m_queuedLoop);
            m_currentAnimation = item->m_animationName;
            qDebug("Spine: playing animation: %s", qPrintable(m_currentAnimation));
        } else {
            qWarning("Spine: animation not found: %s", qPrintable(item->m_animationName));
        }
    }

    void doQueueAnimation() {
        if (!m_state) return;
        const SpineItem *item = m_item;
        spine::Animation *anim = m_skeletonData->findAnimation(
            item->m_queuedAnimation.toUtf8().constData());
        if (anim) {
            // Track 1: setAnimation replaces immediately (不会排队在已完成的动画后面)
            m_state->setAnimation(1, anim, item->m_queuedLoop);
            m_currentQueued = item->m_queuedAnimation;
            qDebug("Spine: expression on track 1: %s (loop=%d)",
                   qPrintable(m_currentQueued), item->m_queuedLoop);
        }
    }

    void drawSkeleton() {
        spine::Color skeletonColor = m_skeleton->getColor();

        for (size_t i = 0; i < m_skeleton->getSlots().size(); ++i) {
            spine::Slot *slot = m_skeleton->getDrawOrder()[i];
            spine::Attachment *attachment = slot->getAttachment();
            if (!attachment) continue;

            spine::Color slotColor = slot->getColor();
            float alpha = skeletonColor.a * slotColor.a;
            float r = skeletonColor.r * slotColor.r;
            float g = skeletonColor.g * slotColor.g;
            float b = skeletonColor.b * slotColor.b;

            GLuint textureId = 0;
            int numVertices = 0;
            int numIndices = 0;

            if (attachment->getRTTI().isExactly(spine::RegionAttachment::rtti)) {
                auto *region = static_cast<spine::RegionAttachment *>(attachment);
                region->computeWorldVertices(slot->getBone(), m_worldVertices, 0, 2);
                textureId = getTextureId(region);
                numVertices = 4;
                numIndices = 6;
                m_indices[0] = 0; m_indices[1] = 1; m_indices[2] = 2;
                m_indices[3] = 2; m_indices[4] = 3; m_indices[5] = 0;
                buildInterleavedUVs(region->getUVs(), m_worldVertices, 4);

            } else if (attachment->getRTTI().isExactly(spine::MeshAttachment::rtti)) {
                auto *mesh = static_cast<spine::MeshAttachment *>(attachment);
                numVertices = (int)mesh->getWorldVerticesLength() / 2;
                mesh->computeWorldVertices(*slot, 0, mesh->getWorldVerticesLength(),
                                           m_worldVertices, 0, 2);
                textureId = getTextureId(mesh);
                auto &triangles = mesh->getTriangles();
                numIndices = (int)triangles.size();
                for (int j = 0; j < numIndices; ++j) m_indices[j] = triangles[j];
                buildInterleavedUVs(mesh->getUVs(), m_worldVertices, numVertices);
            } else {
                continue;
            }

            if (textureId == 0 || numVertices == 0) continue;

            glBindTexture(GL_TEXTURE_2D, textureId);
            glEnable(GL_TEXTURE_2D);
            glColor4f(r, g, b, alpha);

            glEnableClientState(GL_VERTEX_ARRAY);
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
            glVertexPointer(2, GL_FLOAT, 4 * sizeof(float), m_worldVertices);
            glTexCoordPointer(2, GL_FLOAT, 4 * sizeof(float), m_worldVertices + 2);
            glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_INT, m_indices);
            glDisableClientState(GL_VERTEX_ARRAY);
            glDisableClientState(GL_TEXTURE_COORD_ARRAY);
        }
    }

    // Rearrange flat [x0,y0,x1,y1,...] + separate UVs → interleaved [x0,y0,u0,v0,x1,y1,u1,v1,...]
    static void buildInterleavedUVs(spine::Vector<float> &uvs,
                                     float *verts, int count) {
        for (int i = count - 1; i >= 0; --i) {
            verts[i * 4 + 3] = uvs[i * 2 + 1];
            verts[i * 4 + 2] = uvs[i * 2];
            verts[i * 4 + 1] = verts[i * 2 + 1];
            verts[i * 4 + 0] = verts[i * 2];
        }
    }

    GLuint getTextureId(spine::HasRendererObject *obj) {
        // In Spine 3.8, AtlasAttachmentLoader stores AtlasRegion* as the
        // attachment's renderer object. The actual texture ID lives on the
        // AtlasPage's renderer object (set by QtTextureLoader::load).
        spine::AtlasRegion *region = (spine::AtlasRegion *)obj->getRendererObject();
        if (!region || !region->page) return 0;
        return (GLuint)(intptr_t)region->page->getRendererObject();
    }

    void cleanupSpine() {
        delete m_state;       m_state = nullptr;
        delete m_stateData;   m_stateData = nullptr;
        delete m_skeleton;    m_skeleton = nullptr;
        delete m_skeletonData; m_skeletonData = nullptr;
        delete m_atlas;       m_atlas = nullptr;
        delete m_textureLoader; m_textureLoader = nullptr;
        m_currentAnimation.clear();
        m_currentQueued.clear();
        m_loadedAtlasPath.clear();
        m_loadedSkeletonPath.clear();
    }

    void emitLoaded() {
        QMetaObject::invokeMethod(const_cast<SpineItem *>(m_item), [this]() {
            const_cast<SpineItem *>(m_item)->m_loaded = true;
            emit const_cast<SpineItem *>(m_item)->loadedChanged();
        }, Qt::QueuedConnection);
    }

    void emitLoadError(const QString &msg) {
        QMetaObject::invokeMethod(const_cast<SpineItem *>(m_item), [this, msg]() {
            emit const_cast<SpineItem *>(m_item)->loadError(msg);
        }, Qt::QueuedConnection);
    }

    const SpineItem *m_item;
    spine::Atlas *m_atlas;
    spine::SkeletonData *m_skeletonData;
    spine::Skeleton *m_skeleton;
    spine::AnimationStateData *m_stateData;
    spine::AnimationState *m_state;
    QtTextureLoader *m_textureLoader;
    float *m_worldVertices;
    unsigned int *m_indices;
    QElapsedTimer m_timer;
    qint64 m_lastTime = 0;
    bool m_initialized;
    QString m_loadedAtlasPath;
    QString m_loadedSkeletonPath;
    QString m_currentAnimation;
    QString m_currentQueued;
    bool m_pendingLoad;
    bool m_pendingAnimation;
    bool m_pendingQueueAnimation;
    float m_boundsMinY = 0;
    float m_boundsMaxY = 0;
};

// ===========================================================================
// SpineItem
// ===========================================================================

SpineItem::SpineItem(QQuickItem *parent)
    : QQuickFramebufferObject(parent)
{
    setFlag(QQuickItem::ItemHasContents, true);
    connect(this, &QQuickItem::windowChanged, this, [this](QQuickWindow *win) {
        if (win) {
            connect(win, &QQuickWindow::beforeRendering,
                    this, &QQuickItem::update, Qt::QueuedConnection);
        }
    });
}

SpineItem::~SpineItem() = default;

void SpineItem::componentComplete() {
    QQuickFramebufferObject::componentComplete();
    // Compute paths from character/dataRoot if atlas/skeleton not set directly
    if (m_atlasUrl.isEmpty() && !m_character.isEmpty() && !m_dataRoot.isEmpty()) {
        QString base = m_dataRoot + "/" + m_character + "/" + m_character + "_spr";
        m_atlasUrl = base + ".atlas";
        m_skeletonUrl = base + ".skel";
        qDebug("Spine: computed paths from character=%s dataRoot=%s",
               qPrintable(m_character), qPrintable(m_dataRoot));
    }
    m_resolvedAtlasPath = resolvePath(m_atlasUrl);
    m_resolvedSkeletonPath = resolvePath(m_skeletonUrl);
    qDebug("Spine: componentComplete atlas=%s skeleton=%s",
           qPrintable(m_resolvedAtlasPath), qPrintable(m_resolvedSkeletonPath));
    update();
}

QString SpineItem::resolvePath(const QString &relativePath) const {
    if (relativePath.isEmpty()) return {};
    // If already absolute, return as-is
    if (QDir::isAbsolutePath(relativePath)) return relativePath;
    // Resolve relative to the QML file's location
    QQmlContext *ctx = QQmlEngine::contextForObject(this);
    if (ctx) {
        return ctx->resolvedUrl(QUrl(relativePath)).toLocalFile();
    }
    return relativePath;
}

QQuickFramebufferObject::Renderer *SpineItem::createRenderer() const {
    return new SpineFboRenderer(this);
}

// Property accessors

QString SpineItem::atlasUrl() const { return m_atlasUrl; }
void SpineItem::setAtlasUrl(const QString &url) {
    if (m_atlasUrl != url) {
        m_atlasUrl = url;
        m_resolvedAtlasPath = resolvePath(url);
        emit atlasUrlChanged();
        update();
    }
}

QString SpineItem::skeletonUrl() const { return m_skeletonUrl; }
void SpineItem::setSkeletonUrl(const QString &url) {
    if (m_skeletonUrl != url) {
        m_skeletonUrl = url;
        m_resolvedSkeletonPath = resolvePath(url);
        emit skeletonUrlChanged();
        update();
    }
}

QString SpineItem::animationName() const { return m_animationName; }
void SpineItem::setAnimationName(const QString &name) {
    if (m_animationName != name) { m_animationName = name; emit animationNameChanged(); update(); }
}

qreal SpineItem::scale() const { return m_scale; }
void SpineItem::setScale(qreal s) {
    if (!qFuzzyCompare(m_scale, s)) { m_scale = s; emit scaleChanged(); update(); }
}

bool SpineItem::autoPlay() const { return m_autoPlay; }
void SpineItem::setAutoPlay(bool enabled) {
    if (m_autoPlay != enabled) { m_autoPlay = enabled; emit autoPlayChanged(); }
}

qreal SpineItem::timeScale() const { return m_timeScale; }
void SpineItem::setTimeScale(qreal ts) {
    if (!qFuzzyCompare(m_timeScale, ts)) { m_timeScale = ts; emit timeScaleChanged(); update(); }
}

bool SpineItem::isLoaded() const { return m_loaded; }

QString SpineItem::queuedAnimation() const { return m_queuedAnimation; }
void SpineItem::setQueuedAnimation(const QString &name) {
    if (m_queuedAnimation != name) { m_queuedAnimation = name; emit queuedAnimationChanged(); update(); }
}

qreal SpineItem::mixDuration() const { return m_mixDuration; }
void SpineItem::setMixDuration(qreal duration) {
    if (!qFuzzyCompare(m_mixDuration, duration)) { m_mixDuration = duration; emit mixDurationChanged(); }
}

QString SpineItem::character() const { return m_character; }
void SpineItem::setCharacter(const QString &name) {
    if (m_character != name) {
        m_character = name;
        emit characterChanged();
        // Auto-compute paths from character name
        if (!m_dataRoot.isEmpty() && !m_character.isEmpty()) {
            QString base = m_dataRoot + "/" + m_character + "/" + m_character + "_spr";
            qDebug("Spine: switching character to '%s'  atlas=%s.atlas",
                   qPrintable(m_character), qPrintable(base));
            setAtlasUrl(base + ".atlas");
            setSkeletonUrl(base + ".skel");
            reloadData();
        }
    }
}

QString SpineItem::dataRoot() const { return m_dataRoot; }
void SpineItem::setDataRoot(const QString &path) {
    if (m_dataRoot != path) {
        m_dataRoot = path;
        emit dataRootChanged();
    }
}

void SpineItem::playAnimation(const QString &name, bool loop) {
    m_queuedLoop = loop;
    setAnimationName(name);
}

void SpineItem::queueAnimation(const QString &name, bool loop, float delay) {
    m_queuedLoop = loop;
    m_queueDelay = delay;
    setQueuedAnimation(name);
}

void SpineItem::clearTrack(int trackIndex) {
    if (trackIndex == 0) {
        m_animationName.clear();
        emit animationNameChanged();
    }
    if (trackIndex == 1) {
        m_queuedAnimation.clear();
        emit queuedAnimationChanged();
    }
    update();
}

void SpineItem::reloadData() {
    m_resolvedAtlasPath = resolvePath(m_atlasUrl);
    m_resolvedSkeletonPath = resolvePath(m_skeletonUrl);
    qDebug("Spine: reloadData atlas=%s skeleton=%s",
           qPrintable(m_resolvedAtlasPath), qPrintable(m_resolvedSkeletonPath));
    update();
}
