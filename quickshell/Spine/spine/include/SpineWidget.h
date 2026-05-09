#ifndef SPINEWIDGET_H
#define SPINEWIDGET_H

#include <QWidget>
#include <QTimer>
#include <memory>
#include <spine/spine.h>

class SpineWidget : public QWidget {
    Q_OBJECT
public:
    explicit SpineWidget(QWidget *parent = nullptr);
    ~SpineWidget();

protected:
    void paintEvent(QPaintEvent *event) override;
    void timerEvent(QTimerEvent *event) override;

private:
    void initSpine(const char* skeletonPath, const char* atlasPath);

    // Spine 相关资源 (使用智能指针自动管理内存)
    std::unique_ptr<spine::Atlas> m_atlas;
    std::unique_ptr<spine::SkeletonBinary> m_binary;
    std::unique_ptr<spine::SkeletonData> m_skeletonData;
    std::unique_ptr<spine::Skeleton> m_skeleton;
    std::unique_ptr<spine::AnimationStateData> m_animStateData;
    std::unique_ptr<spine::AnimationState> m_animState;
};
#endif // SPINEWIDGET_H
