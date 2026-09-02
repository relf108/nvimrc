local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/f-person/git-blame.nvim" }, { confirm = false, load = function() end })

local function load()
	loader.load("git-blame.nvim", function()
		require("gitblame").setup({
			enabled = false,
			virt_text = true,
			virt_text_pos = "eol",
			delay = 1000,
		})
	end)
end

vim.api.nvim_create_autocmd("CmdUndefined", {
	pattern = { "GitBlameToggle", "GitBlameEnable", "GitBlameDisable" },
	once = true,
	callback = load,
})

vim.keymap.set("n", "<leader>gb", function()
	load()
	vim.cmd.GitBlameToggle()
end, { desc = "Toggle Git Blame" })
