local capabilities = require('blink.cmp').get_lsp_capabilities()
require("lspconfig").marksman.setup({
	capabilities = capabilities,
})
return
