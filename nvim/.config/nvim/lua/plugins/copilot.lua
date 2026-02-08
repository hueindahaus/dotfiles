return { -- copilot
  "zbirenbaum/copilot-cmp",
  event = { "InsertEnter", "LspAttach" },
  fix_pairs = true,
  dependencies = {
    { "hrsh7th/nvim-cmp" },
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
          filetypes = {
            python = true,
            cpp = true,
            cuda = true,
            bazel = true,
            typescript = true,
            typescriptreact = true,
            javascript = true,
            javascriptreact = true,
            ["*"] = false,
          },
          server_opts_overrides = {},
        })
      end,
    },
  },
  config = function()
    require("copilot_cmp").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })

    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
  end,
}
