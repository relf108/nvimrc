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
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `pylsp`:
        ["pylsp"] = function()
          require("lspconfig")["pylsp"].setup({
            capabilities = capabilities,
            settings = {
              pylsp = {
                plugins = {
                  pycodestyle = { enabled = false },
                  flake8 = { enabled = true, maxLineLength = 120 },
                },
              },
            },
          })
        end,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.g.neomake_python_enabled_makers = { "flake8" }
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },
}
