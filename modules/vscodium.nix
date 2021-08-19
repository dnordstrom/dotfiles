{ stdenv, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      editorconfig.editorconfig
      bbenoist.nix
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
      {
        name = "vscode-nonicons";
        publisher = "yamatsum";
        version = "0.0.7";
        sha256 = "sha256-MHXj98zgPAZKXEwdubAdrZV4F00/ffpFTsM740Mzd/A=";
      }
      {
        name = "highlight-matching-tag";
        publisher = "vincaslt";
        version = "0.10.1";
        sha256 = "sha256-gcuBQsLItH2MP9GRgZ3jibb89Onwp+zfQKer7iO/Mi0=";
      }
      {
        name = "viml";
        publisher = "XadillaX";
        version = "1.0.1";
        sha256 = "sha256-mzf2PBSbvmgPjchyKmTaf3nASUi5/S9Djpoeh0y8gH0=";
      }
    ];
    userSettings = builtins.fromJSON (builtins.readFile ../config/vscode/settings.json);
    keybindings = builtins.fromJSON (builtins.readFile ../config/vscode/keybindings.json);
  };
}
