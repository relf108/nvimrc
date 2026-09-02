-- Disable netrw (we use fzf-lua on startup instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.opt.updatetime = 1000 -- Trigger CursorHold after one second of idle time
local autoread_group = vim.api.nvim_create_augroup("UserAutoRead", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
	group = autoread_group,
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*" },
})
-- Auto save on text change
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
	group = autoread_group,
	pattern = "*",
	command = "silent! update",
})

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- Setup theme configuration
local theme_status, theme = pcall(require, "config.theme")
if theme_status then
	theme.setup()
else
	vim.notify("Failed to load theme configuration", vim.log.levels.WARN)
end

-- Load utility functions (required directly where needed via require("utils"))
local utils_status, utils = pcall(require, "utils")
if not utils_status then
	vim.notify("Failed to load utils module", vim.log.levels.ERROR)
	utils = nil
end

-- python_path() is memoized in utils, so these share one resolution
local python_path = utils and utils.python_path() or "python"
vim.g.python3_host_prog = python_path
vim.g.python_host_prog = python_path
vim.g.work_dir = os.getenv("WORK_DIR") or "/tmp"

vim.keymap.set("n", "<leader>f", function()
	require("formatting.utils.format")()
end, { noremap = true })

-- Reuse already loaded utils module
local cmdrepeat = utils and utils.cmd_repeat or function() end

-- Defer non-critical keymaps to after startup for faster load time
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
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
	end,
})
