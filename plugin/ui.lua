local loader = require("plugin_loader")

vim.pack.add({
	"https://github.com/rcarriga/nvim-notify",
	"https://github.com/folke/noice.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
}, { confirm = false, load = function() end })

local function load_notify()
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
end

local function load_noice()
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
		vim.keymap.set("n", "<leader>nd", function()
			require("noice").cmd("dismiss")
		end, { desc = "Dismiss notifications" })
	end)
end

local function load_lualine()
	load_noice()
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
						require("noice").api.status.command.get,
						cond = require("noice").api.status.command.has,
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

vim.schedule(load_lualine)
