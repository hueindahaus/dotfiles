return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  config = function()
    local c = require("vscode.colors").get_colors()
    local hooks = require("ibl.hooks")

    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes

    vim.api.nvim_set_hl(0, "IblScope", { fg = c.vscPopupHighlight })
    vim.api.nvim_set_hl(0, "IblIndent", { fg = c.vscDimHighlight })

    require("ibl").setup({
      indent = {
        highlight = { "IblIndent" },
        char = "│",
      },
      scope = {
        highlight = { "IblScope" },
        char = "│",
        show_start = true,
        show_end = true,
      },
      exclude = {
        filetypes = {
          "help",
          "terminal",
          "starter",
          "packer",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
          "mason",
          "checkhealth",
          "gitcommit",
          "",
        },
      },
    })
    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
