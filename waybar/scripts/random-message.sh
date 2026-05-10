#!/bin/bash
# ~/.config/waybar/scripts/random-message.sh

MESSAGES=(
    "🌟 Stay positive!"
    "🚀 Keep moving forward"
    "💪 You've got this"
    "🎯 Focus on today"
    "🌈 Bright days ahead"
    "🔄 Change is good"
    "📚 Learn something new"
    "🎨 Create daily"
    "⚡ Energy flows"
    "🌱 Grow steadily"
)

# Optional: Load from file
CONFIG_FILE="$HOME/.config/waybar/random-messages.txt"
if [[ -f "$CONFIG_FILE" ]]; then
    mapfile -t MESSAGES < "$CONFIG_FILE"
fi

# Main loop
while true; do
    # Select random message
    RANDOM_INDEX=$((RANDOM % ${#MESSAGES[@]}))
    MESSAGE="${MESSAGES[$RANDOM_INDEX]}"
    
    # Output JSON for Waybar
    echo "{\"text\": \"$MESSAGE\", \"tooltip\": \"Click for new message\", \"class\": \"random-message\"}"
    
    # Wait 60 seconds before next update
    sleep 10
done
