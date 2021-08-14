{ stdenv, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      editorconfig.editorconfig
      bbenoist.Nix
      foxundermoon.shell-format
      skyapps.fish-vscode
      graphql.vscode-graphql
      dbaeumer.vscode-eslint
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Run the update script at config/vscode/update_installed_exts.sh to get
      # the latest versions and hashes of these manually fetched extensions.
      {
        name = "rewrap";
        publisher = "stkb";
        version = "1.14.0";
        sha256 = "sha256-qRwKX36a1aLzE1tqaOkH7JfE//pvKdPZ07zasPF3Dl4=";
      }
      {
        name = "ayu";
        publisher = "teabyii";
        version = "0.20.2";
        sha256 = "1ca6m6li6p63nylzppanmqfi10ss9swrmfk3yj2zsv0hrl959s81";
      }
      {
        name = "raiju";
        publisher = "TobiasTimm";
        version = "2.2.2";
        sha256 = "sha256-Pl7qwHXOOu9joEKICPros8NFcCVRgBDEu55PJHl/Ajg=";
      }
      {
        name = "nord-visual-studio-code";
        publisher = "arcticicestudio";
        version = "0.18.0";
        sha256 = "sha256-Uo6peR+2ZNX6nwJ0Yar32Pe0rfBZ+f6ef1cYhUvVUbE=";
      }
    ];
    userSettings = builtins.fromJSON (builtins.readFile ../config/vscode/settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ../config/vscode/keybindings.json);
  };
}
