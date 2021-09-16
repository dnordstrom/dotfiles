import * as vscode from 'vscode';

// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {
  // Use the console to output diagnostic information (console.log) and errors (console.error)
  // This line of code will only be executed once when your extension is activated
  const config = vscode.workspace.getConfiguration();
  const cfg = {
    "breadcrumbs.enabled": true
  };

  for (const [key, value] of Object.entries(cfg)) {
    const key_settings = config.inspect(key);
    if (key_settings?.globalValue === undefined) {
      config.update(key, value, vscode.ConfigurationTarget.Global);
    }
  }
}

// this method is called when your extension is deactivated
export function deactivate() { }
