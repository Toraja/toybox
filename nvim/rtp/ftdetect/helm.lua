vim.filetype.add({
	extension = {
		gotmpl = "gotmpl",
	},
	pattern = {
		[".*%.yaml%.gotmpl"] = "helm",
		[".*/templates/.*%.tpl"] = "helm",
		[".*/templates/.*%.ya?ml"] = "helm",
		["helmfile.*%.ya?ml"] = "helm",
	},
})
