lu = require('luaunit')
array = require('array')

function test_append_to_empty_self()
    local x = array.new()
    x:append({3, 4, 5})
    lu.assertEquals(x, {3, 4, 5})
end


function test_append_to_self_with_initial_values()
    local x = array.new({1, 2})
    local y = {3, 4, 5}
    x:append(y)
    lu.assertEquals(x, {1, 2, 3, 4, 5})
end

function test_append_empty_array()
    local x = array.new({1, 2})
    x:append({})
    lu.assertEquals(x, {1, 2})
end

function test_contains()
    local x = array.new({1, 2})
    lu.assertTrue(x:contains(1))
    lu.assertTrue(x:contains(2))
    lu.assertFalse(x:contains(3))
end

function test_for_each()
    local result = ""
    local arr = array.new({'a', 'b', 'c'})
    arr:for_each(function(x)
        result = result .. 'x' .. x
    end)
    lu.assertEquals(result, 'xaxbxc')
end

os.exit(lu.LuaUnit.run())
