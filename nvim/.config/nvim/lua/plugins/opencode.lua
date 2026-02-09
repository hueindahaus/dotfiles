-- opencode.nvim plugin configuration for lazy.nvim
-- Provides AI coding assistance via opencode CLI integration.
-- Includes path-based blacklisting to disable the plugin in specific directories.

-- Paths where opencode.nvim should be disabled
local blacklisted_paths = {
  -- Add paths here, e.g.:
  -- vim.fn.expand("~/work/restricted-project"),
  -- "/home/user/sensitive-repo",
  -- Zenseact repos that should be restricted
  "/home/s0001701/workspaces",
}

local function is_blacklisted()
  local cwd = vim.fn.getcwd()
  for _, path in ipairs(blacklisted_paths) do
    -- Check if cwd is or is a subpath of the blacklisted path
    if cwd == path or cwd:sub(1, #path + 1) == path .. "/" then
      vim.notify("opencode.nvim disabled: cwd is in blacklisted path (" .. path .. ")", vim.log.levels.WARN)
      return true
    end
  end
  return false
end

return {
  "nickjvandyke/opencode.nvim",
  cond = function()
    return not is_blacklisted()
  end,
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", lazy = false, priority = 1000, opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
      provider = {
        enabled = "tmux",
        tmux = {
          -- ...
        },
      },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<C-.>", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })

    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "Scroll opencode down" })

    -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
}
