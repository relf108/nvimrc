vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		if #vim.v.event.regcontents <= 10000 then
			vim.hl.on_yank({ timeout = 1000 })
		end
	end,
})
