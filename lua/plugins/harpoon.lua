local buff = 0

return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			harpoon.setup()
			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
				buff = harpoon:list():length()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-h>", function()
				if harpoon:list():length() == 0 then
					return
				end

				buff = buff - 1

				harpoon:list():select(buff)

				-- Circle back to the last buffer if the first buffer is reached
				if buff < 1 then
					buff = harpoon:list():length()
					harpoon:list():select(buff)
				end
			end)

			vim.keymap.set("n", "<C-l>", function()
				if harpoon:list():length() == 0 then
					return
				end

				buff = buff + 1
				harpoon:list():select(buff)

				-- Circle back to the first buffer if the last buffer is reached
				if buff > harpoon:list():length() then
					buff = 1
					harpoon:list():select(buff)
				end
			end)
		end,
	},
}
