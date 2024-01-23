-- Show relative line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Set terminal to 24-bit color
vim.opt.termguicolors = true

-- Default indentation if not overridden by TreeSitter
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Save yanks to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Auto read on file change from external process
vim.opt.autoread = true

-- Auto save on text change
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.autocmd = {
	"TextChanged",
	".*",
	"silent",
	"update",
}
vim.autocmd = {
	"InsertLeave",
	".*",
	"silent",
	"update",
}

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- Toggle term
vim.g.floaterm_keymap_toggle = "<C-t>"

-- Theme config - matches catppuccino-mocha
vim.g.colors = {
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

vim.g.catppuccin_theme = {
	normal = {
		a = { fg = vim.g.colors.black, bg = vim.g.colors.mauve },
		b = { fg = vim.g.colors.white, bg = vim.g.colors.surface_zero },
		c = { fg = vim.g.colors.base, bg = vim.g.colors.base },
	},
	insert = { a = { fg = vim.g.colors.black, bg = vim.g.colors.blue } },
	visual = { a = { fg = vim.g.colors.black, bg = vim.g.colors.teal } },
	replace = { a = { fg = vim.g.colors.black, bg = vim.g.colors.red } },
	terminal = { a = { fg = vim.g.colors.black, bg = vim.g.colors.peach } },
	command = { a = { fg = vim.g.colors.black, bg = vim.g.colors.green } },
	inactive = {
		a = { fg = vim.g.colors.white, bg = vim.g.colors.black },
		b = { fg = vim.g.colors.white, bg = vim.g.colors.black },
		c = { fg = vim.g.colors.black, bg = vim.g.colors.black },
	},
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

vim.g.completion_matching_strategy_list = { "exact", "substring" }
vim.g.completion_matching_ignore_case = 1

function vim.g.file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

require("dap.ext.vscode").load_launchjs()

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
