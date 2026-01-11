return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescriptreact", "typescript" },
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "relative",
      importModuleSpecifierEnding = "minimal",
    },
  },
}
