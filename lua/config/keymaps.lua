local Util = require("util")
-- Shortend for keymap
local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  if opts.remap and not vim.g.vscode then
    opts.remap = nil
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end
-- Supermaven
map("n", "<leader>cS", Util.load_plugin("supermaven-nvim", "Supermaven"), { desc = "Toggle Supermaven" })
map("n", "<leader>CS", function()
  require("lazy").load({ plugins = { "codesnap.nvim" } })
  vim.notify("CodeSnap loaded", vim.log.levels.INFO)
end, { desc = "Enable CodeSnap" })
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
map("n", "<leader>bO", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
-- Custom key mappings for horizontal and vertical terminals
map("n", "<leader>th", function()
  local count = vim.v.count
  vim.cmd(count .. "ToggleTerm direction=horizontal")
end, { desc = "Toggle terminal (horizontal)" })
map("n", "<leader>tv", function()
  vim.cmd("ToggleTerm direction=vertical")
end, { desc = "Toggle terminal (vertical)" })
-- Lazygit
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

map("n", "<leader>gg", function()
  lazygitToggle()
end, { noremap = true, silent = true, desc = "Toggle Lazygit" })
-- Telescope
local builtin = require("telescope.builtin")
map("n", "<leader>ff", function()
  builtin.find_files({
    no_ignore = true, -- Include files ignored by .gitignore
    hidden = true, -- Include hidden files
  })
end, { desc = "Find Files" })
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
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
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
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename" })

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
-- Overseer
map("n", "<leader>Tt", "<cmd>OverseerToggle<cr>", { desc = "Overseer Toggle" })
map("n", "<leader>Tr", "<cmd>OverseerRun<cr>", { desc = "Overseer Run" })
--- DBUI
map("n", "<leader>db", "<cmd>DBUIToggle<cr>", { desc = "DBUI Toggle" })
--- Rest
map("n", "<leader>Rr", "<cmd>Rest run<cr>", { desc = "Rest: run" })
-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

--- Custom functions ---
local function searchAndReplace(mode)
  -- Prompt user for search string
  local search = vim.fn.input("Enter search string: ")
  -- Prompt user for replace string
  local replace = vim.fn.input("Enter replacement string: ")
  -- Escape search and replace strings to handle special characters
  search = vim.fn.escape(search, "/\\")
  replace = vim.fn.escape(replace, "/\\")
  local modifier = mode == "v" and "'<, '>" or "%"
  -- Perform search and replace operation in current buffer
  vim.cmd(modifier .. "s/" .. search .. "/" .. replace .. "/g")
end
map("n", "<leader>sr", searchAndReplace, { desc = "Search and replace" })
