local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/f-person/git-blame.nvim" }, { confirm = false, load = function() end })

local load = loader.lazy_commands({
	GitBlameToggle = { nargs = 0 },
	GitBlameEnable = { nargs = 0 },
	GitBlameDisable = { nargs = 0 },
	GitBlameOpenCommitURL = { nargs = 0 },
	GitBlameOpenFileURL = { nargs = 0, range = true },
	GitBlameCopySHA = { nargs = 0 },
	GitBlameCopyCommitURL = { nargs = 0 },
	GitBlameCopyFileURL = { nargs = 0, range = true },
	GitBlameCopyPRURL = { nargs = 0 },
}, function()
	loader.load("git-blame.nvim", function()
		require("gitblame").setup({
			enabled = false,
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
		})
	end)
end)

vim.keymap.set("n", "<leader>gb", function()
	load()
	vim.cmd.GitBlameToggle()
end, { desc = "Toggle Git Blame" })
