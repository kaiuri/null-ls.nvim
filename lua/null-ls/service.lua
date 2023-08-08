---@class ServiceProvider
local M = {}
M.registry = {}

---Processes the results, returning an array of
---diagnostic structures. If missing, source is a formatting source.
---@alias post_process fun(self: Service, output: string): Diagnostic[]
---@alias ProviderKind "formatting"|"diagnostic"

---@class ServiceConfiguration
---@field cmd string[] # the source's executable path, for dynamically generated variables use |statusline| syntax
---@field filetypes string[] # filetypes this source is allowed to run in
---@field post_process? post_process


---@class Service: ServiceConfiguration
---@field bufnr integer                                 # current buffer's id
---@field namespace integer                             # The namespace to use for the diagnostics
---@field run fun(self: Service)                        # runs the source
---@field filetypes table<string|number, string|number> # filetypes this source is allowed to run in
---@field kind "formatting"|"diagnostic"                # The kind of source. Used for


---@class DiagnosticService: Service
---@field post_process post_process # The function to process the results of the source. If missing, source is a formatting source.
---@field kind "diagnostic" # The kind of source. Used for
---@class FormattingService: Service

local eval_cmd = require 'null-ls.eval'.cmd
local Run = require 'null-ls.dispatch'

---@param args ServiceConfiguration
---@return DiagnosticService|FormattingService
local function ServiceBuilder(args)
  local o = {}
  o.kind = args.post_process and "diagnostic" or "formatting"
  o.filetypes = vim.tbl_add_reverse_lookup(args.filetypes) --- this way we avoid looping over the filetypes' list with `list_contains`
  o.namespace = vim.api.nvim_create_namespace(tostring(vim.fn.rand()))
  function o:run()
    Run(self)
  end

  local service = setmetatable(o, {
    __index = function(_, key)
      if key == 'cmd' then
        return eval_cmd(args.cmd)
      elseif key == 'bufnr' then
        return vim.api.nvim_get_current_buf()
      end
    end,
    __newindex = function() error("This object is immutable") end,
    __tostring = function()
      return string.format("%s: %s", o.kind, o.cmd[1])
    end
  })

  if service.kind == 'diagnostic' then
    assert(service.post_process, "Diagnostic services must have a post_process function")
    return service --[=[@as DiagnosticService]=]
  end
  return service --[=[@as FormattingService]=]
end

function M:new(args)
  local key = table.concat(args.cmd, ' ')
  assert(not self.registry[key], 'Please, please! Do not register the same service twice, ok? ' .. key)
  local service = ServiceBuilder(args)
  self.registry[args.cmd] = true
  return service
end

return M
