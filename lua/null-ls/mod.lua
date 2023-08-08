local M = {
  ---@type table<string, Service>
  services = {}
}
local service_provider = require 'null-ls.service'

function M:run()
  local filetype = vim.bo.filetype
  for name, service in pairs(self.services) do
    if service.filetypes[filetype] then
      local ok, err = pcall(function() service:run() end)
      if not ok then
        vim.notify(("error[%s]: %s"):format(name, service))
        vim.notify(("%s"):format(err))
      end
    end
  end
end

---@param config Configuration
function M:setup(config)
  vim.iter(pairs(config.services)):each(function(name, service_config)
    local ok, service = pcall(function(tbl) return service_provider:new(tbl) end, service_config)
    if ok then
      self.services[name] = service
    else
      vim.notify(("error[%s]: %s"):format(name, service))
    end
  end)
end

return M
