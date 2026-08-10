
#include <spine/spine.h>
#include <GLFW/glfw3.h>
#include <glad/glad.h>
#include <stb_image.h>
#include <stdio.h>
#include <string.h>

using namespace spine;

// 自定义纹理加载器，使用 stb_image
class GLFWTextureLoader : public TextureLoader {
public:
    virtual void load(AtlasPage &page, const String &path) {
        int width, height, channels;
        unsigned char *data = stbi_load(path.buffer(), &width, &height, &channels, 4);
        if (!data) {
            printf("Failed to load texture: %s\n", path.buffer());
            return;
        }

        GLuint textureId;
        glGenTextures(1, &textureId);
        glBindTexture(GL_TEXTURE_2D, textureId);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0,
                     GL_RGBA, GL_UNSIGNED_BYTE, data);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

        stbi_image_free(data);

        page.setRendererObject((void *)(intptr_t)textureId);
    }

    virtual void unload(void *texture) {
        GLuint id = (GLuint)(intptr_t)texture;
        glDeleteTextures(1, &id);
    }
};

// Spine 骨骼渲染器
class SpineRenderer {
private:
    GLFWTextureLoader _textureLoader;
    Atlas *_atlas;
    SkeletonData *_skeletonData;
    Skeleton *_skeleton;
    AnimationStateData *_stateData;
    AnimationState *_state;
    float *_worldVertices;
    unsigned int *_indices;
    int _numVertices;
    int _numIndices;

public:
    SpineRenderer() : _atlas(nullptr), _skeletonData(nullptr), _skeleton(nullptr),
                      _stateData(nullptr), _state(nullptr),
                      _worldVertices(nullptr), _indices(nullptr) {}

    ~SpineRenderer() {
        if (_worldVertices) delete[] _worldVertices;
        if (_indices) delete[] _indices;
        if (_state) delete _state;
        if (_stateData) delete _stateData;
        if (_skeleton) delete _skeleton;
        if (_skeletonData) delete _skeletonData;
        if (_atlas) delete _atlas;
    }

    bool load(const char *atlasPath, const char *skeletonPath, float scale = 1.0f) {
        // 加载 Atlas
        _atlas = new Atlas(atlasPath, &_textureLoader);
        if (!_atlas) {
            printf("Failed to load atlas: %s\n", atlasPath);
            return false;
        }

        // 判断是 JSON 还是二进制格式
        const char *ext = strrchr(skeletonPath, '.');
        if (ext && strcmp(ext, ".json") == 0) {
            SkeletonJson json(_atlas);
            json.setScale(scale);
            _skeletonData = json.readSkeletonDataFile(skeletonPath);
        } else {
            SkeletonBinary binary(_atlas);
            binary.setScale(scale);
            _skeletonData = binary.readSkeletonDataFile(skeletonPath);
        }

        if (!_skeletonData) {
            printf("Failed to load skeleton: %s\n", skeletonPath);
            return false;
        }

        _skeleton = new Skeleton(_skeletonData);
        _stateData = new AnimationStateData(_skeletonData);
        _state = new AnimationState(_stateData);

        // 预分配顶点和索引缓冲
        _worldVertices = new float[10000];  // 足够大
        _indices = new unsigned int[10000];

        return true;
    }

    void update(float delta) {
        _state->update(delta);
        _state->apply(*_skeleton);
        _skeleton->updateWorldTransform();
    }

    void draw() {
        // 遍历所有槽位，渲染附件
        for (int slotIdx = 0; slotIdx < _skeleton->getSlots().size(); slotIdx++) {
            Slot *slot = _skeleton->getDrawOrder()[slotIdx];
            Attachment *attachment = slot->getAttachment();
            if (!attachment) continue;

            Color skeletonColor = _skeleton->getColor();
            Color slotColor = slot->getColor();

            float alpha = skeletonColor.a * slotColor.a;
            float r = skeletonColor.r * slotColor.r;
            float g = skeletonColor.g * slotColor.g;
            float b = skeletonColor.b * slotColor.b;

            GLuint textureId = 0;

            if (attachment->getRTTI().isExactly(RegionAttachment::rtti)) {
                RegionAttachment *region = static_cast<RegionAttachment *>(attachment);
                region->computeWorldVertices(slot->getBone(), _worldVertices, 0, 2);
                textureId = (GLuint)(intptr_t)((AtlasRegion *)region->getRendererObject())->page->getRendererObject();
                _numVertices = 4;
                _numIndices = 6;
                _indices[0] = 0; _indices[1] = 1; _indices[2] = 2;
                _indices[3] = 2; _indices[4] = 3; _indices[5] = 0;
            } else if (attachment->getRTTI().isExactly(MeshAttachment::rtti)) {
                MeshAttachment *mesh = static_cast<MeshAttachment *>(attachment);
                textureId = (GLuint)(intptr_t)((AtlasRegion *)mesh->getRendererObject())->page->getRendererObject();
                _numVertices = mesh->getWorldVerticesLength() / 2;
                mesh->computeWorldVertices(slot, 0, mesh->getWorldVerticesLength(), _worldVertices, 0, 2);
                _numIndices = mesh->getTriangles().size();
                for (int i = 0; i < _numIndices; i++) {
                    _indices[i] = mesh->getTriangles()[i];
                }
            } else {
                continue;
            }

            // OpenGL 渲染
            glEnable(GL_TEXTURE_2D);
            glBindTexture(GL_TEXTURE_2D, textureId);
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

            glColor4f(r, g, b, alpha);

            glEnableClientState(GL_VERTEX_ARRAY);
            glEnableClientState(GL_TEXTURE_COORD_ARRAY);
            glVertexPointer(2, GL_FLOAT, 4 * sizeof(float), _worldVertices);
            glTexCoordPointer(2, GL_FLOAT, 4 * sizeof(float), _worldVertices + 2);
            glDrawElements(GL_TRIANGLES, _numIndices, GL_UNSIGNED_INT, _indices);
            glDisableClientState(GL_VERTEX_ARRAY);
            glDisableClientState(GL_TEXTURE_COORD_ARRAY);
        }
    }

    void playAnimation(const char *name, bool loop = true) {
        _state->setAnimation(1, name, loop);
    }

    Skeleton *getSkeleton() { return _skeleton; }
    AnimationState *getAnimationState() { return _state; }
};
