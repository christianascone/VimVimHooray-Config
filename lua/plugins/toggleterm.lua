return {
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
}
