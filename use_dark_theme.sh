#!/usr/bin/env sh

set -eu

printf "\n%s" "Switching GTK and QT/Kvantum to dark theme... "

FONT="Input Regular 9"
GTK_THEME="Ayu-Mirage-Dark"
GTK_ICON_THEME="Flat-Remix-Yellow-Dark"
GTK_SCHEMA="org.gnome.desktop.interface"
KVANTUM_THEME="AyuMirage"
SCRIPT_PATH="$(dirname "$(realpath -s "$0")")"

# Set GTK3+ theme
gsettings set $GTK_SCHEMA gtk-theme "$GTK_THEME"
gsettings set $GTK_SCHEMA icon-theme "$GTK_ICON_THEME"
gsettings set $GTK_SCHEMA font-name "$FONT"
gsettings set $GTK_SCHEMA document-font-name "$FONT"

# Set Kvantum theme
kvantummanager --set "$KVANTUM_THEME"

# .Xdefaults (urxvt does not read .Xresources on launch)
ln -sf "$SCRIPT_PATH/Xresources/.Xresources.ayu-mirage" "$HOME/.Xdefaults"

# Termite
mkdir -p "$HOME/.config/termite"
ln -sf "$SCRIPT_PATH/termite/config.ayu-mirage" "$HOME/.config/termite/config"

# Alacritty
sed -i -e 's/^colors:.*$/colors: \*ayu_mirage/' "$SCRIPT_PATH/alacritty/alacritty.yml"

#
# Done
#

printf "%s\n\n" "Done."
