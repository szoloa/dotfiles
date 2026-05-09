#!/usr/bin/python

# Sum all of vedio length in current path.

import os
import subprocess
import json
from datetime import timedelta

def get_video_duration(filepath):
    """使用 ffprobe 获取单个视频文件的时长（秒）"""
    command = [
        'ffprobe',
        '-v', 'quiet',
        '-print_format', 'json',
        '-show_format',
        filepath
    ]
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        metadata = json.loads(result.stdout)
        if 'format' in metadata and 'duration' in metadata['format']:
            return float(metadata['format']['duration'])
        else:
            print(f"警告: 无法获取文件 '{filepath}' 的时长信息。")
            return 0.0
    except FileNotFoundError:
        print("错误: 'ffprobe' 命令未找到。请确保 ffmpeg 已经安装并配置在系统的 PATH 中。")
        exit(1)
    except subprocess.CalledProcessError:
        print(f"错误: 处理文件 '{filepath}' 时出错。文件可能已损坏或不是有效的视频文件。")
        return 0.0
    except json.JSONDecodeError:
        print(f"错误: 解析 ffprobe 输出时出错（文件: '{filepath}'）。")
        return 0.0

def main():
    """主函数，扫描目录并计算总时长"""
    target_directory = '.'
    total_seconds = 0
    video_extensions = ['.flv', '.mp4', '.mkv', '.avi', '.mov', '.wmv']

    # print(f"正在扫描目录 '{os.path.abspath(target_directory)}' 中的视频文件...")

    for filename in os.listdir(target_directory):
        # 检查文件扩展名是否为支持的视频格式
        if any(filename.lower().endswith(ext) for ext in video_extensions):
            filepath = os.path.join(target_directory, filename)
            if os.path.isfile(filepath):
                duration = get_video_duration(filepath)
                total_seconds += duration

    # 格式化总时长
    total_duration_formatted = str(timedelta(seconds=round(total_seconds)))

    print(f"所有视频文件的总时长为: {total_duration_formatted}")

if __name__ == '__main__':
    main()
