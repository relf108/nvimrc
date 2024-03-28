local function tablelength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

local buff = 0
local curr_buff = vim.api.nvim_buf_get_name(0)

return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			harpoon.setup()
			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():append()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-h>", function()
				curr_buff = vim.api.nvim_buf_get_name(0)
				buff = buff - 1

				harpoon:list():select(buff)

				if curr_buff == vim.api.nvim_buf_get_name(0) then
					buff = tablelength(harpoon:list()) - 1
					harpoon:list():select(buff)
				end
			end)

			vim.keymap.set("n", "<C-l>", function()
				curr_buff = vim.api.nvim_buf_get_name(0)
				buff = buff + 1

				harpoon:list():select(buff)

				if curr_buff == vim.api.nvim_buf_get_name(0) then
					buff = 1
					harpoon:list():select(buff)
				end
			end)
		end,
	},
}
