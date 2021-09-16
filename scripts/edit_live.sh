#
# Links local `.config` directories to `/etc/nixos`, allowing "live" editing to
# see changes without rebuilding. Asks for confirmation before deleting to
# prevent any accidents.
#

rm -ri .config/waybar
ln -s /etc/nixos/config/waybar ~/.config/waybar

rm -ri .config/sway
ln -s /etc/nixos/config/sway ~/.config/sway
