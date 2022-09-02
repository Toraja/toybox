vim.wo.foldlevel = 2

require('nvim-surround').buffer_setup({
  surrounds = {
    ["v"] = {
      add = { "{{ ", " }}" },
      find = function()
        return M.get_selection({ motion = "a{{" })
      end,
    },
  }
})
