#!/usr/bin/pythin

from pathlib import Path
import time
import toml

cache = Path(f'~/.cache/chat/chat-{int(time.time())}.toml')

print(cache)


