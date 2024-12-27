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
  -- Example plugin with key mappings in config
  spec = {
    { import = "plugins" },
  },
})
require("config.keymaps")
require("config.autocmds")
-- Highlight code when yanking
vim.cmd([[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=150})
  augroup END
]])
