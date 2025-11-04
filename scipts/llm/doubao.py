#!/usr/bin/python

from pathlib import Path
import toml
import sys

import os
from openai import OpenAI
import tomli
import tomli_w

# cache = os.path.expanduser('~/.cache/chat/chat.toml')
cache = os.path.expanduser('/tmp/chat.toml')

def chat(messages):
    client = OpenAI(
        # Make sure the environment variable "ARK_API_KEY" has been set.
        api_key=os.environ.get("DOUBAO_API_KEY"), 
        # The base URL for model invocation .
        base_url="https://ark.cn-beijing.volces.com/api/v3",
        )
    completion = client.chat.completions.create(
    # Get Model ID: https://www.volcengine.com/docs/82379/1330310 .
        model="doubao-seed-1-6-251015",
        messages=messages,
        stream=True
    )

    with completion: # 确保在代码块执行完毕后自动关闭连接，避免链接泄露
        for chunk in completion:
            if chunk.choices[0].delta.content is not None:
                yield chunk.choices[0].delta.content

def chat_history(args):
    messages = ""
    with open(cache, "ab+") as f:
        try:
            history = tomli.load(f)
            messages = history['messages']
        except:
            messages = [
                    {
                        "role":"system",
                        "content":"输出时不要使用*或**的markdown语法，可以使用#等的markdown语法"
                        }
                    ]
        message = {
                "role":"user",
                "content": "".join(args)
                }
        messages.append(message)
        content = ""
        for i in chat(messages):
            content += i
            print(i, flush=True, end="")
        message = {
                "role":"assistant",
                "content":content
                }
        messages.append(message)
    with open(cache, "wb+") as f:
        tomli_w.dump({"messages":messages}, f)

if __name__ == '__main__':
    chat_history(sys.argv[1:])
