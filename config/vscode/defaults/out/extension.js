"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
const vscode = require("vscode");
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    const config = vscode.workspace.getConfiguration();
    const cfg = JSON.parse(`
      {
        "[json]": {
          "editor.wordWrap": "off"
        },
        "[jsonc]": {
          "editor.wordWrap": "off"
        },
        "[plaintext]": {
          "editor.wordWrap": "off"
        },
        "autoCommentNextLine.list": [
            {
              "char": "//",
              "languages": [
                      "javascriptreact",
                      "javascript",
                      "typescript",
                      "typescriptreact",
                      "jsonc"
              ]
            },
            {
              "char": "#",
              "languages": [
                      "nix",
                      "shellscript",
                      "dockerfile"
              ]
            },
            {
              "char": "--",
              "languages": [
                        "lua"
              ]
            }
        ],
        "breadcrumbs.enabled": false,
        "editor.acceptSuggestionOnCommitCharacter": false,
        "editor.acceptSuggestionOnEnter": "smart",
        "editor.codeActionsOnSave": {
          "source.fixAll.eslint": true
        },
        "editor.colorDecorators": true,
        "editor.cursorSmoothCaretAnimation": false,
        "editor.definitionLinkOpensInPeek": true,
        "editor.dragAndDrop": false,
        "editor.emptySelectionClipboard": true,
        "editor.find.autoFindInSelection": "never",
        "editor.fontFamily": "'Input Mono Condensed', monospace",
        "editor.fontLigatures": true,
        "editor.fontSize": 13,
        "editor.fontWeight": "400",
        "editor.formatOnSave": false,
        "editor.formatOnType": false,
        "editor.hideCursorInOverviewRuler": true,
        "editor.inlineSuggest.enabled": true,
        "editor.lineHeight": 22,
        "editor.lineNumbers": "on",
        "editor.matchBrackets": "always",
        "editor.minimap.enabled": false,
        "editor.multiCursorModifier": "ctrlCmd",
        "editor.occurrencesHighlight": false,
        "editor.overviewRulerBorder": false,
        "editor.quickSuggestions": {
          "other": true,
          "comments": false,
          "strings": false
        },
        "editor.renderControlCharacters": true,
        "editor.renderIndentGuides": false,
        "editor.renderLineHighlight": "none",
        "editor.renderWhitespace": "all",
        "editor.roundedSelection": false,
        "editor.rulers": [
            80
        ],
        "editor.selectionHighlight": true,
        "editor.smoothScrolling": true,
        "editor.snippetSuggestions": "bottom",
        "editor.stickyTabStops": true,
        "editor.suggest.snippetsPreventQuickSuggestions": false,
        "editor.suggestSelection": "recentlyUsedByPrefix",
        "editor.tabSize": 2,
        "editor.wordWrap": "bounded",
        "editor.wordWrapColumn": 80,
        "editor.wrappingIndent": "same",
        "editor.wrappingStrategy": "advanced",
        "emmet.triggerExpansionOnTab": true,
        "eslint.alwaysShowStatus": true,
        "eslint.options": {
          "extensions": [
                ".html",
                ".js",
                ".vue",
                ".jsx",
                ".ts",
                ".tsx"
          ]
        },
        "eslint.packageManager": "yarn",
        "explorer.confirmDelete": false,
        "explorer.confirmDragAndDrop": false,
        "files.associations": {
          "*.cfg": "CSGO cfg",
          "tridactylrc": "VimL"
        },
        "files.exclude": {
          "**/.DS_Store": true,
          "**/.git": true,
          "**/.hg": true,
          "**/.svn": true,
          "**/.vscode": true,
          "**/CVS": true,
          "**/node_modules": true
        },
        "files.hotExit": "onExitAndWindowClose",
        "files.insertFinalNewline": true,
        "files.simpleDialog.enable": true,
        "files.trimTrailingWhitespace": true,
        "git.countBadge": "off",
        "git.decorations.enabled": false,
        "git.defaultCloneDirectory": "~/Code",
        "git.ignoreMissingGitWarning": true,
        "html.format.endWithNewline": true,
        "html.format.extraLiners": "head, body, /html",
        "javascript.format.enable": false,
        "javascript.preferences.quoteStyle": "single",
        "javascript.suggest.completeFunctionCalls": true,
        "javascript.validate.enable": false,
        "json.format.enable": false,
        "js/ts.implicitProjectConfig.checkJs": true,
        "js/ts.implicitProjectConfig.experimentalDecorators": true,
        "js/ts.implicitProjectConfig.strictFunctionTypes": true,
        "js/ts.implicitProjectConfig.strictNullChecks": true,
        "markdown.preview.fontSize": 12,
        "markdown.preview.lineHeight": 1.6,
        "npm.packageManager": "yarn",
        "problems.decorations.enabled": false,
        "rewrap.autoWrap.enabled": true,
        "rewrap.reformat": true,
        "scm.diffDecorations": "none",
        "scm.diffDecorationsGutterWidth": 1,
        "telemetry.enableCrashReporter": false,
        "telemetry.enableTelemetry": false,
        "terminal.integrated.fontFamily": "'Iosevka Nerd Font', 'CaskaydiaCove Nerd Font', 'Hack Nerd Font', monospace",
        "terminal.integrated.fontSize": 12,
        "terminal.integrated.lineHeight": 1.3,
        "terminal.integrated.rightClickBehavior": "copyPaste",
        "typescript.autoClosingTags": true,
        "typescript.format.enable": false,
        "typescript.preferences.quoteStyle": "single",
        "typescript.suggest.completeFunctionCalls": true,
        "typescript.surveys.enabled": false,
        "typescript.validate.enable": false,
        "update.mode": "none",
        "window.doubleClickIconToClose": true,
        "window.menuBarVisibility": "toggle",
        "window.openFilesInNewWindow": "default",
        "window.openFoldersInNewWindow": "default",
        "window.restoreWindows": "one",
        "window.titleBarStyle": "native",
        "window.zoomLevel": 0,
        "workbench.activityBar.visible": true,
        "workbench.colorTheme": "Nord",
        "workbench.editor.enablePreview": true,
        "workbench.editor.enablePreviewFromQuickOpen": true,
        "workbench.iconTheme": "vs-seti",
        "workbench.list.openMode": "singleClick",
        "workbench.settings.editor": "json",
        "workbench.settings.openDefaultKeybindings": false,
        "workbench.settings.openDefaultSettings": false,
        "workbench.sideBar.location": "left",
        "workbench.startupEditor": "welcomePageInEmptyWorkbench",
        "workbench.statusBar.visible": true,
        "workbench.view.alwaysShowHeaderActions": false,
        "zenMode.fullScreen": false
      }
  `);
    for (const [key, value] of Object.entries(cfg)) {
        const key_settings = config.inspect(key);
        if ((key_settings === null || key_settings === void 0 ? void 0 : key_settings.globalValue) === undefined) {
            config.update(key, value, vscode.ConfigurationTarget.Global);
        }
    }
}
exports.activate = activate;
// this method is called when your extension is deactivated
function deactivate() { }
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map