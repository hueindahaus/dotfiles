return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  opts = {
    install_dir = vim.fn.stdpath("data") .. "/site",
  },
  config = function(_, opts)
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

    require("nvim-treesitter").setup(opts)

    require("nvim-treesitter")
      -- In general try to only put file types which are not covered by LSP
      .install({
        "bash",
        "c", -- Probably not needed but maybe useful for zenseact src repo
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "vim",
        "vimdoc",
      })
      :wait(300000) -- wait max 5 minutes
  end,
}
