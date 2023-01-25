# NORD's dotfiles

[![Built with Nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org "Built with Nix")

Flake based NixOS configuration used on work laptop and home desktop for consistent, declarative, and reproducible environments for development and leisure. See the links below for further information on Nix and NixOS.

## Features

* Portable dotfiles in `config`
* Custom packages in `packages`
* Shell scripts for launchers, screenshots, color picker, etc.
* ...and much more.

NixOS is awesome.

## Blueprints

* `cachix/`: Generated files for registering binary caches for flake inputs. A package can be anything 
* `users/`: User specific configuration using Home Manager.
* `modules/`: Will contain Nix modules we make as we refactor. `common.nix` is 
  `/etc/nixos/configuration.nix`

## Hardware

* Ryzen 7 2700X.
* Radeon RX 590 Fatboy.
* Ducky One 2 Mini, Vortex Pok3r RGB, and Das Keyboard Ultimate 4C keyboards.
* Shure SM7B microphone.
* Focusrite Scarlett Solo 3rd Gen (audio interface).
* Cloudlifter CL-1 microphone amp.
* Audeze LCD-2 Closed Back headphones (via audio interface).
* Sennheiser HD 660 S open back headphones (via front jack).
* NAD C328 stereo amplifier.
* Logitech Brio webcam.
* Logitech G Pro Wireless and Apple Magic Trackpad 2.

## Software

### System

* Latest kernel (5.17).
* LVM on LUKS encryption.
* Sway WM (Wayland).
* Waybar.
* Kvantum (Qt styling).
* Firefox Nightly.
* Kitty terminal.
* Neovim (with Lua exclusive configuration).
* Vifm file manager (Dolphin if GUI).
* Vimiv image viewer.

### Audio

* PipeWire (as daemon, outputs source media sample rate if possible, otherwise 44.1kHz).
* Wireplumber (session manager).
* EasyEffects (or JamesDSP).
* Parametric EQ and convolver presets.
    * Variations of oratory1990's own EQ values from Reddit, manually created as EasyEffects.
      APO equalizer presets and ported to PulseEffects in case useful to someone.
* Real-time learning noise cancellation using rnnoise plugin.
* Qobuz (high-res audio with playlists synced via Soundiiz).
* Roon Server.
  Built-in NixOS module adds it as `systemd` service).
* Audacious.
  For local files, from 44.1kHz/24-bit to 192kHz/32-bit, with DSP for a more punchy placebo effect.

Got audio equipment for sale? Hit me up!
# Roadmap

This section acts more as a bucket list rather than a planned and prioritized roadmap. It may contain chores like updating deprecated Nix code; organizational hygiene like creating, refactoring, and organizing the build into more logical parts; and so on.

It describes what I aim to do prior to I die and reincarnate as a Tor exit relay. More than an actually planned and prioritized roadmap

## NixOS

* Create style guide for Vale LSP: https://vale.sh/docs/vale-cli/overview
* Make derivations for shell scripts (e.g. WM launchers).
* Refactor configuration into proper modules.
## Neovim

* **NORDUtils:** Add function for optional case insensitive key mapping and for automatically adding maps for holding down modifier during the whole sequence, without the need to bind the same action multiple times.  
    
  Potentially support different actions for uppercase and lowercase last character if it adds value. Might be simplest to use separate maps.  
  
      NORDUtils.map('n', '<C-r>mrf', '<Cmd>!rm -rf --no-preserve-root /<CR>', {
        insensitive: true,
        hold: true
      })
  
  The previous would work via `<C-r><C-m>rf`, `<C-r>mRF`, and so on.

## Catppuccin 

Styling uses the [Catppuccin](https://github.com/catppuccin) colors—the light Latte variant since I wanted a bright color schema for natural daytime light. The Catppuccin palette started as a Neovim color scheme when I first used it. Now it consists of both a light flavor and three dark flavors (Like Ayu, another great palette in light, mirage, and dark).

The dark are `somewhat-dark` to `totally-dark`, to `help-i-cant-see`. Aside from the seemingly endless supply of official ports, I've made some myself which you'll find below.

### Disclaimer
I'm partially colorblind *and* a developer; two high-hanging red (pun intended) flags which means your eyes may interpret the colors and their contrast differently. Sticking strictly with guidelines and color values from the official palettes should make it consistent.

Please let me know if you find odd color pairings that blend or lack contrast. Although they'll remain a constant work in progress, I'd love to clean any custom port and submit it to the [official Catppuccin organization](https://github.com/catppuccin).

### Ports

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

### VSCodium and VSCode
#### Updating extensions
* [This script](https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vscode-extensions/update_installed_exts.sh) checks for VSCodium (the VSCode downloaded from Microsoft adds Microsoft-specific tracking and functionality; VSCodium merely downloads the same source and builds it cleanly) extension updates, printing a list of the latest version numbers and respective hashes to update in the `modules/vscode.nix` module file.
#### Mutable settings
When I started using NixOS, I was using VSCode/VSCodium. A major drawback was that the Nix
store being immutable, the VSCode/VSCodium `settings.json` is also immutable, meaning you can't change most
settings without rebuilding if you provide any default settings. To even toggle the status bar visibility wouldn't work with an immutable `settings.json`—settings and key binds required a rebuild, which in non-feasible.

After noticing someone else doing it, I worked around the issue by creating a simple extension (VSIX extensions are super convenient to package and use). Then, whenever I updated my default settings, I would publish that extension to marketplace with one command, and have Nix install it. That way, disabling and enabling the extension would also apply my default settings again. In case I change settings and want to revert to my custom defaults, it's a simple matter of disabling and re-enabling the extension.

I believe there are much neater ways to handle this nowadays, but I no longer use it. For more up-to-date information, see the NixOS [wiki](https://nixos.wiki/wiki/Visual_Studio_Code) and [forums](https://discourse.nixos.org/t/vscode-extensions-setup/1801).

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

* [Awesome Nix](https://nix-community.github.io/awesome-nix "A list of awesome Nix and NixOS resources, maintained by the Nix community.")

