# VSCodium Settings

VSCode extension to set custom settings unless they have not already been set.
Used for configuring VSCodium/VSCode on NixOS where `settings.json` is immutable
if managed by Home Manager.

## Usage

To compile and package as VSIX extension file:

`yarn compile && yarn package`

Note: Remember to bump the version number when making changes.

## Credit

Based on the [gilescope's](https://github.com/gilescope) [correctdefaults](https://github.com/gilescope/correctdefaults)
