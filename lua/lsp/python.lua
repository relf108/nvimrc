local lsp = require("lsp")

-- Ruff
local ruff_conf = vim.fn.expand("~/.config/ruff/ruff.toml")

lsp.enable("ruff", {
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

-- ty
lsp.enable("ty")
