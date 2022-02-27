# NixOS system setup

Flake based configuration used on a Dell XPS work laptop as well as my Ryzen 7 home desktop. It uses the unstable channel (which is actually very stable) for packages, and it's a constant work in progress. See the links below for further information on Nix and NixOS.

## Catppuccin 

The setup is styled based on the [Catppuccin](https://github.com/catppuccin) colors. Aside from using the official themes I've created a few ports you can find below. Just note that I'm not a designer and that these are a constant work in progress:

* [Firefox](https://addons.mozilla.org/en-US/firefox/addon/catppuccinito-for-color/)
  ([userContent.css](https://github.com/dnordstrom/dotfiles/blob/main/config/firefox/chrome/userContent.css) for about:blank)
* [Tridactyl](https://github.com/dnordstrom/dotfiles/blob/main/config/firefox/tridactyl/themes/catppuccin.css)
* [Mako](https://github.com/dnordstrom/dotfiles/blob/main/config/mako/config) (or in [Home
  Manager](https://github.com/dnordstrom/dotfiles/blob/e8537da24030315fc815c4a67e786d562d0e58c8/users/dnordstrom.nix#L992))
* [Slack](https://github.com/dnordstrom/dotfiles/blob/main/config/slack/catppuccin.colors)
* [Sway WM](https://github.com/dnordstrom/dotfiles/blob/main/config/sway/colors.catppuccin)
* [Waybar](https://github.com/dnordstrom/dotfiles/blob/main/config/waybar/style.css)
* [Wofi](https://github.com/dnordstrom/dotfiles/blob/main/config/wofi/style.css)

## Notes

* [This script](https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vscode-extensions/update_installed_exts.sh) checks for VSCodium/VSCode extension updates so that one can update the version numbers and hashes accordingly in the module file.

## Links

### Official

* [NixOS](https://nixos.org/)
* [NixOS Manual](https://nixos.org/manual/nixos/unstable/)
* [Nix Manual](https://nixos.org/manual/nix/unstable/)
* [Package Search](https://search.nixos.org/packages?channel=unstable)
* [Options Search](https://search.nixos.org/options?channel=unstable)
* [Home Manager Manual](https://nix-community.github.io/home-manager/)
* [Home Manager Options](https://nix-community.github.io/home-manager/options.html)

### Articles

* [What Is Nix and Why Should You Use It](https://serokell.io/blog/what-is-nix)

### Resources

* [Awesome Nix](https://nix-community.github.io/awesome-nix/)

