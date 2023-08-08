local M = {}
local TEMPLATES = {
  ['{{filename}}'] = function()
    return vim.fn.expand('%:.')
  end
}
local expand = function(word)
  local cb = TEMPLATES[word] or nil
  return cb and cb() or word
end
---Evaluates the command as a statusline expression and returns the result as string[]
---@param cmd string[]
---@return string[]
M.cmd = function(cmd)
  return vim.iter(cmd):map(expand):totable()
end

return M
