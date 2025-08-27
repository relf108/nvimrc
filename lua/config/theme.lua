local M = {}

-- Theme config - matches catppuccino-mocha
M.colors = {
	blue = "#89b4fa",
	teal = "#94e2d5",
	base = "#1e1e2e",
	black = "#080808",
	white = "#cdd6f4",
	red = "#f38ba8",
	mauve = "#cba6f7",
	surface_zero = "#313244",
	peach = "#fab387",
	green = "#a6e3a1",
}

M.catppuccin_theme = {
	normal = {
		a = { fg = M.colors.black, bg = M.colors.mauve },
		b = { fg = M.colors.white, bg = M.colors.surface_zero },
		c = { fg = M.colors.base, bg = M.colors.base },
	},
	insert = { a = { fg = M.colors.black, bg = M.colors.blue } },
	visual = { a = { fg = M.colors.black, bg = M.colors.teal } },
	replace = { a = { fg = M.colors.black, bg = M.colors.red } },
	terminal = { a = { fg = M.colors.black, bg = M.colors.peach } },
	command = { a = { fg = M.colors.black, bg = M.colors.green } },
	inactive = {
		a = { fg = M.colors.white, bg = M.colors.black },
		b = { fg = M.colors.white, bg = M.colors.black },
		c = { fg = M.colors.black, bg = M.colors.black },
	},
}

-- Setup theme globals
function M.setup()
	vim.g.colors = M.colors
	vim.g.catppuccin_theme = M.catppuccin_theme
end

return M
