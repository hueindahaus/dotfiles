return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  lazy = false,
  -- dependencies = {
  --   "stevearc/conform.nvim",
  --   "mfussenegger/nvim-lint",
  -- },
  config = function()
    local ensure_installed = { "tree-sitter-cli", }
    -- conform = require("conform")
    -- for _, formatters in pairs(conform.formatters_by_ft) do
    --   vim.list_extend(ensure_installed, formatters)
    -- end

    -- local lint = require("lint")
    -- for _, linters in pairs(lint.linters_by_ft) do
    --   vim.list_extend(ensure_installed, linters)
    -- end

    for language_server, _ in pairs(vim.lsp.config._configs) do
      if not language_server == "*" then
        table.insert(ensure_installed, language_server)
      end
    end

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  end,
}
