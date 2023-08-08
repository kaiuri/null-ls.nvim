local events = require 'null-ls.events'

---@class Dispatch
local M = {}

---@param service FormattingService
M.formatting = function(service)
  local args = service.cmd
  local ok, err = pcall(vim.api.nvim_cmd, {
    addr = "line",
    args = args,
    cmd = "!",
    -- magic = {file = true},
    mods = {silent = true},
  }, {output = false})
  if not ok then
    vim.notify(("error[%s]: %s"):format(service.kind, args))
    vim.notify(("%s"):format(err))
  end
end

---@param service DiagnosticService
M.diagnostic = function(service)
  if not service.filetypes[vim.bo.filetype] then return end
  local cmd = service.cmd
  local job = vim.system(service.cmd, {
    text = true,
    stdin = true,
    stdout = false,
    stderr = false,
    cmd = cmd,
  }):wait()
  local output = job.stderr or job.stdout
  if not output then return end
  local diagnostics = service:post_process(output)
  vim.diagnostic.set(service.namespace, service.bufnr, diagnostics)
end

---@param service DiagnosticService | FormattingService
return function(service)
  M[service.kind](service)
end
