return {
  cmd = { "stylelint-lsp", "--stdio" },
  filetypes = { "css", "scss", "typescriptreact", "javascriptreact" },
  settings = { stylelintplus = { autoFixOnFormat = true, autoFixOnSave = true } },
}
