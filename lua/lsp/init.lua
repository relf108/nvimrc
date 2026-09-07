local M = {}

vim.api.nvim_exec_autocmds("User", { pattern = "LoadBlinkCmp" })

function M.enable(name, cfg)
	vim.lsp.config(name, cfg or {})
	vim.lsp.enable(name, true)
end

return M
