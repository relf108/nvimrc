local loader = require("plugin_loader")

-- Lualine owns mode and position, even before Noice loads.
vim.opt.showmode = false
vim.opt.ruler = false

vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" }, { confirm = false, load = function() end })

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
