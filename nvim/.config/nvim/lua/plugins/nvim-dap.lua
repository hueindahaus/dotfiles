return {
  -- Debug adapter plug-in. Debug anything in Neovim
  "mfussenegger/nvim-dap",
  dependencies = { "mfussenegger/nvim-dap-python" },
  config = function()
    require("dap-python").setup("python")
    local dap = require("dap")
    local ui = require("dapui")

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to cursor" })
    vim.keymap.set("n", "<F1>", dap.continue, { desc = "Dap continue" })
    vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Dap step into" })
    vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Dap step over" })
    vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Dap setp out" })
    vim.keymap.set("n", "<F5>", dap.step_back, { desc = "Dap step back" })
    vim.keymap.set("n", "<F6>", dap.restart, { desc = "Dap restart" })

    vim.keymap.set("n", "<leader>d1", ":DapContinue<CR>")
    vim.keymap.set("n", "<leader>d2", ":DapStepInto<CR>")
    vim.keymap.set("n", "<leader>d3", ":DapStepOver<CR>")
    vim.keymap.set("n", "<leader>d4", ":DapStepOut<CR>")
    vim.keymap.set("n", "<leader>d6", function()
      dap.restart()
    end, { desc = "Restart Dap" })
    -- vim.keymap.set('n', '<leader>dz', ':ZoomWinTabToggle<CR>')
    vim.keymap.set(
      "n",
      "<leader>dgt", -- dg as in debu[g] [t]race
      ":lua require('dap').set_log_level('TRACE')<CR>"
    )
    vim.keymap.set(
      "n",
      "<leader>dge", -- dg as in debu[g] [e]dit
      function()
        vim.cmd(":edit " .. vim.fn.stdpath("cache") .. "/dap.log")
      end
    )

    vim.keymap.set("n", "<leader>dC", function()
      dap.terminate()
      ui.close()
    end, { desc = "Terminate Dap and close DapUI" })

    -- Some convenient hooks that opens/closes dapui based on dap events
    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end

    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end

    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end

    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end
  end,
  lazy = true,
}
