return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				default_config = {
					keymaps = {
						visual = {
							["<leader>mc"] = "<cmd>lua require('mason').compare()<CR>",
							["<leader>ms"] = "<cmd>lua require('mason').swap()<CR>",
							["<leader>mu"] = "<cmd>lua require('mason').update()<CR>",
							["<leader>mr"] = "<cmd>lua require('mason').remove()<CR>",
						},
						n = {
							["<leader>mc"] = "<cmd>lua require('mason').compare()<CR>",
							["<leader>ms"] = "<cmd>lua require('mason').swap()<CR>",
							["<leader>mu"] = "<cmd>lua require('mason').update()<CR>",
							["<leader>mr"] = "<cmd>lua require('mason').remove()<CR>",
						},
					},
				},
			})
		end,
	},
}