local loader = require("plugin_loader")

vim.pack.add({
	"https://github.com/rcarriga/nvim-notify",
	"https://github.com/folke/noice.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
}, { confirm = false, load = function() end })

local original_notify = vim.notify
local load_notify = loader.lazy(function()
	-- Keep loader error reporting from re-entering the notification proxy.
	vim.notify = original_notify
	loader.load("nvim-notify", function()
		require("notify").setup({
			stages = "static",
			fps = 60,
			timeout = 5000,
			background_colour = "#000000",
			icons = {
				ERROR = "",
				WARN = "",
				INFO = "",
				DEBUG = "",
				TRACE = "✎",
			},
		})
		vim.notify = require("notify")
	end)
end)

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

vim.notify = function(message, level, opts)
	if vim.in_fast_event() then
		vim.schedule(function()
			vim.notify(message, level, opts)
		end)
		return
	end
	load_notify()
	return vim.notify(message, level, opts)
end

loader.lazy_commands({
	Notifications = { desc = "Show notification history" },
	NotificationsClear = { desc = "Clear notification history" },
}, load_notify)

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

local function load_lualine()
	loader.load("lualine.nvim", function()
		require("lualine").setup({
			options = {
				theme = vim.g.catppuccin_theme,
				component_separators = "|",
				section_separators = { left = "", right = "" },
				globalstatus = true,
			},
			sections = {
				lualine_a = {
					{ "mode", separator = { left = "" }, right_padding = 2 },
				},
				lualine_b = { "branch", { "filename", path = 1 }, "diagnostics" },
				lualine_c = { "fileformat" },
				lualine_x = {
					{
						function()
							return package.loaded["noice"].api.status.command.get()
						end,
						cond = function()
							local config = package.loaded["noice.config"]
							return config and config.is_running() and package.loaded["noice"].api.status.command.has()
								or false
						end,
						color = { fg = vim.g.colors.peach, bg = vim.g.colors.base },
					},
				},
				lualine_y = { "filetype", "progress" },
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
				},
			},
			tabline = {},
			extensions = {},
		})
	end)
end

vim.api.nvim_create_autocmd("UIEnter", { once = true, callback = load_lualine })
