#include <spine/include/spine.h>

// 2. 创建一个骨骼对象，并加载数据
int main() {
    // === 前提条件 ===
    MyTextureLoader textureLoader;
    spine::Atlas atlas("data/spineboy.atlas", &textureLoader);
    spine::SkeletonJson json(&atlas);
    spine::SkeletonData* skeletonData = json.readSkeletonDataFile("data/spineboy.json");

    // 构建动画播放器的状态，并创建具体骨架
    spine::Skeleton skeleton(skeletonData);
    spine::AnimationStateData stateData(skeletonData);
    spine::AnimationState state(&stateData); // 通过动画状态数据创建动画状态对象

    // === 让你的角色动起来 ===
    // （下面这些是每帧循环中要执行的 Live 代码）
    // 设定混合时间，实现动画间的平滑过渡
    stateData.setDefaultMix(0.3f); 

    // 播放指定轨道上的动画
    state.setAnimation(0, "walk", true); 

    // 在游戏循环中更新
    float deltaTime = 0.016f; // 一般来自系统计时器
    state.update(deltaTime);     // 更新动画状态
    state.apply(skeleton);       // 将动画数据应用到骨骼
    skeleton.updateWorldTransform(); // 根据骨骼姿态更新所有骨骼的世界变换矩阵

    // 获取并处理渲染数据：这部分由开发者自己实现渲染逻辑
    // 通过遍历骨架的插槽(Slot)，获取每个部分的网格和材质信息并调用图形API渲染。
}
