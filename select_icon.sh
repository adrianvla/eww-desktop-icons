#!/bin/bash

FILE=$1
ICON_SIZE="128x128"  # Desired icon size

# Path to the directory where resized images will be stored
RESIZED_ICONS_DIR="$HOME/.icons/resized"

# Create the directory if it doesn't exist
mkdir -p "$RESIZED_ICONS_DIR"

# Check if the argument is a directory
if [ -d "$FILE" ]; then
    echo "$HOME/.icons/folder_icon.svg"
    exit 0
fi
# Check the file type
FILE_TYPE=$(file --mime-type -b "$FILE")

case "$FILE_TYPE" in
    image/*)
        # Prepare the path for the resized icon
        ICON_PATH="$RESIZED_ICONS_DIR/$(basename "$FILE")"

        # Resize the image if it does not already exist
        if [ ! -f "$ICON_PATH" ]; then
            convert "$FILE" -resize $ICON_SIZE "$ICON_PATH"
        fi

        echo "$ICON_PATH"
        ;;
    *)
        echo "$HOME/.icons/Gruvbox-Plus-Dark/mimetypes/scalable/${FILE_TYPE//\//-}.svg"
        ;;
esac
