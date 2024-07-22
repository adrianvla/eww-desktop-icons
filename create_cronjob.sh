#!/bin/bash

# Install inotify-tools if not already installed
sudo pacman -S inotify-tools

# Watch for changes in the Desktop directory and update icons
while inotifywait -e create,delete,modify $HOME/Desktop; do
    # Resize images and regenerate Eww widget
    ~/resize_images.sh
    ~/generate_eww_widgets.sh
    eww reload
done
