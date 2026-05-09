#include "SpineWidget.h"
#include <QPainter>
#include <QDebug>
#include <QImage>
#include <cmath>
#include <iostream>

// 1. 首先实现纹理加载器（使用裸指针，生命周期由 Atlas 管理）
class QtTextureLoader : public spine::TextureLoader {
public:
    void load(spine::AtlasPage &page, const spine::String &path) override {
        QImage image(QString::fromStdString(path.buffer()));
        if (image.isNull()) {
            qWarning() << "Failed to load texture:" << path.buffer();
            return;
        }
        // 创建一个QImage*并存储在page.rendererObject中
        QImage* texture = new QImage(image);
        page.setRendererObject(texture);
        page.width = texture->width();
        page.height = texture->height();
    }
    void unload(void* texture) override {
        if (texture) {
            delete static_cast<QImage*>(texture);
        }
    }
};

SpineWidget::SpineWidget(QWidget *parent) 
    : QWidget(parent) 
{
    // 设置窗口背景为透明，以便看到动画
    setAttribute(Qt::WA_TranslucentBackground);
    // 启动一个定时器来驱动动画更新，帧率约为60 FPS
    startTimer(1000 / 60);
    // 初始化 Spine 资源（使用相对于可执行文件的路径）
    initSpine("assets/akane/akane_spr.skel", "assets/akane/akane_spr.atlas");
}

SpineWidget::~SpineWidget() = default;

void SpineWidget::initSpine(const char* skeletonPath, const char* atlasPath) {

    try {
        // 1. 创建纹理加载器（裸指针，Atlas 会管理其生命周期）
        QtTextureLoader* textureLoader = new QtTextureLoader();

        // 2. 加载 Atlas
        m_atlas = std::make_unique<spine::Atlas>(atlasPath, textureLoader);
        if (m_atlas->getPages().size() == 0) {
            qWarning() << "Atlas加载失败，没有页面:" << atlasPath;
            delete textureLoader;
            return;
        }

        // 3. 使用二进制加载器读取 .skel 文件
        m_binary = std::make_unique<spine::SkeletonBinary>(m_atlas.get());
        spine::SkeletonData* rawData = m_binary->readSkeletonDataFile(skeletonPath);
        if (!rawData) {
            qWarning() << "骨骼文件加载失败:" << skeletonPath;
            if (m_binary->getError().length() > 0) {
                qWarning() << "错误信息:" << m_binary->getError().buffer();
            }
            return;
        }
        m_skeletonData.reset(rawData);

        // 4. 创建骨骼实例
        m_skeleton = std::make_unique<spine::Skeleton>(m_skeletonData.get());
        m_animStateData = std::make_unique<spine::AnimationStateData>(m_skeletonData.get());
        m_animState = std::make_unique<spine::AnimationState>(m_animStateData.get());

        // 5. 播放第一个动画（或者指定的动画）
        auto& animations = m_skeletonData->getAnimations();
        if (animations.size() > 0) {
            const char* animName = animations[2]->getName().buffer();
            m_animState->setAnimation(0, spine::String(animName), true);
            qDebug() << "播放动画:" << animName;
        } else {
            qWarning() << "没有找到任何动画";
        }

        m_skeleton->updateWorldTransform();

        // 清理纹理加载器（Atlas 已经管理了它）
        delete textureLoader;
    } catch (const std::exception& e) {
        qWarning() << "Spine 异常:" << e.what();
    }
}

void SpineWidget::paintEvent(QPaintEvent *) {
    QPainter painter(this);
    if (!m_skeleton) return;

    // 获取当前骨骼世界变换后的顶点数据是 Spine 渲染最复杂的部分，
    // 通常需要遍历所有 Slot 并处理 Mesh 和 Region 附件。
    // 为了简化，这里仅绘制骨骼点进行可视化调试。
    painter.setBrush(Qt::red);
    painter.setPen(Qt::red);
    auto& bones = m_skeleton->getBones();
    for (size_t i = 0; i < bones.size(); ++i) {
        auto bone = bones[i];
        // 将 Spine 的世界坐标 (Y轴向下) 映射到 Qt 坐标系 (Y轴向上)
        int x = static_cast<int>(bone->getWorldX());
        int y = static_cast<int>(height() - bone->getWorldY());
        painter.drawEllipse(QPoint(x, y), 3, 3);
    }
}

void SpineWidget::timerEvent(QTimerEvent *) {
    if (!m_animState || !m_skeleton) return;
    // 更新动画状态和骨骼世界变换
    m_animState->update(1.0f / 60.0f);
    m_animState->apply(*m_skeleton);
    m_skeleton->updateWorldTransform();
    // 触发重绘
    update();
}

