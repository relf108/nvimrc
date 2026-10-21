local M = {}

function M.open(load)
	load()
	return require("fzf_version_cache").call(require("fzf-lua").files, {
		winopts = {
			fullscreen = true,
			on_create = function(args)
				if vim.v.vim_did_enter == 0 then
					vim.api.nvim_create_autocmd("VimEnter", {
						once = true,
						callback = function()
							if vim.api.nvim_win_is_valid(args.winid) then
								vim.api.nvim_set_current_win(args.winid)
								vim.cmd.startinsert()
							end
						end,
					})
				end
				vim.keymap.set("t", "<Esc>", function()
					require("fzf-lua").hide()
					vim.cmd("silent! qa!")
				end, { buffer = args.bufnr, nowait = true })
			end,
		},
	})
end

return M
