vim.pack.add({
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
}, { confirm = false, load = true })

require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = { documentation = { auto_show = false } },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		per_filetype = {
			lua = { "lazydev", "lsp", "path", "snippets", "buffer" },
			mysql = { "snippets", "dadbod", "buffer" },
			plsql = { "snippets", "dadbod", "buffer" },
			sql = { "snippets", "dadbod", "buffer" },
		},
		providers = {
			dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				score_offset = 100,
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
