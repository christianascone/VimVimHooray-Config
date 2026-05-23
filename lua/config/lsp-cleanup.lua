-- Stop Phpactor LSP clients on exit to mitigate orphaned diagnostics workers
-- (https://github.com/phpactor/phpactor/issues/2307). Full orphan cleanup still
-- depends on Phpactor upstream.

local function stop_phpactor_clients()
  if not (vim.lsp and vim.lsp.get_clients and vim.lsp.stop_client) then
    return
  end
  for _, client in ipairs(vim.lsp.get_clients({ name = "phpactor" })) do
    pcall(vim.lsp.stop_client, client.id, true)
  end
end

vim.api.nvim_create_autocmd("VimLeave", {
  group = vim.api.nvim_create_augroup("lsp_phpactor_cleanup", { clear = true }),
  callback = stop_phpactor_clients,
})
