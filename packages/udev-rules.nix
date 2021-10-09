{ config, pkgs }:

let
  name = "udev-rules";
in
pkgs.writeTextFile {
  name = "nord-udev-rules-uinput";
  text = ''
    ## Udev rule to fix ydotoold requiring sudo
    ## Source: https://github.com/ReimuNotMoe/ydotool/issues/25#issuecomment-535842993
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';
  destination = "/etc/udev/rules.d/99-nord-uinput.rules";
}

