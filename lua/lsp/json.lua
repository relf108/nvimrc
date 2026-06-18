local lsp = require("lsp")

lsp.enable("jsonls", {
	settings = {
		json = {
			format = {
				enable = true,
			},
		},
		validate = { enable = true },
	},
})
