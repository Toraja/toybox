local ft_common = require("ft-common")
local yamlfmt_configs = { ".yamlfmt", "yamlfmt.yml", "yamlfmt.yaml", ".yamlfmt.yaml", ".yamlfmt.yml" }
if not vim.fs.root(0, yamlfmt_configs) then
	ft_common.disable_auto_format()
end
