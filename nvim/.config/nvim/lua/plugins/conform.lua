return {
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  init = function()
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        vim.b.disable_autoformat = true
        vim.notify("Autoformatting has been disabled for current buffer", vim.log.levels.INFO)
      else
        vim.g.disable_autoformat = true
        vim.notify("Autoformatting has been disabled globally", vim.log.levels.INFO)
      end
    end, { desc = "Disable autoformat-after-save. Add bang for disabling it for the buffer.", bang = true })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
      vim.notify("Autoformatting has been enabled", vim.log.levels.INFO)
    end, { desc = "Enable autoformat-on-save" })
  end,
  config = function()
    local formatters_by_ft = {
      lua = { "stylua" },
      -- Conform can also run multiple formatters sequentially
      python = { "isort", "black" },
      javascript = {
        "eslint_d",
      },
      typescript = {
        "eslint_d",
      },
      javascriptreact = {
        "eslint_d",
      },
      typescriptreact = {
        "eslint_d",
      },
      json = {
        "jq",
      },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { "prettierd", "prettier" } },
    }

    -- NOTE: Not used here. It is handled in mason-tool-installer
    local ensure_installed = {}
    for _, formatters in pairs(formatters_by_ft) do
      vim.list_extend(ensure_installed, formatters)
    end

    local format_after_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end

      return {
        lsp_fallback = true,
      }
    end
    require("conform").setup({
      notify_on_error = true,
      format_after_save = format_after_save,
      formatters_by_ft = formatters_by_ft,
    })
  end,
}
