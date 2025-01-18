#!/bin/bash

BAT_CONFIG_DIR=$(bat --config-dir)
curl -L https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme -o $BAT_CONFIG_DIR/themes/

# Build cache so we can get the theme
bat cache --build
