return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-e>",
    }

    -- Super ugly function to avoid the strange problems when this plugin messes up blink autocomplete
    -- The plan is to move to native multi cursors in vim 0.13
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_exit",
      callback = function()
        local cmp = require("blink.cmp")
        vim.keymap.set("i", "<CR>", function()
          if cmp.is_visible() then
            cmp.accept()
            return ""
          else
            return vim.api.nvim_replace_termcodes("<CR>", true, false, true)
          end
        end, { expr = true, silent = true })
      end,
    })
  end,
}
