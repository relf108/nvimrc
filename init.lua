-- Show relative line numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Default indentation if not overridden by TreeSitter
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Save yanks to system clipboard
vim.opt.clipboard = "unnamedplus"

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

-- Remove trailing whitespace
vim.autocmd = {
	"BufWritePre",
	".*",
	"silent",
	"g/\\s\\+$/s///e",
}
vim.autocmd = {
	"BufWritePost",
	".*",
	"normal!",
	"`^",
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

-- Autocomplete for vim-dadbod
vim.autocmd = {
	"FileType",
	"sql,mysql,plsql",
	"lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })",
}
vim.g.completion_chain_complete_list = {
	sql = {
		complete_items = {
			"vim-dadbod-completion",
		},
	},
}
vim.g.completion_matching_strategy_list = { "exact", "substring" }
vim.g.completion_matching_ignore_case = 1

-- Python linting
vim.g.neomake_python_enabled_makers = { "flake8" }

-- Neomake config
vim.fn["neomake#configure#automake"]("nrwi", 100)

vim.opt.termguicolors = true

local function file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

local function pytest_env()
	if not file_exists(".vscode/launch.json") then
		return {}
	end
	local file = io.open(".vscode/launch.json", "r")
	local configs = require("json"):decode(file:read("*all"))["configurations"]
	for _, config in pairs(configs) do
		if config["module"] == "pytest" then
			return config["env"]
		end
	end
end

local dapvscode = require("dap.ext.vscode")
dapvscode.load_launchjs()

vim.api.nvim_set_keymap("n", "<leader>du", ':lua require("dapui").toggle()<CR>', { noremap = true, silent = true })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.api.nvim_set_keymap(
	"n",
	"<Leader>ff",
	':lua require"telescope.builtin".find_files({ hidden = true, file_ignore_patterns = {".git"} })<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>fg",
	':lua require"telescope.builtin".live_grep({ hidden = true, file_ignore_patterns = {".git"} })<CR>',
	{ noremap = true, silent = true }
)

-- DBUI mappings
vim.api.nvim_set_keymap("n", "<Leader>dbt", ":call db_ui#toggle()<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>dbf", ":call db_ui#find_buffer()<CR>", {})

-- Problems view
-- vim.keymap.set("n", "<Leader>xx", vim.cmd.lopen, {})
vim.keymap.set("n", "<leader>xx", function()
	require("trouble").toggle()
end)

-- Conda
vim.keymap.set("n", "<Leader>cc", vim.cmd.CondaActivate, {})

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

vim.keymap.set("n", "<leader>nd", function()
	require("noice").cmd("dismiss")
end)

vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
	require("dap").step_out()
end)
vim.keymap.set("n", "<F9>", function()
	require("dap").terminate()
end)
vim.keymap.set("n", "<Leader>b", function()
	require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
	require("dap").set_breakpoint()
end)
vim.keymap.set("n", "<Leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dr", function()
	require("dap").repl.open()
end)
vim.keymap.set("n", "<Leader>dl", function()
	require("dap").run_last()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end)
vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end)
vim.keymap.set("n", "<Leader>df", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)

vim.keymap.set("n", "<leader>tf", function()
	require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap", env = pytest_env() })
end)

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"python",
		"dart",
		"typescript",
		"regex",
		"bash",
		"markdown",
		"markdown_inline",
		"sql",
	},
	sync_install = true,
	ignore_install = { "javascript" },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	},
	indent = {
		enable = true,
	},
})

require("Comment").setup()

require("nvim-web-devicons").setup({
	override = {
		zsh = {
			icon = "",
			color = "#428850",
			cterm_color = "65",
			name = "Zsh",
		},
	},
	color_icons = true,
	default = true,
	strict = true,
	override_by_filename = {
		[".gitignore"] = {
			icon = "",
			color = "#f1502f",
			name = "Gitignore",
		},
	},
	override_by_extension = {
		["log"] = {
			icon = "",
			color = "#81e043",
			name = "Log",
		},
	},
})

require("neotest").setup({
	adapters = {
		require("neotest-python"),
	},
})
-- Set up nvim-cmp.
local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	window = {},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" }, -- For vsnip users.
	}, {
		{ name = "buffer" },
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
