return { -- Useful plugin to show you pending keybinds.
  "folke/which-key.nvim",
  event = "VimEnter", -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    local wk = require("which-key")

    -- Document existing key chains
    wk.add({
      { "<leader>c", group = "[C]ode" },
      --{ "<leader>c_", desc = "", hidden = true },
      { "<leader>d", group = "[D]ocument" },
      --{ "<leader>d_", desc = "", hidden = true },
      { "<leader>h", group = "[H]arpoon" },
      --{ "<leader>h_", desc = "", hidden = true },
      { "<leader>r", group = "[R]ename" },
      --{ "<leader>r_", desc = "", hidden = true },
      { "<leader>s", group = "[S]earch" },
      --{ "<leader>s_", desc = "", hidden = true },
      { "<leader>t", group = "[T]oggle" },
      --{ "<leader>t_", desc = "", hidden = true },
      { "<leader>w", group = "[W]orkspace" },
      --{ "<leader>w_", desc = "", hidden = true },
      { "<leader>o", group = "[O]pencode" },
    })

    -- visual mode
    wk.add({
      { "<leader>G", desc = "[G]it Hunk", mode = "v" },
    })
  end,
}
