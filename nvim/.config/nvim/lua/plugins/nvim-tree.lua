return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    require("nvim-tree").setup({
      git = {
        ignore = false,
        enable = true,
        timeout = 500,
      },
      filters = { dotfiles = false },
      sort = {
        sorter = "case_sensitive",
      },
      view = { width = 30 },
      renderer = {
        group_empty = true,
      },
      update_focused_file = { enable = true },
    })
  end,
}
