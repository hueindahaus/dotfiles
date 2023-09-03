

# vscode


## Keybindings
1. Vscode keybindings only work on user level, so we have to **ctrl + shift + p** and then select **Preferences: Open Keyboard Shortcuts (JSON)** 
2. paste 
```
[
    { "key": "ctrl+j", "command": "workbench.action.terminal.focus"},
    { "key": "ctrl+j", "command": "workbench.action.focusActiveEditorGroup", "when": "terminalFocus"}
]
```
