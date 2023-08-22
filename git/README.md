# git

## gitconfig
1. Go to user specific dir
2. Paste following in .gitconfig
```
[user]
    name = Alexander Huang
    email = alexanderhuangen@live.se
    username = hueindahaus
[core]
    autocrlf = false
    safecrlf = true
    editor = code --wait
[merge]
    conflictstyle = diff3
[diff]
    tool = vscode
[difftool "vscode"]
    cmd = code --wait --diff $LOCAL $REMOTE
[merge]
    tool = vscode
[mergetool "vscode"]
    cmd = code --wait $MERGED
[pull]
    rebase = true
```