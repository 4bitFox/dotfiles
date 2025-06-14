#!/bin/bash

ACTION="$*"

cd /var/home/cvetkofabian/.config/niri


# Hardcoded 5% steps for 255 max
STEPS=(0 13 26 38 51 64 77 89 102 115 128 140 153 166 179 191 204 217 230 242 255)

CURRENT=$(brightnessctl g)

# Find index of the closest step
closest_index=0
smallest_diff=1000
for i in "${!STEPS[@]}"; do
    diff=$(( CURRENT - STEPS[i] ))
    diff=${diff#-}  # absolute value
    if (( diff < smallest_diff )); then
        smallest_diff=$diff
        closest_index=$i
    fi
done

# Adjust index based on action
if [[ "$ACTION" == "increase" ]]; then
    ((closest_index++))
else
    ((closest_index--))
fi

# Clamp index within bounds
if (( closest_index < 0 )); then closest_index=0; fi
if (( closest_index >= ${#STEPS[@]} )); then closest_index=$((${#STEPS[@]} - 1)); fi

# Set the new brightness
brightnessctl s "${STEPS[closest_index]}"






# Calculate current brightness percentage for notification
CURRENT=$(brightnessctl g)
MAX=$(brightnessctl m)
CURRENT_PCT=$(echo "scale=0; 100 * $CURRENT / $MAX" | bc)

# Choose an icon (simple sun icon for brightness)
ICON=""

# Send notification with current brightness percentage
./qs-notification.bash "$ICON Brightness set to ${CURRENT_PCT}%"
