{ pkgs, ... }:

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
      {
        name = "rewrap";
        publisher = "stkb";
        version = "1.14.0";
        sha256 = "sha256-qRwKX36a1aLzE1tqaOkH7JfE//pvKdPZ07zasPF3Dl4=";
      }
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
    ];
    userSettings = {
      "window.menuBarVisibility" = "toggle";

      "editor.codeActionsOnSave" = {
        "source.fixAll.eslint" = true;
      };
      "editor.detectIndentation" = false;
      "editor.insertSpaces" = true;
      "editor.tabSize" = 2;

      "explorer.confirmDelete" = false;
	    "explorer.confirmDragAndDrop" = false;

      "workbench.colorTheme" = "Ayu Mirage";

      "rewrap.autoWrap.enabled" = true;
      "rewrap.autoWrap.notification" = "text";
      "rewrap.reformat" = true;
      "rewrap.wholeComment" = true;
      
      "eslint.alwaysShowStatus" = true;
      "eslint.packageManager" = "yarn";
      "eslint.options" = {
        "extensions" = [
          ".html"
          ".js"
          ".vue"
          ".jsx"
          ".ts"
          ".tsx"
        ];
      };
    };
    keybindings = [
      # UI
      {
        key = "ctrl+alt+b";
        command = "workbench.action.toggleActivityBarVisibility";
      }
      {
        key = "alt+b";
        command = "workbench.action.toggleStatusbarVisibility";
      }
      {
        key = "ctrl+b";
        command = "workbench.action.toggleSidebarVisibility";
      }
      {
        # Hide search bar on escape
        key = "escape";
        command = "closeFindWidget";
        when = "editorFocus && findWidgetVisible";
      }

      # Command palette
      {
        # Ctrl + Space shows command palette
        key = "ctrl+space";
        command = "workbench.action.showCommands";
        when = "!inQuickOpen";
      }
      {
        # Another Ctrl + Space shows quick open
        key = "ctrl+space";
        command = "workbench.action.quickOpen";
        when = "inQuickOpen && inCommandsPicker";
      }
      {
         # A third Ctrl + Space shows symbols in workspace
        key = "ctrl+space";
        command = "workbench.action.gotoSymbol";
        when = "inQuickOpen && inFilesPicker";
      }
      {
        # A fourth Ctrl + Space shows snippets
        key = "ctrl+space";
        command = "editor.action.showSnippets";
        when = "inQuickOpen && inFileSymbolsPicker";
      }
      {
        # A fifth Ctrl + Space hides quick open panel
        key = "ctrl+space";
        command = "workbench.action.closeQuickOpen";
        when = "inQuickOpen && !inCommandsPicker && !inFilesPicker && !inFileSymbolsPicker";
      }
    ];
  };
}