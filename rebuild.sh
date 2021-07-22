#!/usr/bin/env bash

nixos-rebuild build && sudo nix-env -p /nix/var/nix/profiles/system --set $(readlink -f ./result) && NIXOS_INSTALL_BOOTLOADER=1 sudo --preserve-env=NIXOS_INSTALL_BOOTLOADER ./result/bin/switch-to-configuration switch
