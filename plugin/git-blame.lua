local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/f-person/git-blame.nvim" }, { confirm = false, load = function() end })

local load = loader.lazy(function()
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
