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

-- Toggle term (Need to be configured as globals)
vim.g.floaterm_keymap_toggle = "<C-t>"
vim.g.floaterm_keymap_new = "TT"
vim.g.floaterm_keymap_kill = "TD"
vim.g.floaterm_keymap_next = "TK"
vim.g.floaterm_keymap_prev = "TJ"
vim.g.floaterm_keymap_first = "TH"
vim.g.floaterm_keymap_last = "TL"

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

function vim.g.get_buf_by_name(name)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_name(buf) == name then
			return buf
		end
	end
	return 0
end

function vim.g.python_path()
	local conda = os.getenv("CONDA_PREFIX")
	if conda then
		return conda .. "/bin/python"
	else
		return vim.fn.exepath("python")
	end
end

vim.g.python3_host_prog = vim.g.python_path()
vim.g.python_host_prog = vim.g.python_path()

vim.g.work_dir = os.getenv("WORK_DIR") or os.getenv("HOME")

function vim.g.file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
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

-- Tab management
vim.keymap.set("n", "tt", ":tabnew<cr>")
vim.keymap.set("n", "td", ":tabclose<cr>")
vim.keymap.set("n", "tk", ":tabnext<cr>")
vim.keymap.set("n", "tj", ":tabprev<cr>")
vim.keymap.set("n", "th", ":tabfirst<cr>")
vim.keymap.set("n", "tl", ":tablast<cr>")
