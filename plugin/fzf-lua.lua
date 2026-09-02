local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" }, { confirm = false, load = function() end })

local function setup()
	require("fzf-lua").setup({})
end

local function load()
	loader.load("fzf-lua", setup)
end

vim.keymap.set("n", "<leader>ff", function()
	load()
	require("fzf-lua").files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
	load()
	require("fzf-lua").live_grep()
end, { desc = "Live grep" })

if vim.fn.argc(-1) == 0 then
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			load()
			require("fzf-lua").files({
				winopts = {
					fullscreen = true,
					on_create = function(args)
						vim.keymap.set("t", "<Esc>", function()
							require("fzf-lua").hide()
							vim.cmd("silent! qa!")
						end, { buffer = args.bufnr, nowait = true })
					end,
				},
			})
		end,
	})
end
