return {
  -- A default "GUI" front-end for nvim-dap
  "theHamsta/nvim-dap-virtual-text",
  config = function()
    require("nvim-dap-virtual-text").setup()
  end,
  dependencies = {
    "mfussenegger/nvim-dap",
  },
}
