#ifndef SPINEITEM_H
#define SPINEITEM_H

#include <QQuickFramebufferObject>
#include <QElapsedTimer>

namespace spine {
    class Atlas;
    class SkeletonData;
    class Skeleton;
    class AnimationStateData;
    class AnimationState;
    class TextureLoader;
}

class SpineItem : public QQuickFramebufferObject
{
    Q_OBJECT
    // Use QString (not QUrl) for QML compatibility -- QUrl resolution in
    // QML_ELEMENT modules is unreliable. We resolve relative paths manually
    // in componentComplete() using QQmlContext.
    Q_PROPERTY(QString atlasUrl READ atlasUrl WRITE setAtlasUrl NOTIFY atlasUrlChanged FINAL)
    Q_PROPERTY(QString skeletonUrl READ skeletonUrl WRITE setSkeletonUrl NOTIFY skeletonUrlChanged FINAL)
    Q_PROPERTY(QString animationName READ animationName WRITE setAnimationName NOTIFY animationNameChanged FINAL)
    Q_PROPERTY(qreal scale READ scale WRITE setScale NOTIFY scaleChanged FINAL)
    Q_PROPERTY(bool autoPlay READ autoPlay WRITE setAutoPlay NOTIFY autoPlayChanged FINAL)
    Q_PROPERTY(qreal timeScale READ timeScale WRITE setTimeScale NOTIFY timeScaleChanged FINAL)
    Q_PROPERTY(bool loaded READ isLoaded NOTIFY loadedChanged FINAL)
    Q_PROPERTY(QString queuedAnimation READ queuedAnimation WRITE setQueuedAnimation NOTIFY queuedAnimationChanged FINAL)
    Q_PROPERTY(qreal mixDuration READ mixDuration WRITE setMixDuration NOTIFY mixDurationChanged FINAL)
    Q_PROPERTY(QString character READ character WRITE setCharacter NOTIFY characterChanged FINAL)
    Q_PROPERTY(QString dataRoot READ dataRoot WRITE setDataRoot NOTIFY dataRootChanged FINAL)

    QML_ELEMENT

public:
    explicit SpineItem(QQuickItem *parent = nullptr);
    ~SpineItem() override;

    QString atlasUrl() const;
    void setAtlasUrl(const QString &url);

    QString skeletonUrl() const;
    void setSkeletonUrl(const QString &url);

    QString animationName() const;
    void setAnimationName(const QString &name);

    qreal scale() const;
    void setScale(qreal s);

    bool autoPlay() const;
    void setAutoPlay(bool enabled);

    qreal timeScale() const;
    void setTimeScale(qreal ts);

    bool isLoaded() const;

    QString queuedAnimation() const;
    void setQueuedAnimation(const QString &name);

    qreal mixDuration() const;
    void setMixDuration(qreal duration);

    QString character() const;
    void setCharacter(const QString &name);

    QString dataRoot() const;
    void setDataRoot(const QString &path);

    Q_INVOKABLE void playAnimation(const QString &name, bool loop = true);
    Q_INVOKABLE void queueAnimation(const QString &name, bool loop = true, float delay = 0.0f);
    Q_INVOKABLE void clearTrack(int trackIndex = 0);
    Q_INVOKABLE void reloadData();

signals:
    void atlasUrlChanged();
    void skeletonUrlChanged();
    void animationNameChanged();
    void scaleChanged();
    void autoPlayChanged();
    void timeScaleChanged();
    void loadedChanged();
    void queuedAnimationChanged();
    void mixDurationChanged();
    void characterChanged();
    void dataRootChanged();
    void loadError(const QString &message);

protected:
    void componentComplete() override;
    Renderer *createRenderer() const override;

    // Resolved absolute paths (set in componentComplete)
    QString resolvePath(const QString &relativePath) const;

private:
    friend class SpineFboRenderer;

    QString m_atlasUrl;
    QString m_skeletonUrl;
    QString m_animationName;
    qreal m_scale = 1.0;
    bool m_autoPlay = true;
    qreal m_timeScale = 1.0;
    bool m_loaded = false;
    QString m_queuedAnimation;
    bool m_queuedLoop = true;  // default loop (autoPlay / Idle_01)
    qreal m_queueDelay = 0.0;
    qreal m_mixDuration = 0.3;
    QString m_character;
    QString m_dataRoot;

    // Resolved absolute paths for the renderer
    QString m_resolvedAtlasPath;
    QString m_resolvedSkeletonPath;
};

#endif
