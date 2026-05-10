#!/bin/bash

# ========== 配置区域 ==========
# 设置代理（例如：http://127.0.0.1:7890），留空则禁用代理
PROXY="http://127.0.0.1:7890"
# =============================

# 如果设置了代理，则导出环境变量
if [ -n "$PROXY" ]; then
    export http_proxy="$PROXY"
    export https_proxy="$PROXY"
fi

# 忽略 SIGINT，防止模拟按键中断
trap '' SIGINT
(wtype -M ctrl c -m ctrl) 2>/dev/null
sleep 0.1
trap - SIGINT

# 获取剪贴板内容
text=$(wl-paste 2>/dev/null)
if [ -z "$text" ]; then
    notify-send "翻译" "未选中任何文本"
    exit 1
fi

#notify-send "翻译中..." "$text"

# 语言判断
if echo -n "$text" | LC_ALL=C.UTF-8 grep -qP '[\x{4e00}-\x{9fff}]'; then
    src="zh"
    target="en"
else
    src="en"
    target="zh"
fi

# 翻译（使用 Google 后端，指定源语言，5 秒超时）
result=$(timeout 5s echo "$text" | trans -b -no-ansi -e google -s "$src" ":$target" 2>&1)
exit_code=$?

if [ $exit_code -eq 124 ]; then
    notify-send -u critical "翻译超时" "请检查网络连接"
    exit 1
elif [ $exit_code -ne 0 ] || [ -z "$result" ]; then
    notify-send -u critical "翻译失败" "退出码: $exit_code\n$result"
    exit 1
fi

# 显示结果并复制
notify-send -t 6000 "$text" "$result"
echo -n "$result" | wl-copy
