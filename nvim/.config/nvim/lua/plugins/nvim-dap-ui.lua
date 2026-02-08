return {
  -- A default "GUI" front-end for nvim-dap
  "rcarriga/nvim-dap-ui",
  config = function()
    require("dapui").setup()

    -- Note: Added this <leader>dd duplicate of <F5> because somehow the <F5>
    -- mapping keeps getting reset each time I restart nvim-dap. Annoying but whatever.
    --
    vim.keymap.set("n", "<leader>dd", function()
      require("dapui").toggle()
    end, { desc = "Toggle DapUI" })
  end,
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
}
