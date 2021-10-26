#
# Links local `.config` directories to `/etc/nixos`, allowing "live" editing to
# see changes without rebuilding. Asks for confirmation before deleting to
# prevent any accidents.
#

# Remove local directories (symbolic links to NixOS build outputs)
rm -ri ~/.config/waybar
rm -ri ~/.config/sway

# Symlink files from NixOS configuration directory
ln -s /etc/nixos/config/sway ~/.config/sway
ln -s /etc/nixos/config/waybar ~/.config/waybar
