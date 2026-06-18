local M = {}

-- Shared client capabilities (blink.cmp + utf-16 position encoding)
M.capabilities = require("blink.cmp").get_lsp_capabilities()
M.capabilities.general = { positionEncodings = { "utf-16" } }

-- Configure and enable an LSP server, merging in the shared capabilities.
-- Wraps the modern vim.lsp.config + vim.lsp.enable API (Neovim 0.11+).
function M.enable(name, cfg)
	cfg = cfg or {}
	cfg.capabilities = vim.tbl_deep_extend("force", M.capabilities, cfg.capabilities or {})
	vim.lsp.config(name, cfg)
	vim.lsp.enable(name, true)
end

return M
