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
      cmd = {"stylua", '%F'},
      filetypes = {"lua"},
    },
    shfmt = {
      cmd = {'shfmt', '-w', '-i', '2', '%F'},
      filetypes = {"bash"},
    },
  },
}

vim.api.nvim_create_user_command('Nulls', function()
  M.run()
end, {})
--]===]


return M
