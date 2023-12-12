local stringutil = require('../string')

describe('has_suffix', function()
    it('returns true if the string ends in the given substring', function()
        assert.True(stringutil.has_suffix('suffix', 'ix'))
    end)

    it('returns false if the string does not end in the given substring', function()
        assert.False(stringutil.has_suffix('suffix', 'fi'))
    end)
end)
