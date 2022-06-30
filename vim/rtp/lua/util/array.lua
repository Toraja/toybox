local Array = setmetatable({}, {__index = table})

local function new(o)
	return setmetatable(o or {}, {
		__index = Array,
	})
end

function Array:append(another)
  for _, v in ipairs(another) do
    table.insert(self, v)
  end
end

function Array:contains(elm)
  for _, v in ipairs(self) do
    if v == elm then
      return true
    end
  end
  return false
end

function Array:for_each(func)
  for _, v in ipairs(self) do
    func(v)
  end
end

return {
  new = new
}
