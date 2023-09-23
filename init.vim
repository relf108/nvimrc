set relativenumber
set autowriteall
set smartindent
set expandtab
set shiftwidth=2
set tabstop=2
set clipboard+=unnamedplus

autocmd BufWritePre .* :%s/\s\+$//e
autocmd TextChanged .* update
autocmd InsertLeave .* update

call plug#begin()
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'neomake/neomake'
Plug 'machakann/vim-highlightedyank'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Plug 'voldikss/vim-floaterm'
Plug 'github/copilot.vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
Plug 'numToStr/Comment.nvim'
Plug 'folke/trouble.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python'
call plug#end()

lua require('dap-python').setup(os.getenv("CONDA_PREFIX") .. "/bin/python")

let g:deoplete#enable_at_startup = 1

let g:neomake_python_enabled_makers = ['pylint']

call neomake#configure#automake('nrwi', 500)

colorscheme catppuccin-mocha

lua << EOF

vim.g.host = ""
vim.g.host_ro = ""
vim.g.user = ""
vim.g.password = ""

function PytestArgs()
   if vim.g.host ~= "" and vim.g.host_ro ~= "" and vim.g.user ~= "" and vim.g.password ~= "" and vim.fn.input("Use last values? (y/n): ") == "y" then
       return {
           DB_HOST=vim.g.host,
           DB_HOST_RO=vim.g.host_ro,
           DB_USER=vim.g.user,
           DB_PASSWORD=vim.g.password,
           DEBUG="True"
       }
   end
    vim.g.host=vim.fn.input("DB_HOST: ")
    vim.g.host_ro=vim.fn.input("DB_HOST_RO: ")
    vim.g.user=vim.fn.input("DB_USER: ")
    vim.g.password=vim.fn.input("DB_PASSWORD: ")
    return {
         DB_HOST=vim.g.host,
         DB_HOST_RO=vim.g.host_ro,
         DB_USER=vim.g.user,
         DB_PASSWORD=vim.g.password,
         DEBUG="True"
     }
end

local dap = require('dap')
 
dap.adapters.dart = {
  type = "executable",
  command = "dart",
  args = {"debug_adapter"}
}
dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Launch Dart Program",
    program = "${file}",
    cwd = "${workspaceFolder}",
    args = {"--help"},
  }
}
dap.adapters.dart = {
  type = "executable",
  command = "flutter",
  args = {"debug_adapter"}
}
dap.configurations.dart = {
  {
    type = "dart",
    request = "launch",
    name = "Launch Flutter Program",
    program = "${file}",
    cwd = "${workspaceFolder}",
  --   toolArgs = {"-d", "ios"}
  }
}

local dapvscode = require('dap.ext.vscode')
dapvscode.load_launchjs()

local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {}
  }
}

lspconfig.dartls.setup {
  filetypes = {'dart'},
  init_options = {
    closingLabels = true,
    flutterOutline = true,
    onlyAnalyzeProjectsWithOpenFiles = true,
    outline = true,
    suggestFromUnimportedLibraries = true,
  },
  root_dir = lspconfig.util.root_pattern('pubspec.yaml', '.git'),
}

vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)

    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
require('dap.ui.widgets').hover()
end)
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
local widgets = require('dap.ui.widgets')
widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
local widgets = require('dap.ui.widgets')
widgets.centered_float(widgets.scopes)
end)

vim.keymap.set("n", "<leader>xx", function() require("trouble").open() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").open("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").open("lsp_references") end)

vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run({vim.fn.expand("%"), strategy = "dap", env = PytestArgs()}) end)

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "dart", "typescript" },
  sync_install = false,
  ignore_install = { "javascript" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true
  }
}
require('Comment').setup()
require'nvim-web-devicons'.setup {
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 color_icons = true;
 default = true;
 strict = true;
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  }
 };
}
require("neotest").setup({
  adapters = {
    require("neotest-python")
  }
})
EOF
