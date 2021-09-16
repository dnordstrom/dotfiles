"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
const vscode = require("vscode");
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
function activate(context) {
    console.log('NORD mode activated.');
    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    const config = vscode.workspace.getConfiguration();
    const cfg = {
        "breadcrumbs.enabled": true
    };
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