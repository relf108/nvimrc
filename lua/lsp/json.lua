local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").jsonls.setup({
	capabilities = capabilities,
	settings = {
		json = {
			format = {
				enable = true,
			},
		},
		validate = { enable = true },
	},
})
return
