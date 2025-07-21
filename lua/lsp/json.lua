local capabilities = require("blink.cmp").get_lsp_capabilities()
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
