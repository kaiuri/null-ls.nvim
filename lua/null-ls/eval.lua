local M = {}
---Evaluates the command as a statusline expression and returns the result as string[]
---@param cmd string[]
---@return string[]
M.cmd = function(cmd)
  local ok, ret = pcall(vim.api.nvim_eval_statusline, table.concat(cmd, ' '),
    {highlights = false, winid = vim.api.nvim_get_current_win()})
  assert(ok, ret)
  return vim.split(ret.str, ' ', {trimempty = true})
end

return M
