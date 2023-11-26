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
Plug 'nvim-lualine/lualine.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'neomake/neomake'
Plug 'machakann/vim-highlightedyank'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'voldikss/vim-floaterm'
Plug 'github/copilot.vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.x' }
Plug 'numToStr/Comment.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'
Plug 'nvim-neotest/neotest-python'
Plug 'preservim/nerdtree'
Plug 'akinsho/git-conflict.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'mattboehm/vim-unstack'
Plug 'rcarriga/nvim-dap-ui'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'declancm/cinnamon.nvim'
call plug#end()

" DADBOD "
autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
let g:completion_chain_complete_list = {
    \   'sql': [
    \    {'complete_items': ['vim-dadbod-completion']},
    \   ],
    \ }
" Make sure `substring` is part of this list. Other items are optional for this completion source
let g:completion_matching_strategy_list = ['exact', 'substring']
" Useful if there's a lot of camel case items
let g:completion_matching_ignore_case = 1

let g:neomake_python_enabled_makers = ['pylint']
let g:floaterm_keymap_toggle = '<C-t>'

lua require('dap-python').setup(os.getenv("CONDA_PREFIX") .. "/bin/python")
lua require('git-conflict').setup()
lua require('noice').setup()

call neomake#configure#automake('nrwi', 500)

colorscheme catppuccin-mocha

lua << EOF


vim.opt.termguicolors = true
vim.notify = require("notify")

-- Setup smooth scrolling
require("cinnamon").setup {
    extra_keymaps = true,
    extended_keymaps = true,
    override_keymaps = true,
    always_scroll = true,
    default_delay = 0.05,
    max_length = 250
}

-- Lualine theme
local colors = {
    blue = "#80a0ff",
    cyan = "#79dac8",
    black = "#080808",
    white = "#c6c6c6",
    red = "#ff5189",
    violet = "#d183e8",
    grey = "#303030"
}

local bubbles_theme = {
    normal = {
        a = {fg = colors.black, bg = colors.violet},
        b = {fg = colors.white, bg = colors.grey},
        c = {fg = colors.black, bg = colors.black}
    },
    insert = {a = {fg = colors.black, bg = colors.blue}},
    visual = {a = {fg = colors.black, bg = colors.cyan}},
    replace = {a = {fg = colors.black, bg = colors.red}},
    inactive = {
        a = {fg = colors.white, bg = colors.black},
        b = {fg = colors.white, bg = colors.black},
        c = {fg = colors.black, bg = colors.black}
    }
}

require("lualine").setup {
    options = {
        theme = bubbles_theme,
        component_separators = "|",
        section_separators = {left = "", right = ""},
        globalstatus = true
    },
    sections = {
        lualine_a = {
            {"mode", separator = {left = ""}, right_padding = 2}
        },
        lualine_b = {"branch", {"filename", path = 1}, "diagnostics"},
        lualine_c = {"fileformat"},
        lualine_x = {},
        lualine_y = {"filetype", "progress"},
        lualine_z = {
            {"location", separator = {right = ""}, left_padding = 2}
        }
    },
    tabline = {},
    extensions = {}
}

local json = require("json")

function file_exists(file)
    local f = io.open(file, "rb")
    if f then
        f:close()
    end
    return f ~= nil
end

function pytest_env()
    if not file_exists(".vscode/launch.json") then
        return {}
    end
    local file = io.open(".vscode/launch.json", "r")
    local configs = json:decode(file:read("*all"))["configurations"]
    for _, config in pairs(configs) do
        if config["module"] == "pytest" then
            return config["env"]
        end
    end
end

local dap = require("dap")

local dapui = require("dapui").setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
    require("dapui").open()
end

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
        args = {"--help"}
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
        cwd = "${workspaceFolder}"
        --   toolArgs = {"-d", "ios"}
    }
}

local dapvscode = require("dap.ext.vscode")
dapvscode.load_launchjs()

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")
lspconfig.pyright.setup {
    capabilities = capabilities
}
lspconfig.tsserver.setup {
    capabilities = capabilities
}
lspconfig.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {}
    },
    capabilities = capabilities
}

lspconfig.dartls.setup {
    filetypes = {"dart"},
    init_options = {
        closingLabels = true,
        flutterOutline = true,
        onlyAnalyzeProjectsWithOpenFiles = true,
        outline = true,
        suggestFromUnimportedLibraries = true
    },
    root_dir = lspconfig.util.root_pattern("pubspec.yaml", ".git"),
    capabilities = capabilities
}

vim.keymap.set("n", "<Space>", "<Nop>", {silent = true, remap = false})
vim.g.mapleader = " "

vim.api.nvim_set_keymap("n", "<leader>du", ':lua require("dapui").toggle()<CR>', {noremap = true, silent = true})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.api.nvim_set_keymap(
    "n",
    "<Leader>ff",
    ':lua require"telescope.builtin".find_files({ hidden = true, file_ignore_patterns = {".git"} })<CR>',
    {noremap = true, silent = true}
)
vim.api.nvim_set_keymap(
    "n",
    "<Leader>fg",
    ':lua require"telescope.builtin".live_grep({ hidden = true, file_ignore_patterns = {".git"} })<CR>',
    {noremap = true, silent = true}
)

-- DBUI mappings
vim.api.nvim_set_keymap("n", "<Leader>dbt", ":call db_ui#toggle()<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>dbf", ":call db_ui#find_buffer()<CR>", {})

-- Problems view
vim.keymap.set("n", "<Leader>xx", vim.cmd.lopen, {})

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd(
    "LspAttach",
    {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            local opts = {buffer = ev.buf}
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set(
                "n",
                "<space>wl",
                function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end,
                opts
            )
            vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set({"n", "v"}, "<space>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set(
                "n",
                "<space>f",
                function()
                    vim.lsp.buf.format {async = true}
                end,
                opts
            )
        end
    }
)

vim.keymap.set(
    "n",
    "<F5>",
    function()
        require("dap").continue()
    end
)
vim.keymap.set(
    "n",
    "<F10>",
    function()
        require("dap").step_over()
    end
)
vim.keymap.set(
    "n",
    "<F11>",
    function()
        require("dap").step_into()
    end
)
vim.keymap.set(
    "n",
    "<F12>",
    function()
        require("dap").step_out()
    end
)
vim.keymap.set(
    "n",
    "<F9>",
    function()
        require("dap").terminate()
    end
)
vim.keymap.set(
    "n",
    "<Leader>b",
    function()
        require("dap").toggle_breakpoint()
    end
)
vim.keymap.set(
    "n",
    "<Leader>B",
    function()
        require("dap").set_breakpoint()
    end
)
vim.keymap.set(
    "n",
    "<Leader>lp",
    function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end
)
vim.keymap.set(
    "n",
    "<Leader>dr",
    function()
        require("dap").repl.open()
    end
)
vim.keymap.set(
    "n",
    "<Leader>dl",
    function()
        require("dap").run_last()
    end
)
vim.keymap.set(
    {"n", "v"},
    "<Leader>dh",
    function()
        require("dap.ui.widgets").hover()
    end
)
vim.keymap.set(
    {"n", "v"},
    "<Leader>dp",
    function()
        require("dap.ui.widgets").preview()
    end
)
vim.keymap.set(
    "n",
    "<Leader>df",
    function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
    end
)
vim.keymap.set(
    "n",
    "<Leader>ds",
    function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
    end
)

vim.keymap.set(
    "n",
    "<leader>tf",
    function()
        require("neotest").run.run({vim.fn.expand("%"), strategy = "dap", env = pytest_env()})
    end
)

require "nvim-treesitter.configs".setup {
    ensure_installed = {"c", "lua", "vim", "vimdoc", "query", "python", "dart", "typescript"},
    sync_install = false,
    ignore_install = {"javascript"},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true
    },
    indent = {
        enable = true
    }
}

require("Comment").setup()

require "nvim-web-devicons".setup {
    override = {
        zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
        }
    },
    color_icons = true,
    default = true,
    strict = true,
    override_by_filename = {
        [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
        }
    },
    override_by_extension = {
        ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
        }
    }
}

require("neotest").setup(
    {
        adapters = {
            require("neotest-python")
        }
    }
)
-- Set up nvim-cmp.
local cmp = require "cmp"

cmp.setup(
    {
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            end
        },
        window = {},
        mapping = cmp.mapping.preset.insert(
            {
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }
        ),
        sources = cmp.config.sources(
            {
                {name = "nvim_lsp"},
                {name = "vsnip"} -- For vsnip users.
            },
            {
                {name = "buffer"}
            }
        )
    }
)

-- Set configuration for specific filetype.
cmp.setup.filetype(
    "gitcommit",
    {
        sources = cmp.config.sources(
            {
                {name = "git"} -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
            },
            {
                {name = "buffer"}
            }
        )
    }
)

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
    {"/", "?"},
    {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            {name = "buffer"}
        }
    }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
    ":",
    {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
            {
                {name = "path"}
            },
            {
                {name = "cmdline"}
            }
        )
    }
)
EOF
