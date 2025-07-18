-- Define capabilities
local capabilities = require("blink.cmp").get_lsp_capabilities()
capabilities["general"] = { positionEncodings = { "utf-16" } }

-- Ruff
local ruff_conf = vim.fn.expand("~/.config/ruff/ruff.toml")

require("lspconfig").ruff.setup({
	capabilities = capabilities,
	on_attach = function(client)
		client.server_capabilities.hoverProvider = false
	end,
	init_options = {
		settings = {
			args = {
				"--config=" .. ruff_conf,
			},
		},
	},
})

-- Pyright
require("lspconfig").pyright.setup({
	capabilities = capabilities,
	settings = {
		pyright = {
			disableOrganizeImports = true,
		},
		python = {
			pythonPath = vim.g.python_path(),
			analysis = {
				ignore = { "*" },
			},
		},
	},
})

-- require("lspconfig").snyk_ls.setup({
-- 	capabilities = capabilities,
-- 	init_options = {
-- 		activateSnykCode = "true",
-- 		token = require("secrets.snyk").token,
-- 		organization = require("secrets.snyk").organization,
-- 	},
-- })
return
