local loader = require("plugin_loader")
local load_notify = require("ui.notify").load

-- Hide the command-line row while idle; commands and messages can still show it.
vim.opt.cmdheight = 0

vim.pack.add({ "https://github.com/folke/noice.nvim" }, { confirm = false, load = function() end })

local load_noice = loader.lazy(function()
	load_notify()
	loader.load("noice.nvim", function()
		require("noice").setup({
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			presets = {
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		})
	end)
end)

vim.keymap.set("n", "<leader>nd", function()
	local config = package.loaded["noice.config"]
	if config and config.is_running() then
		require("noice").cmd("dismiss")
	elseif package.loaded["notify"] then
		require("notify").dismiss({ pending = true, silent = true })
	end
end, { desc = "Dismiss notifications" })

vim.api.nvim_create_autocmd({ "CmdlineEnter", "LspAttach" }, {
	once = true,
	callback = load_noice,
})

vim.api.nvim_create_autocmd("CmdUndefined", {
	pattern = "Noice*",
	once = true,
	callback = function()
		load_noice()
		-- Noice registers its commands on the next event-loop turn.
		vim.wait(1000, function()
			local config = package.loaded["noice.config"]
			return config and config.is_running()
		end, 1)
	end,
})
