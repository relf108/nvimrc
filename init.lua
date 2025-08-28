-- Show relative line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Enable spellcheck
vim.opt.spelllang = "en_au"
vim.opt.spell = true

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
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})
-- Auto save on text change
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
	pattern = "*",
	command = "silent! update",
})

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

-- Setup theme configuration
local theme_status, theme = pcall(require, "config.theme")
if theme_status then
	theme.setup()
else
	vim.notify("Failed to load theme configuration", vim.log.levels.WARN)
end

-- Load utility functions
local utils_status, utils = pcall(require, "utils")
if utils_status then
	vim.g.get_buf_by_name = utils.get_buf_by_name
	vim.g.file_exists = utils.file_exists
	vim.g.python_path = utils.python_path
else
	vim.notify("Failed to load utils module", vim.log.levels.ERROR)
	-- Fallback implementations
	vim.g.get_buf_by_name = function()
		return 0
	end
	vim.g.file_exists = function()
		return false
	end
	vim.g.python_path = function()
		return "python"
	end
end

vim.g.python3_host_prog = vim.g.python_path()
vim.g.python_host_prog = vim.g.python_path()
vim.g.work_dir = os.getenv("WORK_DIR") or "/tmp"

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

vim.keymap.set("n", "<leader>f", require("formatting.utils.format"), { noremap = true })

vim.g.completion_matching_strategy_list = { "exact", "substring" }
vim.g.completion_matching_ignore_case = 1

local utils_status, utils = pcall(require, "utils")
if not utils_status then
	vim.notify("Failed to load utils module", vim.log.levels.ERROR)
	utils = { cmd_repeat = function() end } -- fallback
end
local cmdrepeat = utils.cmd_repeat

-- Tab management
vim.keymap.set("n", "tt", ":tabnew<cr>")
vim.keymap.set("n", "td", ":tabclose<cr>")
vim.keymap.set("n", "tk", function()
	return cmdrepeat(":tabnext")
end)
vim.keymap.set("n", "tj", function()
	return cmdrepeat(":tabprevious")
end)
vim.keymap.set("n", "th", ":tabfirst<cr>")
vim.keymap.set("n", "tl", ":tablast<cr>")

vim.keymap.set("n", "<leader>dd", vim.diagnostic.setloclist)

vim.keymap.set("n", "<leader>sn", function()
	vim.opt.relativenumber = true
	vim.opt.number = true
end)
