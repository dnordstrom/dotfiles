#!/usr/bin/env sh

set -eu

swaymsg -t get_inputs | grep -m1 "xkb_active_layout_name" | cut -d '"' -f4
