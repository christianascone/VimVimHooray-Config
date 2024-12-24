-- Set custom path for Neovim data (including where lazy.nvim will store plugins)
local custom_path = os.getenv("XDG_DATA_HOME")
vim.env.XDG_DATA_HOME = custom_path

-- Basic Neovim Options
vim.g.mapleader = " " -- Leader as SPACE

vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.showmode = false -- Dont show mode since we have a statusline
vim.opt.expandtab = true -- On pressing tab, insert 4 spaces
vim.opt.smarttab = true -- Makes tabbing smarter
vim.opt.autoindent = true -- Good auto indent
vim.opt.smartindent = true -- Makes indenting smart
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = "indent,eol,start" -- Allow backspace over everything in insert mode
vim.opt.hidden = true -- Required to keep multiple buffers open
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Makes search act like search in modern browsers
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- When searching try to be smart about cases
vim.opt.splitbelow = true -- Horizontal splits will automatically be below
vim.opt.splitright = true -- Vertical splits will automatically be to the right
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.laststatus = 2
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.pumblend = 10 -- Popup blend
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.spelllang = { "en" }
vim.opt.splitkeep = "screen"
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.exrc = true
vim.opt.secure = true

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Your plugins will go here. Example:
  -- {'preservim/nerdtree', config = function() vim.cmd('nnoremap <C-n> :NERDTreeToggle<CR>') end},
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
    opts = {
      integrations = {
        alpha = true,
        cmp = true,
        flash = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        noice = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    lazy = true,
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-j>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-.>",
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local wk = require("which-key")
      wk.add({
        { "<leader>sn", group = "+noice" },
        { "<leader>s", group = "+search" },
        { "<leader>g", group = "+git" },
        { "<leader>q", group = "+quit/session" },
        { "<leader>t", group = "+terminal" },
      })
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      window = {
        position = "right",
        mappings = {
          ["<space>"] = "none",
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
  -- ui components
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- You can customize noice here
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    keys = {
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
    },

    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local icons = require("lazyvim.config").icons
      local Util = require("lazyvim.util")

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            -- stylua: ignore
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = Util.fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = Util.fg("Constant"),
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.fg("Debug"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    config = function()
      require("telescope").setup({
        defaults = {
          -- Default configuration for telescope goes here:
          -- set layout, previewer, etc.
          layout_strategy = "vertical",
          layout_config = { width = 0.8 },
          file_ignore_patterns = { "node_modules" },
          path_display = {
            filename_first = {
              reverse_directories = false,
            },
          },
          prompt_prefix = " ",
          selection_caret = " ",
        },
        pickers = {
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
        },
        require("telescope").load_extension("fzf"),
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        -- size can be a number or function which is passed the current terminal
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]], -- Open with <C-\>
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        persist_size = true,
        direction = "float", -- Default direction for new terminals
        close_on_exit = true, -- close the terminal window when the process exits
        shell = vim.o.shell, -- change the default shell
        on_open = function(term)
          -- Map Esc-Esc to exit terminal mode when the terminal is opened
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc><Esc>", [[<C-\><C-n>]], { silent = true, noremap = true })
          -- Window navigation mappings
          local opts = { silent = true, noremap = true }
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
          vim.api.nvim_create_autocmd("BufEnter", {
            buffer = term.bufnr,
            callback = function()
              vim.defer_fn(function()
                vim.cmd.startinsert() -- Starts insert mode
              end, 100) -- Delay for 100ms
            end,
          })
        end,
        -- This field is only relevant if direction is set to 'float'
        float_opts = {
          border = "curved",
          winblend = 3,
          highlights = {},
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- For additional functionality like textobjects for selection
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- A list of parsers you want to ensure are installed (sync with :TSInstall)
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "python", "java", "php" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        ignore_install = {},

        highlight = {
          -- `false` will disable the whole extension
          enable = true,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>", -- Enter key for initial selection
            node_incremental = "<Tab>", -- Tab key to expand selection
            scope_incremental = "<S-Tab>", -- Shift-Tab to go to the next scope level (optional)
            node_decremental = "<BS>", -- Backspace to reduce selection
          },
        },

        -- Configuration for textobjects, which can be used for block selection
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              -- You can also use treesitter to create your own textobjects
              -- ["iF"] = "@function.inner",
            },
          },
          -- Move configuration
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
  },
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>up",
        function()
          local Util = require("lazy.core.util")
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            Util.warn("Disabled auto pairs", { title = "Option" })
          else
            Util.info("Enabled auto pairs", { title = "Option" })
          end
        end,
        desc = "Toggle auto pairs",
      },
    },
  },
  -- Fast and feature-rich surround actions. For text that includes
  -- surrounding characters like brackets or quotes, this allows you
  -- to select the text inside, change or modify the surrounding characters,
  -- and more.
  {
    "echasnovski/mini.surround",
    keys = function(_, keys)
      -- Populate the keys based on the user's options
      local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
  },
  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      -- Add other dependencies as needed
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(_, item)
            local icons = require("lazyvim.config").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "google-java-format",
        "stylua",
        "pint",
        "php_cs_fixer",
        "java-debug-adapter",
        "java-test",
      },
    },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "jdtls", "phpactor" }, -- Add your servers here
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Java
        java = { "google-java-format" },
        -- Lua
        lua = { "stylua" },
        -- JavaScript
        javascript = { "prettier" },
        -- TypeScript
        typescript = { "prettier" },
        -- PHP
        php = { "php_cs_fixer" }, -- or any other PHP formatter you prefer
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
    dependencies = {

      {
        "nvim-neotest/nvim-nio",
      },
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          {
            "<leader>du",
            function()
              require("dapui").toggle({})
            end,
            desc = "Dap UI",
          },
          {
            "<leader>dE",
            function()
              require("dapui").eval()
            end,
            desc = "Eval",
            mode = { "n", "v" },
          },
        },

        opts = {},
        config = function(_, opts)
          -- setup dap config by VsCode launch.json file
          -- require("dap.ext.vscode").load_launchjs()
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close({})
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close({})
          end
        end,
      },
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },

      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
          ensure_installed = { "java", "php", "javadbg", "javatest" },
          handlers = {
            php = function(config)
              -- Uncomment this to specify the executable path
              -- local base_path = vim.fn.stdpath("config") -- or vim.fn.getcwd() if you prefer current working directory
              -- config.adapters = {
              --   type = "executable",
              --   command = string.format("%s/LSPs/vscode-php-debug/out/phpDebug.js", base_path),
              -- }
              config.configurations = {
                {
                  type = "php",
                  request = "launch",
                  name = "(default) Listen for Xdebug",
                  port = 9003,
                },
                {
                  name = "(default) Launch Built-in server",
                  type = "php",
                  request = "launch",
                  program = "",
                  runtimeArgs = {
                    "-S",
                    "localhost:8000",
                    "-dxdebug.mode=debug",
                    "-dxdebug.start_with_request=yes",
                  },
                  env = {
                    XDEBUG_MODE = "debug",
                    XDEBUG_SESSION = "xdebug_is_great",
                  },
                  port = 9003,
                },
                {
                  name = "(default) Launch Built-in server in public (laravel/symfony)",
                  type = "php",
                  request = "launch",
                  program = "",
                  runtimeArgs = {
                    "-S",
                    "localhost:8000",
                    "-t",
                    "public",
                  },
                  port = 9003,
                },
                {
                  name = "(default) Launch Built-in server in public (laravel/symfony) with debugger",
                  type = "php",
                  request = "launch",
                  program = "",
                  runtimeArgs = {
                    "-S",
                    "localhost:8000",
                    "-t",
                    "public",
                    "-dxdebug.mode=debug",
                    "-dxdebug.start_with_request=yes",
                  },
                  env = {
                    XDEBUG_MODE = "debug",
                    XDEBUG_SESSION = "xdebug_is_great",
                  },
                  port = 9003,
                },
                {
                  name = "(default) Launch Built-in spark server",
                  type = "php",
                  request = "launch",
                  program = "",
                  runtimeArgs = {
                    "spark",
                    "serve",
                    "-dxdebug.mode=debug",
                    "-dxdebug.start_with_request=yes",
                  },
                  env = {
                    XDEBUG_MODE = "debug",
                    XDEBUG_SESSION = "xdebug_is_great",
                  },
                  port = 9003,
                },
                {
                  name = "(default) Launch phpunit",
                  type = "php",
                  request = "launch",
                  program = "",
                  runtimeArgs = {
                    "bin/phpunit",
                    "-dxdebug.mode=debug",
                    "-dxdebug.start_with_request=yes",
                  },
                  env = {
                    XDEBUG_MODE = "debug",
                    XDEBUG_SESSION = "xdebug_is_great",
                  },
                  port = 9003,
                },
              }
              require("mason-nvim-dap").default_setup(config) -- don't forget this!
            end,
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        jdtls = function()
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
              -- Use Mason to get the installation paths
              local jdtls_install = require("mason-registry").get_package("jdtls"):get_install_path()
              local java_debug_install = require("mason-registry").get_package("java-debug-adapter"):get_install_path()
              local java_test_install = require("mason-registry").get_package("java-test"):get_install_path()
              local lombok_path = jdtls_install .. "/lombok.jar"

              local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
              local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name

              -- Determine the platform configuration path
              local platform_config_path
              if vim.fn.has("mac") == 1 then
                platform_config_path = jdtls_install .. "/config_mac"
              elseif vim.fn.has("unix") == 1 then
                platform_config_path = jdtls_install .. "/config_linux"
              else
                platform_config_path = jdtls_install .. "/config_win"
              end

              -- Bundles for Java debugging
              local bundles = {
                vim.fn.glob(java_debug_install .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"),
              }
              vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_install .. "/extension/server/*.jar"), "\n"))

              local config = {
                cmd = {
                  "/usr/bin/java",
                  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                  "-Dosgi.bundles.defaultStartLevel=4",
                  "-Declipse.product=org.eclipse.jdt.ls.core.product",
                  "-Dlog.protocol=true",
                  "-Dlog.level=ALL",
                  "-javaagent:" .. lombok_path,
                  "-Xms1g",
                  "--add-modules=ALL-SYSTEM",
                  "--add-opens",
                  "java.base/java.util=ALL-UNNAMED",
                  "--add-opens",
                  "java.base/java.lang=ALL-UNNAMED",
                  "-jar",
                  vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
                  "-configuration",
                  platform_config_path,
                  "-data",
                  workspace_dir,
                },
                root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
                settings = {
                  java = {},
                },
                handlers = {
                  ["language/status"] = function(_, result)
                    -- print(result)
                  end,
                  ["$/progress"] = function(_, result, ctx)
                    -- disable progress updates.
                  end,
                },
                init_options = {
                  bundles = bundles,
                },
                test = true,
              }

              config["on_init"] = function(client, bufnr)
                -- CustomUtil.callDotenv()
              end
              config["on_attach"] = function(client, bufnr)
                require("jdtls").setup_dap({ hotcodereplace = "auto", config_overrides = {} })
                require("jdtls.dap").setup_dap_main_class_configs()
              end

              config["capabilities"] = require("cmp_nvim_lsp").default_capabilities()

              require("jdtls").start_or_attach(config)
            end,
          })
          return true
        end,
      })
    end,
  },
  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      -- https://emojicombos.com/ghibli-ascii-art
      local logo = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣤⣴⣶⣶⣶⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠛⠛⠛⠛⠛⠛⠻⠿⠿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⣿⡿⠟⢛⣉⣥⣤⣶⣶⣶⣶⣿⣿⣿⣿⣿⣶⣶⣶⣤⣤⣀⡉⠛⠿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⣿⣿⣿⣿⣿⣻⣭⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⡙⠻⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠰⠿⠿⠿⠿⠿⠿⠛⠛⠛⠛⠛⠛⠛⠻⠿⠿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣌⣻⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠙⠛⠛⠻⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣷⡄⠀⠀⠀⠀⠀⣴⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⢀⡀⠀⠀⠈⢻⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡄⠀⠀⠀⠸⣿⡿⡹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⡀⠀⠀⠀⢻⣆⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⡄⠀⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⡇⠀⠀⠀⠈⣿⡄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡇⠀⠀⠀⠀⢻⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠇⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣷⣀⣀⣠⣤⣤⣤⣄⣸⣿⣿⣿⣿⠁⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠻⣿⣿⣥⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⣼⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⡟⠉⣉⠉⠻⣿⣿⣿⣿⣿⣿⣿⠛⠉⣉⠙⢷⡄⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⠀⠈⠛⠀⠀⣿⣿⣿⣿⣿⣿⡇⠀⠈⠛⠀⢸⣿⣦⡀⢀⣿⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣧⣄⣀⣀⣴⣿⣿⣿⣿⣿⣿⣿⣦⣀⣀⣤⣾⣿⣿⡟⠛⢻⣤⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⣾⣿⣧⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠛⠉⠉⠉⠉⠉⠛⠛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⢀⡾⠟⠻⠿⡄⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡏⠀⠀⢀⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠞⠛⠳⠀⠀⠀⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⠟⠋⢸⣿⠀⠀⠠⠟⠋⠛⠷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣼⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠷⣦⣤⣀⣀⡀⠀⠀⠀⣀⣀⣀⣤⣴⠾⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠛⠛⠛⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
})

-- Custom function for opening lazygit in a floating window
local function lazygitToggle()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir", -- or whatever directory you want to open lazygit in, if not current dir
    direction = "float",
    float_opts = {
      width = math.floor(vim.o.columns * 0.9),
      height = math.floor(vim.o.lines * 0.9),
    },
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
    -- close the terminal window when the process exits
    close_on_exit = true,
  })

  lazygit:toggle()
end

-- Shortend for keymap
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Supermaven
map("n", "<leader>cS", function()
  require("supermaven-nvim")
end, { desc = "Enable Supermaven" })
-- Key mapping to toggle neo-tree
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Nvim tree" })
map("n", "<leader>+", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
-- Scroll
map("n", "<S-Up>", ":m-2<cr>", { desc = "Move line up" })
map("n", "<S-Up>", "<Esc>:m-2<cr>", { desc = "Move line up" })
map("n", "<S-Down>", ":m+<cr>", { desc = "Move line down" })
map("n", "<S-Down>", "<Esc>:m+<cr>", { desc = "Move line down" })
map("n", "<C-S-K>", "{zz", { desc = "Go previous white line" })
map("n", "<C-S-J>", "}zz", { desc = "Go next white line" })
map("n", "{", "{zz", { desc = "Go previous white line" })
map("n", "}", "}zz", { desc = "Go next white line" })
map("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })
-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
-- buffers
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Custom key mappings for horizontal and vertical terminals
map("n", "<leader>th", function()
  vim.cmd("ToggleTerm direction=horizontal")
end, { desc = "Toggle terminal (horizontal)" })

map("n", "<leader>tv", function()
  vim.cmd("ToggleTerm direction=vertical")
end, { desc = "Toggle terminal (vertical)" })

-- Lazygit
map("n", "<leader>gg", function()
  lazygitToggle()
end, { noremap = true, silent = true, desc = "Toggle Lazygit" })

-- Telescope
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
map("n", "<leader><space>", builtin.git_files, { desc = "Git Files" })
map("n", "<leader>/", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>,", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "Goto Symbol" })

-- Lsp
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "gd", function()
  require("telescope.builtin").lsp_definitions({ reuse_win = true })
end, { desc = "Goto Definition" })
map("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gI", function()
  require("telescope.builtin").lsp_implementations({ reuse_win = true })
end, { desc = "Goto Implementation" })
map("n", "gy", function()
  require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
end, { desc = "Goto T[y]pe Definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<leader>cf", function()
  require("conform").format()
end, { desc = "Format file" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>cA", function()
  vim.lsp.buf.code_action({
    context = {
      only = {
        "source",
      },
      diagnostics = {},
    },
  })
end, { desc = "Source Action" })

-- Dap
local dapContinue = function()
  if vim.fn.filereadable(".vscode/launch.json") then
    require("dap.ext.vscode").load_launchjs()
  end
  -- CustomUtil.callDotenv()
  require("dap").continue()
end
map("n", "<F5>", dapContinue, { desc = "Debug" })
map("n", "<F10>", function()
  require("dap").step_over()
end)
map("n", "<F11>", function()
  require("dap").step_into()
end)
map("n", "<F12>", function()
  require("dap").step_out()
end)
map("n", "<Leader>B", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug: toggle breakpoint" })
-- Disabled for conflicts
-- map('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
map("n", "<Leader>dr", function()
  require("dap").repl.open()
end)
map("n", "<Leader>dl", function()
  require("dap").run_last()
end)
map({ "n", "v" }, "<Leader>dp", function()
  require("dap.ui.widgets").preview()
end, { desc = "Debug preview" })

-- Highlight code when yanking
vim.cmd([[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=150})
  augroup END
]])
