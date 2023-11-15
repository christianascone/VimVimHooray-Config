local M = {}
function M.callDotenv(show_updated)
  -- default value
  show_updated = show_updated or true
  if vim.fn.filereadable(".env") == 1 then
    local ok, err = pcall(vim.cmd, "Dotenv .env")
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
    if show_updated then
      vim.cmd("Dotenv")
    end
  end
end
return M
