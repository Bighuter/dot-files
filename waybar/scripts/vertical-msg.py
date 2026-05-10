

#!/usr/bin/env python3
"""
Waybar 垂直随机消息模块
使用：保存在 ~/.config/waybar/scripts/vertical-msg.py
权限：chmod +x ~/.config/waybar/scripts/vertical-msg.py
"""

import json
import random
import sys
import os
from pathlib import Path

class VerticalMessage:
    def __init__(self):
        # 默认消息列表（垂直排列，每行一个元素）
        self.default_messages = [
            ["🌟", "保", "持", "积", "极"],
            ["🚀", "继", "续", "前", "进"],
            ["💡", "新", "的", "想", "法"],
            ["⚡", "充", "满", "能", "量"],
            ["🌈", "美", "好", "的", "一", "天"],
            ["🎯", "专", "注", "目", "标"],
            ["🔄", "拥", "抱", "变", "化"],
            ["🌱", "每", "天", "成", "长"],
            ["🎨", "发", "挥", "创", "造", "力"],
            ["📚", "持", "续", "学", "习"]
        ]
        
        # 尝试从外部文件加载消息
        self.message_file = Path.home() / ".config/waybar/vertical-messages.txt"
        self.messages = self.load_messages()
    
    def load_messages(self):
        """从文件加载消息，文件格式为每行一个消息，用空格分隔字符"""
        if self.message_file.exists():
            try:
                with open(self.message_file, 'r', encoding='utf-8') as f:
                    messages = []
                    for line in f:
                        line = line.strip()
                        if line:
                            # 将一行文本拆分为字符列表
                            chars = list(line)
                            if chars:
                                messages.append(chars)
                    if messages:
                        return messages
            except Exception as e:
                print(f"加载消息文件失败: {e}", file=sys.stderr)
        
        # 使用默认消息
        return self.default_messages
    
    def get_random_message(self):
        """获取随机消息并格式化为垂直文本"""
        message_parts = random.choice(self.messages)
        
        # 将字符列表连接为换行分隔的字符串
        vertical_text = "\n".join(message_parts)
        
        return vertical_text
    
    def get_tooltip(self, vertical_text):
        """生成工具提示文本"""
        horizontal_text = vertical_text.replace("\n", "")
        return f" {horizontal_text}"
    
    def generate_output(self):
        """生成Waybar JSON输出"""
        vertical_text = self.get_random_message()
        
        output = {
            #"text": vertical_text,
            "text": "@",
            "tooltip": self.get_tooltip(vertical_text),
            "class": "vertical-message",
            "alt": "vertical-random-msg"
        }
        
        return json.dumps(output)

def main():
    # 检查是否有参数指定刷新间隔（可选）
    vm = VerticalMessage()
    print(vm.generate_output())
    # 如果需要持续运行模式（带间隔）
    if len(sys.argv) > 1 and sys.argv[1] == "loop":
        import time
        interval = int(sys.argv[2])+random.randint(-600,600) if len(sys.argv) > 2 else 60+random.randint(-40,40)
        while True:
            print(vm.generate_output(), flush=True)
            time.sleep(interval)

if __name__ == "__main__":
    main()
