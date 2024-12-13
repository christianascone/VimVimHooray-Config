-- Set custom path for Neovim data (including where lazy.nvim will store plugins)
local custom_path = os.getenv("XDG_DATA_HOME")
vim.env.XDG_DATA_HOME = custom_path

-- Basic Neovim Options
vim.g.mapleader = " " -- Leader as SPACE
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4 -- A tab is four spaces
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4 -- When indenting with '>', use 4 spaces width
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
    config = function()
      vim.cmd.colorscheme("catppuccin")
    end,
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
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "right",
        },
      })
    end,
  },
})

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
-- Key mapping to toggle nvim-tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle Nvim tree" })

-- Highlight code when yanking
vim.cmd([[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=150})
  augroup END
]])
