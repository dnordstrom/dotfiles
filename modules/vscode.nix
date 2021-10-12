{ stdenv, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      dbaeumer.vscode-eslint
      editorconfig.editorconfig
      foxundermoon.shell-format
      graphql.vscode-graphql
      jnoortheen.nix-ide
      mikestead.dotenv
      skyapps.fish-vscode
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # My own configuration initializer instead of providing settings as JSON,
      # to allow options to be toggled normally (mutable `settings.json`).
      {
        name = "nord-defaults";
        publisher = "dnordstrom";
        version = "0.0.2";
        sha256 = "sha256-B+yDKfbCBALb1LDUI1w+pUTc2W194kR8JFJ+h8f5XlQ==";
      }
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
        name = "viml";
        publisher = "XadillaX";
        version = "1.0.1";
        sha256 = "sha256-mzf2PBSbvmgPjchyKmTaf3nASUi5/S9Djpoeh0y8gH0=";
      }
      {
        name = "toggler";
        publisher = "hideoo";
        version = "0.2.0";
        sha256 = "sha256-7b4ii7cPVHg0UnHW5PnEXJp7QOc9Jae56/tEtoN/M14=";
      }
      {
        name = "vscode-toggle-quotes";
        publisher = "britesnow";
        version = "0.3.4";
        sha256 = "sha256-KpTk2IWpVqrJeOlplU4knir6J62N+z0RNB8PsnxfMa8=";
      }
      {
        name = "js-auto-backticks";
        publisher = "chamboug";
        version = "0.0.1";
        sha256 = "sha256-l3xDkd9DcOLeATvvXd6DqX5mPTn0na79yd+12qZQnM4=";
      }
      {
        name = "Bookmarks";
        publisher = "alefragnani";
        version = "13.1.0";
        sha256 = "sha256-dj454ZLzoKPktT8LCP0h8zAMIVkKGDrbHrOQfejaIEE=";
      }
      {
        name = "better-comments";
        publisher = "aaron-bond";
        version = "2.1.0";
        sha256 = "sha256-l7MG2bpfTgVgC+xLal6ygbxrrRoNONzOWjs3fZeZtU4=";
      }
      {
        name = "i3";
        publisher = "dcasella";
        version = "0.0.1";
        sha256 = "sha256-Mn1QnwFOC5Gy9jnXJsoKt5S6/aKUJjxni4PR8RTVZlM=";
      }
      {
        name = "vscode-todo-plus";
        publisher = "fabiospampinato";
        version = "4.18.4";
        sha256 = "sha256-daKMeFUPZSanrFu9J6mk3ZVmlz8ZZquZa3qaWSTbSjs=";
      }
      {
        name = "auto-comment-next-line";
        publisher = "ctf0";
        version = "0.1.1";
        sha256 = "sha256-OjnhsZFA2rkobFz8px6X829vd7rTbcUzeZAwcHEmDm0=";
      }
    ];
    keybindings = builtins.fromJSON (builtins.readFile ../config/vscode/keybindings.json);
  };
}
