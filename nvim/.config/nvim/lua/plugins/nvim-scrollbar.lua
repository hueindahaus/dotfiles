return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "kevinhwang91/nvim-hlslens",
    "lewis6991/gitsigns.nvim",
  },
  config = function()
    local c = require("vscode.colors").get_colors()

    require("scrollbar").setup({
      handle = { color = c.vscSplitThumb },
      marks = {
        Search = { color = c.vscYellowOrange },
        Error = { color = c.vscRed },
        Warn = { color = c.vscOrange },
        Info = { color = c.vscLightBlue },
        Hint = { color = c.vscGray },
        Misc = { color = c.vscGray },
        GitAdd = { color = c.vscGitAdded },
        GitChange = { color = c.vscModified },
        GitDelete = { color = c.vscGitDeleted },
      },
      show_in_active_only = true,
    })
  end,
}
