#!/usr/bin/env python3
import sys
import json
import urllib.request
import urllib.parse
import re
import os
import hashlib
import base64

# ================= 配置区 =================
LYRICS_DIR = os.path.expanduser("~/.local/share/quickshell/lyrics")

ENABLE_TRANSLATION = True 

os.makedirs(LYRICS_DIR, exist_ok=True)

HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
}
# =========================================


# def get_cache_path(title, artist):
#     safe_name = f"{title}-{artist}".encode("utf-8", errors="ignore")
#     hash_str = hashlib.md5(safe_name).hexdigest()
#     return os.path.join(CACHE_DIR, f"{hash_str}.json")

def safe_filename(text):
    """替换文件名中不允许的字符"""
    return re.sub(r'[\\/*?:"<>|]', '_', text)


def get_lrc_path(title, artist):
    """生成 LRC 文件路径：歌曲-艺术家.lrc"""
    filename = f"{safe_filename(title)} - {safe_filename(artist)}.lrc"
    return os.path.join(LYRICS_DIR, filename)


def get_lyrics_path(title, artist):
    """根据歌曲信息生成持久化歌词文件路径"""
    safe_name = f"{title}-{artist}".encode("utf-8", errors="ignore")
    hash_str = hashlib.md5(safe_name).hexdigest()
    return os.path.join(LYRICS_DIR, f"{hash_str}.json")

def parse_lrc(lrc_text):
    """解析 LRC 文本为 [{time:秒, text:词}, ...]"""
    if not lrc_text:
        return []
    lines = []
    pattern = re.compile(r"\[(\d{2}):(\d{2})[\.:](\d{2,3})\](.*)")
    lrc_text = (
        lrc_text.replace("&apos;", "'").replace("&quot;", '"').replace("&amp;", "&")
    )

    for line in lrc_text.split("\n"):
        line = line.strip()
        if not line:
            continue
        match = pattern.match(line)
        if match:
            minutes = int(match.group(1))
            seconds = int(match.group(2))
            ms_str = match.group(3)
            ms = int(ms_str) * 10 if len(ms_str) == 2 else int(ms_str)
            total_seconds = minutes * 60 + seconds + ms / 1000
            text = match.group(4).strip()

            if text and not text.lower().startswith(
                ("offset:", "by:", "al:", "ti:", "ar:")
            ):
                lines.append({"time": total_seconds, "text": text})

    lines.sort(key=lambda x: x["time"])
    return lines

def merge_lyrics(original, translation, max_time_diff=0.5):
    """
    合并原文和翻译
    original: 原文歌词列表 [{"time": float, "text": str}]
    translation: 翻译歌词列表（相同结构）
    返回合并后的列表，其中 text = "原文\n译文"（若无译文则为原文）
    """
    if not original:
        return []
    if not translation:
        # 没有翻译，直接返回原文
        return [{"time": item["time"], "text": item["text"]} for item in original]

    merged = []
    trans_idx = 0
    trans_len = len(translation)

    for orig in original:
        orig_time = orig["time"]
        orig_text = orig["text"]

        # 寻找最接近的翻译（时间差最小的）
        best_match = None
        best_diff = max_time_diff
        # 从当前 trans_idx 开始向前后搜索一小段（最多10个）
        start = max(0, trans_idx - 5)
        end = min(trans_len, trans_idx + 5)
        for i in range(start, end):
            diff = abs(translation[i]["time"] - orig_time)
            if diff < best_diff:
                best_diff = diff
                best_match = translation[i]

        if best_match and best_match["text"]:
            combined = f"{orig_text}\n{best_match['text']}"
            # 更新 trans_idx 为最佳匹配的索引，用于下一轮
            trans_idx = translation.index(best_match) if best_match in translation else trans_idx
        else:
            combined = orig_text

        merged.append({"time": orig_time, "text": combined})

    return merged

def request_url(url, data=None, headers=None):
    if headers is None:
        headers = HEADERS
    try:
        req = urllib.request.Request(url, data=data, headers=headers)
        with urllib.request.urlopen(req, timeout=3) as response:
            return json.loads(response.read().decode())
    except Exception:
        return None


# --- 1. QQ 音乐源 (Priority 1) ---
def fetch_qq(track, artist):
    qq_headers = HEADERS.copy()
    qq_headers["Referer"] = "https://y.qq.com/"
    try:
        keyword = f"{track} {artist}"
        search_url = f"https://c.y.qq.com/soso/fcgi-bin/client_search_cp?w={urllib.parse.quote(keyword)}&format=json"
        search_data = request_url(search_url, headers=qq_headers)

        songmid = ""
        if (
            search_data
            and "data" in search_data
            and "song" in search_data["data"]
            and "list" in search_data["data"]["song"]
        ):
            song_list = search_data["data"]["song"]["list"]
            if song_list:
                songmid = song_list[0]["songmid"]

        if not songmid:
            return []

        lyric_url = f"https://c.y.qq.com/lyric/fcgi-bin/fcg_query_lyric_new.fcg?songmid={songmid}&format=json&nobase64=1"
        lyric_data = request_url(lyric_url, headers=qq_headers)

        if lyric_data and "lyric" in lyric_data:
            raw_lrc = lyric_data["lyric"]
            try:
                decoded_lrc = base64.b64decode(raw_lrc).decode("utf-8")
            except:
                decoded_lrc = raw_lrc
            return parse_lrc(decoded_lrc)
    except Exception:
        pass
    return []


# --- 2. 网易云音乐源 (Priority 2) ---
def fetch_netease(track, artist):
    search_url = "http://music.163.com/api/search/get/"
    ne_headers = HEADERS.copy()
    ne_headers["Referer"] = "http://music.163.com/"
    post_data = urllib.parse.urlencode(
        {"s": f"{track} {artist}", "type": 1, "offset": 0, "total": "true", "limit": 1}
    ).encode("utf-8")

    try:
        res = request_url(search_url, data=post_data, headers=ne_headers)
        if (
            res
            and "result" in res
            and "songs" in res["result"]
            and res["result"]["songs"]
        ):
            song_id = res["result"]["songs"][0]["id"]
            lyric_url = f"http://music.163.com/api/song/lyric?os=pc&id={song_id}&lv=-1&kv=-1&tv=-1"
            lrc_data = request_url(lyric_url, headers=ne_headers)
            if lrc_data:
                # 原文
                original_lrc = ""
                if "lrc" in lrc_data and "lyric" in lrc_data["lrc"]:
                    original_lrc = lrc_data["lrc"]["lyric"]
                # 翻译（网易云 tlyric 字段）
                translation_lrc = ""
                if ENABLE_TRANSLATION and "tlyric" in lrc_data and "lyric" in lrc_data["tlyric"]:
                    translation_lrc = lrc_data["tlyric"]["lyric"]

                orig_lyrics = parse_lrc(original_lrc)
                trans_lyrics = parse_lrc(translation_lrc) if translation_lrc else []
                return merge_lyrics(orig_lyrics, trans_lyrics)
    except Exception:
        pass
    return []

def save_lyrics_to_lrc(lyrics, file_path):
    """将歌词列表保存为 LRC 文件（每行 [mm:ss.cc] 文本）"""
    try:
        with open(file_path, "w", encoding="utf-8") as f:
            for item in lyrics:
                time_sec = item["time"]
                minutes = int(time_sec // 60)
                seconds = int(time_sec % 60)
                centiseconds = int((time_sec % 1) * 100)
                f.write(f"[{minutes:02d}:{seconds:02d}.{centiseconds:02d}]{item['text']}\n")
        return True
    except Exception as e:
        print(f"保存 LRC 失败: {e}", file=sys.stderr)
        return False

def save_lyrics_to_local(lyrics, path):
    """将歌词保存到本地文件"""
    try:
        with open(path, "w", encoding="utf-8") as f:
            json.dump(lyrics, f, ensure_ascii=False, indent=2)
        return True
    except Exception as e:
        print(f"保存歌词失败: {e}", file=sys.stderr)
        return False

def load_lyrics_from_lrc(file_path):
    """从 LRC 文件读取并解析为歌词列表"""
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            lrc_text = f.read()
        return parse_lrc(lrc_text)
    except Exception:
        return None

def load_lyrics_from_local(path):
    """从本地文件加载歌词"""
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return None

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps([{"time": 0, "text": "等待播放..."}]))
        sys.exit(0)

    title = sys.argv[1]
    artist = sys.argv[2] if len(sys.argv) > 2 else ""
    lyrics_path = get_lrc_path(title, artist)
    lyrics = load_lyrics_from_lrc(lyrics_path)
    if lyrics:
        print(json.dumps(lyrics))
        sys.exit(0)

    # if os.path.exists(cache_file):
    #     try:
    #         with open(cache_file, "r") as f:
    #             cached_data = json.load(f)
    #             if cached_data:
    #                 print(json.dumps(cached_data))
    #                 sys.exit(0)
    #     except:
    #         pass

    # 1. 尝试 QQ 音乐
    lyrics = fetch_qq(title, artist)

    # 2. 尝试 网易云音乐
    if not lyrics:
        lyrics = fetch_netease(title, artist)

    if not lyrics:
        lyrics = [{"time": 0, "text": "暂无歌词"}]
    else:
        save_lyrics_to_lrc(lyrics, lyrics_path)

    print(json.dumps(lyrics))
