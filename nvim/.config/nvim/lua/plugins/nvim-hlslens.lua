return {
  "kevinhwang91/nvim-hlslens",
  config = function()
    require("hlslens").setup({
      build_position_cb = function(plist, _, _, _)
        require("scrollbar.handlers.search").handler.show(plist.start_pos)
      end,
    })
    require("scrollbar.handlers.search").setup({
      -- hlslens config overrides
    })
  end,
}
