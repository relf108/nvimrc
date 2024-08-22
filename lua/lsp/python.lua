-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- local ruff_conf = vim.fn.expand("~/.config/ruff/ruff.toml")
-- require("lspconfig").ruff_lsp.setup({
-- 	capabilities = capabilities,
-- 	on_attach = function(client)
-- 		client.server_capabilities.hoverProvider = false
-- 	end,
-- 	init_options = {
-- 		settings = {
-- 			args = {
-- 				"--config=" .. ruff_conf,
-- 			},
-- 		},
-- 	},
-- })
-- require("lspconfig").jedi_language_server.setup({
-- 	capabilities = capabilities,
-- })
--
require("lspconfig").pyright.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		python = {
			pythonPath = vim.g.python_path(),
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
				typeCheckingMode = "standard",
			},
		},
	},
})
return
