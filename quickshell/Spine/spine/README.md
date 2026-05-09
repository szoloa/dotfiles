# Spine C++ Runtime 使用示例

## 项目结构

```
spine/
├── include/           # Spine 头文件
├── src/               # Spine 源文件
├── assets/            # 示例资源
│   └── akane/
│       ├── akane_spr.atlas
│       ├── akane_spr.png
│       └── akane_spr.skel
├── example.cpp        # 示例代码
└── CMakeLists.txt     # 构建配置
```

## 编译步骤

### 使用 CMake

```bash
# 创建构建目录
mkdir build
cd build

# 配置项目
cmake ..

# 编译
cmake --build .

# 运行示例
./spine_example
```

### 直接使用 g++

```bash
# 包含头文件
g++ -std=c++17 -I./include example.cpp -o spine_example

# 运行
./spine_example
```

## 示例说明

这个示例展示了 Spine C++ Runtime 的基本使用流程：

### 1. 加载 Atlas
```cpp
spine::FileTextureLoader textureLoader;
spine::Atlas* atlas = new spine::Atlas(atlasPath, &textureLoader);
```

### 2. 创建 AttachmentLoader 并加载骨骼数据
```cpp
spine::AtlasAttachmentLoader attachmentLoader(atlas);
spine::SkeletonJson json(&attachmentLoader);
json.setScale(1.0f);
spine::SkeletonData* skeletonData = json.readSkeletonDataFile(skeletonPath);
```

### 3. 创建 AnimationStateData 和 AnimationState
```cpp
spine::AnimationStateData* stateData = new spine::AnimationStateData(skeletonData);
spine::AnimationState* state = new spine::AnimationState(stateData);

// 设置监听器
ConsoleAnimationListener listener;
state->setListener(&listener);
```

### 4. 创建 Skeleton 实例
```cpp
spine::Skeleton* skeleton = new spine::Skeleton(skeletonData);
skeleton->setPosition(400.0f, 300.0f);
skeleton->setScale(1.0f, 1.0f);
```

### 5. 播放动画
```cpp
// 播放 idle 动画（循环）
spine::TrackEntry* entry = state->setAnimation(0, "idle", true);

// 切换到 walk 动画
state->clearTracks();
spine::TrackEntry* entry2 = state->setAnimation(0, "walk", true);
```

### 6. 更新循环
```cpp
float deltaTime = 1.0f / 60.0f;  // 60 FPS

while (running) {
    state->update(deltaTime);
    state->apply(*skeleton);
    skeleton->updateWorldTransform();

    // 渲染骨骼...
}
```

## 关键类说明

| 类 | 说明 |
|---|---|
| `Skeleton` | 骨骼实例，包含所有骨骼、插槽和附件 |
| `SkeletonData` | 骨骼数据，从 JSON/Skeleton 文件加载 |
| `SkeletonJson` | 从 JSON/Skeleton 文件加载骨骼数据 |
| `AnimationState` | 管理动画播放和混合 |
| `AnimationStateData` | 动画状态数据，设置混合时长等 |
| `TrackEntry` | 轨道条目，控制单个动画轨道 |
| `Atlas` | 纹理图集，包含所有纹理区域 |
| `AtlasAttachmentLoader` | 从 Atlas 加载附件 |
| `Bone` | 骨骼节点 |
| `Slot` | 插槽，附加附件到骨骼 |

## 动画事件类型

- `EventType_Start` - 动画开始播放
- `EventType_Interrupt` - 动画被中断
- `EventType_End` - 动画结束
- `EventType_Complete` - 动画完成（非循环）
- `EventType_Dispose` - 动画被释放
- `EventType_Event` - 动画触发事件

## 注意事项

1. **资源管理**：确保在程序结束时释放所有分配的资源
2. **线程安全**：Spine runtime 不是线程安全的，所有操作应在同一线程进行
3. **性能优化**：对于大量骨骼，考虑使用对象池
4. **混合时长**：通过 `AnimationStateData::setMix()` 设置动画之间的混合时长
5. **缩放**：使用 `SkeletonJson::setScale()` 设置全局缩放

## 扩展功能

示例中展示了基础的动画播放，还可以扩展：

- 多轨道动画混合
- 自定义骨骼变换
- 事件处理和响应
- 骨骼边界检测
- 剪裁渲染
- 自定义附件加载器
