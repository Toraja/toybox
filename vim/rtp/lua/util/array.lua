local Array = setmetatable({}, {__index = table})

local function new(o)
	return setmetatable(o or {}, {
		__index = Array,
	})
end

--- Append another array.
--- Append another Array.
-- @param another (Array) array to append
function Array:append(another)
  for _, v in ipairs(another) do
    table.insert(self, v)
  end
end

--- Test if Array contains the given element.
-- @param elm element to check
-- @return boolean
function Array:contains(elm)
  for _, v in ipairs(self) do
    if v == elm then
      return true
    end
  end
  return false
end

--- Run the given function with each element in the Array.
-- @param func (function) function with single argument
function Array:for_each(func)
  for _, v in ipairs(self) do
    func(v)
  end
end

return {
  new = new
}
