return {
  "saghen/blink.cmp",
  dependencies = "rafamadriz/friendly-snippets",
  version = "v1.*", -- v2 is unstable for now
  opts = {
    keymap = { preset = "enter" },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    completion = { ghost_text = { enabled = true }, documentation = { auto_show = true, auto_show_delay_ms = 500 }, list = { selection = { preselect = true, auto_insert = false } } },
    signature = {
      enabled = true,
      trigger = {
        -- Show the signature help automatically
        enabled = true,
        -- Show the signature help window after typing any of alphanumerics, `-` or `_`
        show_on_keyword = false,
        blocked_trigger_characters = {},
        blocked_retrigger_characters = {},
        -- Show the signature help window after typing a trigger character
        show_on_trigger_character = true,
        -- Show the signature help window when entering insert mode
        show_on_insert = true,
        -- Show the signature help window when the cursor comes after a trigger character when entering insert mode
        show_on_insert_on_trigger_character = true,
      },
      window = { show_documentation = true }
    },
    cmdline = {
      completion = {
        menu = { auto_show = true },
      },
      -- keymap = { preset = "default" },
      keymap = {
        ['<Tab>'] = { 'accept' },
        -- ['<CR>'] = { 'accept_and_enter', 'fallback' },
      },
    },
  }

}
