#!/usr/bin/env sh
#
# Uses `slurp` to let us select an area to screenshot with `grim`.
#
# USAGE:
#   `./snap_area.sh [TARGET FILE]`
#

set -eu

ERRORS=false
FILE_MANAGER="nautilus"
IMAGE_VIEWER="imv"
OPTION_OPEN_FILE=false
OPTION_OPEN_DIR=false
OPTION_UPLOAD=false
OPTION_COPY=false
OPTION_HELP=false
OPTION_WINDOW=false
OPTION_SCREEN=false
HAS_CURL=false
AREA=""
TIMESTAMP="$(date '+%Y%m%d_%H_%M_%S')"
TARGET_DIR=${SCREENSNAP_TARGET_DIR:-"$HOME/Pictures/Screensnap"}
TARGET="$TARGET_DIR/$TIMESTAMP.png"
IMGUR_CLIENT_ID="${IMGUR_CLIENT_ID:=e4ab8199be97038}"
USAGE="USAGE:
    $(basename "$0") [options]
    $(basename "$0") [options] [target file]

DESCRIPTION:
    Take a screenshot of a region (default), window, or screen. The file path or URL (if uploaded) will be copied to clipboard and printed on screen. Optionally the image contents can be copied to clipboard.

OPTIONS:
    --help, -h        Show this help text
    --screen, -s      Select a screen
    --window, w       Select a window
    --upload, -u      Upload to Imgur
    --copy, -c        Copy image contents to clipboard
    --open, -o        Open with image viewer
    --directory, -d   Open containing directory"

# Check if cURL is available
! [ -x "$(command -v curl)" ] || HAS_CURL=true

# Parse flags and parameters. Credit to Richard Blechinger, see article at:
# https://pretzelhands.com/posts/command-line-flags
for arg in "$@"
do
  case $arg in
    -r|--region)
    OPTION_REGION=true
    shift
    ;;
    -s|--screen)
    OPTION_SCREEN=true
    shift
    ;;
    -w|--window)
    OPTION_WINDOW=true
    shift
    ;;
    -o|--open)
    OPTION_OPEN_FILE=true
    shift
    ;;
    -d|--directory)
    OPTION_OPEN_DIR=true
    shift
    ;;
    -u|--upload)
    OPTION_UPLOAD=true
    shift
    ;;
    -c|--copy)
    OPTION_COPY=true
    shift
    ;;
    -h|--help)
    OPTION_HELP=true
    shift
    ;;
    *)
    if [ -d "$(realpath "$1" > /dev/null 2>&1)" ]; then
      # Target is an existing directory
      TARGET="$(realpath "$1")/$TIMESTAMP.png"
    elif [ -d "$(dirname "$(realpath "$1" > /dev/null 2>&1)")" ]; then
      # Target parent is an existing directory, use as full file path
      TARGET="$(realpath "$(dirname "$1")")/$(basename "$1")"
      echo "$TARGET"
    else
      # Target is invalid
      TARGET=false
    fi
    shift
    ;;
  esac
done

# Show help if the --help (or -h) flag is used
if [ "$OPTION_HELP" = true ]; then
  echo "$USAGE"
  exit 0
fi

# Checking if target is writable
if ! [ "$TARGET" = "false" ] && touch "$TARGET" > /dev/null 2>&1; then
  rm "$TARGET" > /dev/null 2>&1 # Remove temporary file
else
  echo "Cannot write to $TARGET. Please check that the directory exists and is writable."
fi

# Use slurp to select a screen, region, or window
if [ "$OPTION_WINDOW" = true ]; then
  AREA="$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)"
elif [ "$OPTION_SCREEN" = true ]; then
  AREA="$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp)"
else
  AREA="$(slurp)"
fi

# Take the screenshot
grim -g "$AREA" "$TARGET"

# Uses cURL to upload an image to Imgur. Credit to Bart Nagel, see script:
# https://github.com/tremby/imgur.sh
upload() {
  curl -s -H "Authorization: Client-ID $IMGUR_CLIENT_ID" -H "Expect: " -F "image=$1" https://api.imgur.com/3/image.xml
}

# Upload the screenshot to Imgur if the --upload (or -u) flag is used
if [ "$OPTION_UPLOAD" = true ] && [ "$HAS_CURL" = true ]; then
  RESPONSE=$(upload "@$TARGET") 2>/dev/null

  # The cURL command failed
  if RESPONSE=$(upload "@$TARGET"); then
    echo "Upload failed." >&2
    ERRORS=true
  fi

  # The cURL command succeeded but Imgur responded with error
  if echo "$RESPONSE" | grep -q 'success="0"'; then
    ERRORS=true
    MESSAGE="${RESPONSE##*<error>}"

    echo "Error message from Imgur:" >&2
    echo "${MESSAGE%%</error>*}" >&2
  fi

  # Parse the response
  URL="${RESPONSE##*<link>}"
  URL="${URL%%</link>*}"
  DELETE_HASH="${RESPONSE##*<deletehash>}"
  DELETE_HASH="${DELETE_HASH%%</deletehash>*}"

  # Get the image URL
  URL="${URL//http:/https:}" # | sed 's/^http:/https:/'
  TARGET="$URL"
elif [ "$OPTION_UPLOAD" = true ]; then
  # The upload flag was used but cURL is not available
  echo "Cannot find cURL, aborting upload. The screenshot is still saved locally." >&2
fi

if [ "$OPTION_COPY" = true ]; then
  # If the --copy (or -c) flag is used, copy the entire image to clipboard
  wl-copy < "$TARGET"
else
  # Otherwise copy the output (file path or image URL) to clipboard
  wl-copy "$TARGET"
fi

# Open the screenshot with image viewer if the --open (or -o) flag is used
[ "$OPTION_OPEN_FILE" = "true" ] || "$IMAGE_VIEWER" "$TARGET" 2> /dev/null &

# Open the containing directory if --directory (or -d) flag is used
[ "$OPTION_OPEN_DIR" = "true" ] || "$FILE_MANAGER" "$(basedir "$TARGET")" 2> /dev/null &

echo "$TARGET"

if $ERRORS; then
	exit 1
fi
