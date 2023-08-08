---@generic T, U
---@param proxy T
---@param obj U
---@return U: T
local Proxy = function(proxy, obj)
  return setmetatable(obj, {
    __index = function(_, k)
      return proxy[k]
    end
  })
end
return Proxy
