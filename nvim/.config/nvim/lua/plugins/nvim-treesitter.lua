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
          "c",
          "cpp",
          "cuda",
          "diff",
          "html",
          "lua",
          "luadoc",
          "markdown",
          "vim",
          "vimdoc",
          "python",
          "javascript",
          "jsx",
          "typescript",
          "tsx",
          "css",
          "json",
          "sql",
          "rust",
          "zig",
          "dockerfile"
        })
        :wait(300000) -- wait max 5 minutes
  end,
}
