{ pkgs, ... }:

{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.nix-direnv.enableFlakes = true;

  programs.zsh.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # Extensions
      editorconfig.editorconfig
      bbenoist.Nix
      foxundermoon.shell-format
      jnoortheen.nix-ide
      skyapps.fish-vscode
      graphql.vscode-graphql
      dbaeumer.vscode-eslint

      # Themes
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "ayu";
        publisher = "teabyii";
        version = "0.20.1";
        sha256 = "sha256-sKZIhFRx3Dt7bvfSdqhJD3L30n9qQyJkqzXCvRmwNEE=";
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
        name = "rewrap";
        publisher = "stkb";
        version = "1.14.0";
        sha256 = "sha256-qRwKX36a1aLzE1tqaOkH7JfE//pvKdPZ07zasPF3Dl4=";
      }
    ];
    userSettings = {
      "editor.codeActionsOnSave" = {
        "source.fixAll.eslint" = true;
      };
    };
  };
}
