-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
  require("plugins.mason"),
  require("plugins.vim-sleuth"),
  require("plugins.comment"),
  require("plugins.gitsigns"),
  require("plugins.which-key"),
  require("plugins.telescope"),
  require("plugins.nvim-lint"),
  require("plugins.conform"),
  require("plugins.mason-tool-installer"),
  require("plugins.copilot"),
  require("plugins.nvim-cmp"),
  require("plugins.mini"),
  require("plugins.nvim-treesitter"),
  require("plugins.vim-tmux-navigator"),
  require("plugins.vscode"),
  require("plugins.nvim-tree"),
  require("plugins.nvim-autopairs"),
  require("plugins.nvim-ts-autotag"),
  require("plugins.vim-fugitive"),
  require("plugins.harpoon"),
  require("plugins.nvim-dap"),
  require("plugins.nvim-dap-ui"),
  require("plugins.indent-blankline"),
  require("plugins.lualine"),
  require("plugins.nvim-hlslens"),
  require("plugins.nvim-scrollbar"),
  require("plugins.barbecue"),
  require("plugins.vim-visual-multi"),
  require("plugins.nvim-notify"),
  require("plugins.opencode"),
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
