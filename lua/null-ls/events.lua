---@class AuCallbackParams
---@field id number        # autocommand id
---@field event string     # name of the triggered event |autocmd-events|
---@field group number|nil # autocommand group id, if any
---@field match string     # expanded value of
---@field buf number       # expanded value of
---@field file string      # expanded value of
---@field data any         # arbitrary data passed from |nvim_exec_autocmds()|
---@alias AutcmdCallback fun(args: AuCallbackParams): nil|boolean
---
---@class AutocmdOpts
---@field group? string|integer    # autocommand group name or id to match against.
---@field pattern? string|string[] # patterns to match literally |autocmd-pattern|.
---@field buffer? integer          # buffer number for buffer-local autocommands |autocmd-buflocal|. Cannot be used with {pattern}.
---@field desc string              # description for documentation and troubleshooting.
---@field callback  AutcmdCallback # function to call when autocommand is triggered.
---@field once? boolean            # defaults to false. Run the autocommand only once |autocmd-once|.
---@field nested? boolean          # defaults to false. Run nested autocommands |autocmd-nested|.


---@class Events
local M = setmetatable({}, {
  __index = function(t, k)
    return ({
      buffer = vim.api.nvim_get_current_buf()
    })[k]
  end
})
M.group = vim.api.nvim_create_namespace('null-ls')

---@param event string|string[]
---@param opts AutocmdOpts
function M:on(event, opts)
  opts.group = self.group
  vim.api.nvim_create_autocmd(event, opts)
  return self
end

return M
