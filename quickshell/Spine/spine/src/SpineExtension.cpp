// 文件名: SpineExtension.cpp

#include <spine/Extension.h>

using namespace spine;

SpineExtension* spine::getDefaultExtension() {
    // 使用 Spine 提供的默认实现，基于标准C库
    static DefaultSpineExtension extension;
    return &extension;
}
