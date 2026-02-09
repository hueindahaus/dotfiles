return {
  "nvim-lualine/lualine.nvim",
  -- event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "letieu/harpoon-lualine",
    "nickjvandyke/opencode.nvim",
  },
  config = function()
    -- LSP clients attached to buffer
    local clients_lsp = function()
      local bufnr = vim.api.nvim_get_current_buf()
      ---@diagnostic disable-next-line: deprecated
      local clients = vim.lsp.get_clients(bufnr)
      if next(clients) == nil then
        return ""
      end

      local c = {}
      for _, client in pairs(clients) do
        table.insert(c, client.name)
      end
      return "\u{f085} " .. table.concat(c, "|")
    end

    local branch = { "branch", icon = "" }
    local mode = { "mode", icon = "󰡛" }
    local diagnostics = { "diagnostics", symbols = { error = " ", warn = " ", info = " " }, colored = false }
    local harpoon = {
      "harpoon2",
      icon = "♥",
      indicators = { "1", "2", "3", "4" },
      active_indicators = { "[1]", "[2]", "[3]", "[4]" },
    }
    local opencode_statusline = nil
    local ok, opencode = pcall(require, "opencode")
    if ok and opencode then
      opencode_statusline = opencode.statusline
    end

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "vscode",
        disabled_filetypes = {},
        section_separators = {},
        component_separators = {},
        always_divide_middle = true,
        globalstatus = false,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = {
          branch,
          -- { "filename", path = 1 }
        },
        lualine_c = { harpoon },
        lualine_v = { opencode_statusline },
        -- {
        --   require("opencode").statusline,
        -- },
        lualine_x = { diagnostics, "diff", "filetype" },
        lualine_y = { "progress", "location" },
        lualine_z = { clients_lsp },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          -- { "filename", path = 1 }
        },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    })
  end,
}
