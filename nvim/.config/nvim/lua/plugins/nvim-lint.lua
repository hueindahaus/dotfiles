return { -- Linting
  -- https://www.reddit.com/r/neovim/comments/15pj1oi/using_nvimlint_as_a_nullls_alternative_for_linters/
  "mfussenegger/nvim-lint",
  lazy = false,
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = {},
    },
  },
  config = function()
    require("mason").setup()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = {
        "pylint",
      },
      javascript = {
        "eslint_d",
        -- "stylelint", -- css-in-js
      },
      typescript = {
        "eslint_d",
        -- "stylelint", -- css-in-js
      },
      javascriptreact = {
        "eslint_d",
        -- "stylelint", -- css-in-js
      },
      typescriptreact = {
        "eslint_d",
        -- "stylelint", -- css-in-js
      },
      css = {
        "stylelint",
      },
    }

    -- NOTE: Not used here. It is handled in mason-tool-installer
    local ensure_installed = {}
    for _, linters in pairs(lint.linters_by_ft) do
      vim.list_extend(ensure_installed, linters)
    end

    local find_eslint_config = function()
      local depth = 20
      local path = vim.api.nvim_buf_get_name(0)
      local cwd = vim.loop.cwd()
      while path do
        depth = depth - 1

        if depth < 0 then
          break
        end

        local candidate = path .. "/eslint.config.js"

        -- check if file exists
        local stat = vim.loop.fs_stat(candidate)
        if stat and stat.type == "file" then
          -- vim.notify(candidate)
          return candidate
        end

        -- stop if we've reached cwd
        if path == cwd then
          break
        end

        -- move up one directory
        local parent = vim.fn.fnamemodify(path, ":h")
        if parent == path then
          break
        end

        path = parent
      end

      return nill
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
      callback = function()
        lint.linters.eslint_d.args = {
          "--format",
          "json",
          "--stdin",
          "--stdin-filename",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
          function()
            local eslint_config_path = find_eslint_config()
            if eslint_config_path == nill then
              return ""
            end
            return "--config"
          end,
          function()
            local eslint_config_path = find_eslint_config()
            if eslint_config_path == nill then
              return ""
            end
            return eslint_config_path
          end,
        }

        -- lint.linters.stylelint.args = {
        -- 	"--formatter",
        -- 	"json",
        -- 	"--custom-syntax",
        -- 	"postcss-styled-syntax",
        -- 	"--stdin",
        -- 	"--stdin-filename",
        -- 	function()
        -- 		return vim.api.nvim_buf_get_name(0)
        -- 	end,
        -- }

        lint.try_lint()
      end,
    })
  end,
}
