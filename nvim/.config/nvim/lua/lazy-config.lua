-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
  {
    "mason-org/mason.nvim",
  },
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end)

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end)

          -- Actions
          map("n", "<leader>Gs", gitsigns.stage_hunk)
          map("n", "<leader>Gr", gitsigns.reset_hunk)
          map("v", "<leader>Gs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("v", "<leader>Gr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
          map("n", "<leader>GS", gitsigns.stage_buffer)
          map("n", "<leader>Gu", gitsigns.undo_stage_hunk)
          map("n", "<leader>GR", gitsigns.reset_buffer)
          map("n", "<leader>Gp", gitsigns.preview_hunk)
          map("n", "<leader>Gb", function()
            gitsigns.blame_line({ full = true })
          end)
          map("n", "<leader>tGb", gitsigns.toggle_current_line_blame)
          map("n", "<leader>Gd", gitsigns.diffthis)
          map("n", "<leader>GD", function()
            gitsigns.diffthis("~")
          end)
          map("n", "<leader>tGd", gitsigns.toggle_deleted)

          -- Text object
          -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter = "    <author>, <author_time:%R> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
      })
      local c = require("vscode.colors").get_colors()
      require("scrollbar.handlers.gitsigns").setup({
        marks = {
          GitAdd = { color = c.vscGitAdded },
          GitChange = { color = c.vscModified },
          GitDelete = { color = c.vscGitDeleted },
        },
      })
    end,
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
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
      })
      -- visual mode
      wk.add({
        { "<leader>G", desc = "[G]it Hunk", mode = "v" },
      })
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          -- mappings = {
          --   i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          -- },
          layout_strategy = "vertical",
          mappings = { i = { ["<esc>"] = require("telescope.actions").close } },
          layout_config = {
            preview_cutoff = 1,
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            path_display = { "truncate" },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })

      local harpoon = require("harpoon")
      harpoon:setup({})

      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      vim.keymap.set("n", "<leader>hh", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })

      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "Tag this to harpoon buffer" })

      vim.keymap.set("n", "<leader>hd", function()
        harpoon:list():remove()
      end, { desc = "Remove this from harpoon buffer" })

      vim.keymap.set("n", "<leader>hC", function()
        harpoon:list():clear()
      end, { desc = "Clear harpoon buffer" })

      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "LSP: " .. desc })
      end

      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-t>.
      map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

      local find_references = function()
        -- Find references for the word under your cursor.
        require("telescope.builtin").lsp_references({
          show_line = true,
          trim_text = true,
          fname_width = 75,
        })
      end
      map("gr", find_references, "[G]oto [R]eferences")
      -- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

      -- Jump to the type of the word under your cursor.
      --  Useful when you're not sure what type a variable is and you want to see
      --  the definition of its *type*, not where it was *defined*.
      map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

      -- Fuzzy find all the symbols in your current workspace.
      --  Similar to document symbols, except searches over your entire project.
      map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    end,
  },
  require("plugins.nvim-lint"),
  require("plugins.conform"),
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = {
      { "stevearc/conform.nvim" },
      { "mfussenegger/nvim-lint" },
    },
    config = function()
      conform = require("conform")
      local ensure_installed = {}
      for _, formatters in pairs(conform.formatters_by_ft) do
        vim.list_extend(ensure_installed, formatters)
      end

      local lint = require("lint")
      for _, linters in pairs(lint.linters_by_ft) do
        vim.list_extend(ensure_installed, linters)
      end

      for language_server, _ in pairs(vim.lsp.config._configs) do
        if not language_server == "*" then
          table.insert(ensure_installed, language_server)
        end
      end

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    end,
  },
  { -- copilot
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter", "LspAttach" },
    fix_pairs = true,
    dependencies = {
      { "hrsh7th/nvim-cmp" },
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
              python = true,
              cpp = true,
              cuda = true,
              bazel = true,
              typescript = true,
              typescriptreact = true,
              javascript = true,
              javascriptreact = true,
              ["*"] = false,
            },
            server_opts_overrides = {},
          })
        end,
      },
    },
    config = function()
      require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
  },
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      "saadparwaiz1/cmp_luasnip",

      "onsails/lspkind.nvim",
      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      -- See `:help cmp`
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        experimental = {
          ghost_text = true, -- this feature conflict with copilot.vim's preview.
        },
        completion = { completeopt = "menu,menuone,noinsert" },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          -- ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- ['<Tab>'] = cmp.mapping.select_next_item(),
          -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ["<C-Space>"] = cmp.mapping.complete({}),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "copilot" },
          { name = "path" },
          { name = "nvim_lsp_signature_help" },
          { name = "buffer" },
        },
        sorting = {
          -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
          comparators = {
            -- The prioritize comparitor causes copilot entries to appear higher in the cmp menu. It is recommended keeping priority weight at 2, or placing the exact comparitor above copilot so that better lsp matches are not stuck below poor copilot matches
            require("copilot_cmp.comparators").prioritize,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,

            -- copied from cmp-under, but I don't think I need the plugin for this.
            -- I might add some more of my own.
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        formatting = {
          -- Youtube: How to set up nice formatting for your sources.
          format = require("lspkind").cmp_format({
            with_text = true,
            menu = {
              buffer = "[buf]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[api]",
              path = "[path]",
              luasnip = "[snip]",
              gh_issues = "[issues]",
              tn = "[TabNine]",
              eruby = "[erb]",
              Copilot = "[]",
            },
          }),
        },
      })
      -- `/` cmdline setup
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      -- `:` cmdline setup
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },

  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()

      require("mini.move").setup({
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Move visual selection 't like it,
          --  and try some other statusin Visual mode. Defaults are Alt (Meta) + hjkl.
          left = "<Nop>",
          right = "<Nop>",
          down = "<A-j>",
          up = "<A-k>",

          -- Move currnilent line in Normal mode
          line_left = "<A-h>",
          line_right = "<A-l>",
          line_down = "<A-j>",
          line_up = "<A-k>",
        },

        -- Options which control moving behavior
        options = {
          -- Automatically reindent selection during linewise vertical move
          reindent_linewise = true,
        },
      })

      -- Simple and easy statusline.
      --  You could remove this setup call if you donline plugin
      -- local statusline = require("mini.statusline")
      -- set use_icons to true if you have a Nerd Font
      -- statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      -- 	return "%2l:%-2v"
      -- end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "vim",
        "vimdoc",
        "typescript",
        "tsx",
        "javascript",
        "css",
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require("nvim-treesitter.install").prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      -- { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  {
    "Mofiqul/vscode.nvim",
    config = function()
      local c = require("vscode.colors").get_colors()
      vim.o.background = "dark"
      require("vscode").setup({

        -- Alternatively set style in setup
        -- style = 'light'

        -- Enable transparent background
        transparent = true,

        -- Enable italic comment
        italic_comments = true,

        -- Underline `@markup.link.*` variants
        underline_links = true,

        -- Disable nvim-tree background color
        disable_nvimtree_bg = true,

        -- Override colors (see ./lua/vscode/colors.lua)
        color_overrides = {
          vscLineNumber = "#FFFFFF",
        },

        -- Override highlight groups (see ./lua/vscode/theme.lua)
        group_overrides = {
          -- this supports the same val table as vim.api.nvim_set_hl
          -- use colors from this colorscheme by requiring vscode.colors!
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
          GitSignsCurrentLineBlame = { fg = c.vscDimHighlight },
        },
      })
    end,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme("vscode")

      -- You can configure highlights by doing something like:
      -- vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      -- disable netrw at the very start of your init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        git = {
          ignore = false,
          enable = true,
          timeout = 500,
        },
        filters = { dotfiles = false },
        sort = {
          sorter = "case_sensitive",
        },
        view = { width = 30 },
        renderer = {
          group_empty = true,
        },
        update_focused_file = { enable = true },
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
        -- per_filetype = {
        -- 	["html"] = {
        -- 		enable_close = false,
        -- 	},
        -- },
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false,
  },
  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
    },
    lazy = false,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    -- Debug adapter plug-in. Debug anything in Neovim
    "mfussenegger/nvim-dap",
    dependencies = { "mfussenegger/nvim-dap-python" },
    config = function()
      require("dap.ext.vscode").load_launchjs()
      require("dap-python").setup("python")

      vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>")
      vim.keymap.set("n", "<leader>d<space>", ":DapContinue<CR>")
      vim.keymap.set("n", "<leader>dl", ":DapStepInto<CR>")
      vim.keymap.set("n", "<leader>dj", ":DapStepOver<CR>")
      vim.keymap.set("n", "<leader>dh", ":DapStepOut<CR>")
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
      -- vim.keymap.set("n", "<F1>", ":DapStepOut<CR>")
      -- vim.keymap.set("n", "<F2>", ":DapStepOver<CR>")
      -- vim.keymap.set("n", "<F3>", ":DapStepInto<CR>")
      vim.keymap.set("n", "<leader>d-", function()
        require("dap").restart()
      end)
      vim.keymap.set("n", "<leader>d_", function()
        require("dap").terminate()
        require("dapui").close()
      end)
    end,
    lazy = true,
  },
  {
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
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    config = function()
      local c = require("vscode.colors").get_colors()
      local hooks = require("ibl.hooks")

      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes

      vim.api.nvim_set_hl(0, "IblScope", { fg = c.vscPopupHighlight })
      vim.api.nvim_set_hl(0, "IblIndent", { fg = c.vscDimHighlight })

      require("ibl").setup({
        indent = {
          highlight = { "IblIndent" },
          char = "│",
        },
        scope = {
          highlight = { "IblScope" },
          char = "│",
          show_start = true,
          show_end = true,
        },
        exclude = {
          filetypes = {
            "help",
            "terminal",
            "starter",
            "packer",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "mason",
            "checkhealth",
            "gitcommit",
            "",
          },
        },
      })
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    -- event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "letieu/harpoon-lualine",
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
  },
  {
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
  },
  {
    "petertriho/nvim-scrollbar",
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim",
    },
    config = function()
      local c = require("vscode.colors").get_colors()

      require("scrollbar").setup({
        handle = { color = c.vscSplitThumb },
        marks = {
          Search = { color = c.vscYellowOrange },
          Error = { color = c.vscRed },
          Warn = { color = c.vscOrange },
          Info = { color = c.vscLightBlue },
          Hint = { color = c.vscGray },
          Misc = { color = c.vscGray },
          GitAdd = { color = c.vscGitAdded },
          GitChange = { color = c.vscModified },
          GitDelete = { color = c.vscGitDeleted },
        },
        show_in_active_only = true,
      })
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
      }
    end,
  },
  {
    "rcarriga/nvim-notify",
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
