local M = {}


local mod = require 'null-ls.mod'

---@class Configuration
---@field services table<string, ServiceConfiguration>
---@param config Configuration
M.setup = function(config)
  mod:setup(config)
end

M.run = function()
  mod:run()
end

-- to the reader:
--↓ insert a `-` to enable
--[===[
M.setup {
  services = {
    stylua = {
      cmd = {"stylua", '{{filepath}}'},
      filetypes = {"lua"},
    },
    shfmt = {
      cmd = {'shfmt', '-w', '-i', '2', '{{filepath}}'},
      filetypes = {"bash"},
    },
  },
}

vim.api.nvim_create_user_command('Nulls', function()
  M.run()
end, {})
--]===]


return M
