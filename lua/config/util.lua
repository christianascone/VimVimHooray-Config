local M = {}
function M.callDotenv()
  if vim.fn.filereadable(".env") == 1 then
    local ok, err = pcall(vim.cmd, "Dotenv .env")
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end

    vim.cmd("Dotenv")
  end
end
return M
