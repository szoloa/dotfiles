#!/bin/bash

# 功能：获取英文单词的读音（播放音频）
# 依赖（可选，任选其一）：
#   - 在线模式：curl + (mplayer 或 mpg123 或 ffplay)
#   - 离线模式：espeak
# 用法：./pronounce.sh <单词> [--offline]

set -e

# 显示帮助信息
show_help() {
    cat << EOF
用法: $0 <单词> [选项]

选项：
  --offline    强制使用离线语音合成 (espeak)
  --help       显示本帮助信息

示例：
  $0 hello                # 在线播放 hello 的发音
  $0 "good morning"       # 支持短语
  $0 world --offline      # 使用 espeak 离线发音
EOF
    exit 0
}

# 参数解析
OFFLINE=false
WORD=""

for arg in "$@"; do
    case "$arg" in
        --help)
            show_help
            ;;
        --offline)
            OFFLINE=true
            ;;
        *)
            if [[ -z "$WORD" ]]; then
                WORD="$arg"
            else
                echo "错误：未知参数 '$arg'"
                show_help
            fi
            ;;
    esac
done

if [[ -z "$WORD" ]]; then
    echo "错误：请提供单词或短语"
    show_help
fi

# 检测播放器
find_player() {
    for player in mplayer mpg123 ffplay; do
        if command -v "$player" &>/dev/null; then
            echo "$player"
            return 0
        fi
    done
    return 1
}

# 在线发音（Google TTS）
online_pronounce() {
    local word="$1"
    local url="https://translate.google.com/translate_tts?ie=UTF-8&tl=en&q=$(echo "$word" | sed 's/ /%20/g')&client=tw-ob"
    local player
    player=$(find_player) || {
        echo "错误：在线发音需要 mplayer、mpg123 或 ffplay"
        return 1
    }

    echo "正在在线获取 '$word' 的读音 ..."
    # -A 模拟浏览器 User-Agent，避免被拒绝
    curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" "$url" | $player - 2>/dev/null
    if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
        echo "在线发音失败（可能网络问题或单词无效）"
        return 1
    fi
    echo "播放完成"
    return 0
}

# 离线发音（espeak）
offline_pronounce() {
    if ! command -v espeak &>/dev/null; then
        echo "错误：离线模式需要安装 espeak"
        echo "Ubuntu/Debian: sudo apt install espeak"
        echo "macOS: brew install espeak"
        return 1
    fi
    echo "正在离线合成 '$word' 的读音 ..."
    espeak -v en "$word" 2>/dev/null
    echo "播放完成"
    return 0
}

# 主逻辑
if [[ "$OFFLINE" == true ]]; then
    offline_pronounce "$WORD"
else
    online_pronounce "$WORD" || {
        echo "在线发音失败，是否尝试离线模式？(y/n)"
        read -r answer
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            offline_pronounce "$WORD"
        else
            exit 1
        fi
    }
fi
