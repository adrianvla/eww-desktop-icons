#!/bin/bash

# Define the desktop folder
DESKTOP_FOLDER="$HOME/Desktop"

# Define the Eww configuration file path
EWW_CONFIG_FILE="$HOME/.config/eww/eww.yuck"

EWW_CONFIG_DIR="$HOME/.config/eww"

# Start with the initial configuration for the window
echo "
(defwindow main
  :monitor \"2\"  ;; Adjust this to your monitor
  :geometry (geometry
              :width \"100%\"
              :height \"100%\")
  :stacking \"bg\"
  :focusable false
  :wm-ignore true
  (box
    :orientation \"vertical\"
    :spacing 10
    :class \"desktop-icons\"
    " > "$EWW_CONFIG_FILE"


ROW_COUNT=0
MAX_BUTTONS_PER_ROW=12 # Adjust this value based on your needs
ROWS=0
TARGET_ROWS=8


# Create a container for rows
cat <<EOL >> "$EWW_CONFIG_FILE"
    (box
      :orientation "vertical"
      :spacing 5
      :class "desktop-items"
EOL

# Loop through each item in the desktop folder and generate the widget configuration
for ITEM in "$DESKTOP_FOLDER"/*; do
    ITEM_NAME=$(basename "$ITEM")
    ITEM_PATH=$(realpath "$ITEM")

    if [ $((ROW_COUNT % MAX_BUTTONS_PER_ROW)) -eq 0 ]; then
        if [ $ROW_COUNT -ne 0 ]; then

            ROWS=$((ROWS + 1))
            # Close the previous row
            cat <<EOL >> "$EWW_CONFIG_FILE"
            )
EOL
        fi
        # Start a new row
        cat <<EOL >> "$EWW_CONFIG_FILE"
        (box
          :orientation "horizontal"
          :spacing 5
          :class "desktop-row"
EOL
    fi
        cat <<EOL >> "$EWW_CONFIG_FILE"
        (button :onclick "xdg-open '$ITEM_PATH'" :tooltip "$ITEM_NAME" :class "desktop-item" 
            (box
            :orientation "vertical"
            :spacing 0
            :class "desktop-vertical-btn"
                (image :class "desktop-image" :path "$(bash $EWW_CONFIG_DIR/select_icon.sh "$ITEM_PATH")":image-height 128 :image-width 96)
                (box
                :orientation "vertical"
                :spacing 0
                :class "desktop-vertical-label"
                    (label :text "$ITEM_NAME" :class "desktop-label" :truncate true :limit-width 32)
                    (label :text "")
                    (label :text "")
                )
            )
        )
EOL
    # fi

    ROW_COUNT=$((ROW_COUNT + 1))
done


for (( i=ROW_COUNT % MAX_BUTTONS_PER_ROW; i<MAX_BUTTONS_PER_ROW; i++ )); do
    cat <<EOL >>  "$EWW_CONFIG_FILE"
(box
          :orientation "horizontal"
          :spacing 5
          :class "desktop-row")
EOL
done

cat <<EOL >> "$EWW_CONFIG_FILE"
    )
EOL



for (( i=ROWS; i<=TARGET_ROWS; i++ )); do
    cat <<EOL >>  "$EWW_CONFIG_FILE"
(box
          :orientation "horizontal"
          :spacing 5
          :class "desktop-row")
EOL
done


# Close the last row and container
cat <<EOL >> "$EWW_CONFIG_FILE"
    )
)
)
EOL

