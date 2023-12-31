#!/bin/bash

THEME="Tokyonight-Storm-BL"
ICONS="Tokyonight-Moon"
FONT="JetBrainsMono NF 11"
CURSOR="Adwaita"

SCHEMA="gsettings set org.gnome.desktop.interface"

apply() {
	${SCHEMA} gtk-theme "$THEME"
	${SCHEMA} icon-theme "$ICONS"
	${SCHEMA} font-name "$FONT"
	${SCHEMA} cursor-theme "$CURSOR"
}

apply
