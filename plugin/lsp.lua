local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" }, { confirm = false, load = function() end })

local function setup()
	require("lsp.python")
	require("lsp.lua")
	require("lsp.json")
	require("lsp.markdown")

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
		callback = function(ev)
			if vim.b[ev.buf].user_lsp_configured then
				return
			end
			vim.b[ev.buf].user_lsp_configured = true
			vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
			local opts = { buffer = ev.buf }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		end,
	})
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "lua", "markdown", "markdown.mdx", "python" },
	once = true,
	callback = function()
		loader.load("nvim-lspconfig", setup)
	end,
})
