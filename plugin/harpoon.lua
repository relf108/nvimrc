local loader = require("plugin_loader")

vim.pack.add({
	{
		src = "https://github.com/ThePrimeagen/harpoon",
		version = "harpoon2",
	},
}, { confirm = false, load = function() end })

local function load()
	loader.load("harpoon", function()
		require("harpoon").setup()
	end)
end

vim.keymap.set("n", "<leader>a", function()
	load()
	require("harpoon"):list():add()
end, { desc = "Add to harpoon" })

vim.keymap.set("n", "<C-e>", function()
	load()
	require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end, { desc = "Harpoon menu" })

local function select_adjacent(direction)
	load()
	local harpoon_list = require("harpoon"):list()
	local length = harpoon_list:length()
	if length == 0 then
		return
	end

	local current_file = vim.api.nvim_buf_get_name(0)
	local current_index
	for i = 1, length do
		local item = harpoon_list:get(i)
		if item and item.value and vim.fn.fnamemodify(item.value, ":p") == current_file then
			current_index = i
			break
		end
	end

	if direction == "previous" then
		if current_index == 1 or current_index == nil then
			harpoon_list:select(length)
		else
			harpoon_list:prev()
		end
	elseif current_index == length or current_index == nil then
		harpoon_list:select(1)
	else
		harpoon_list:next()
	end
end

vim.keymap.set("n", "<C-h>", function()
	select_adjacent("previous")
end, { desc = "Previous harpoon" })

vim.keymap.set("n", "<C-l>", function()
	select_adjacent("next")
end, { desc = "Next harpoon" })
