-- Show relative line numbers
vim.opt.relativenumber = true

-- Default indentation if not overridden by TreeSitter
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Save yanks to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Auto save on text change
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.autocmd = {
    "TextChanged",
    ".*",
    "silent",
    "update"
}
vim.autocmd = {
    "InsertLeave",
    ".*",
    "silent",
    "update"
}

-- Remove trailing whitespace
vim.autocmd = {
    "BufWritePre",
    ".*",
    "silent",
    "g/\\s\\+$/s///e"
}
-- autocmd BufWritePre .* g/\s\+$/s///e
vim.autocmd = {
  "BufWritePost",
  ".*",
  "normal!",
  "`^"
}

vim.keymap.set("n", "<Space>", "<Nop>", {silent = true, remap = false})
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        {
            "LazyVim/LazyVim",
            opts = {
                colorscheme = "catppuccin"
            }
        },
        "windwp/nvim-autopairs",
        "nvim-lualine/lualine.nvim",
        "neomake/neomake",
        "machakann/vim-highlightedyank",
        {"catppuccin/nvim", as = "catppuccin"},
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python",
        "neovim/nvim-lspconfig",
        {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"},
        "voldikss/vim-floaterm",
        "github/copilot.vim",
        "dart-lang/dart-vim-plugin",
        "nvim-lua/plenary.nvim",
        {"nvim-telescope/telescope.nvim", branch = "0.1.x"},
        "numToStr/Comment.nvim",
        "nvim-tree/nvim-web-devicons",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest",
        "nvim-neotest/neotest-python",
        "preservim/nerdtree",
        "akinsho/git-conflict.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
        "mattboehm/vim-unstack",
        "rcarriga/nvim-dap-ui",
        "tpope/vim-dadbod",
        "kristijanhusak/vim-dadbod-ui",
        "kristijanhusak/vim-dadbod-completion",
        "folke/noice.nvim",
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
        "kmontocam/nvim-conda"
    }
)

-- Theme config - matches catppuccino-mocha
local colors = {
    blue = "#89b4fa",
    teal = "#94e2d5",
    base = "#1e1e2e",
    black = "#080808",
    white = "#cdd6f4",
    red = "#f38ba8",
    mauve = "#cba6f7",
    surface_zero = "#313244",
    peach = "#fab387",
    green = "#a6e3a1"
}

local catppuccin_theme = {
    normal = {
        a = {fg = colors.black, bg = colors.mauve},
        b = {fg = colors.white, bg = colors.surface_zero},
        c = {fg = colors.base, bg = colors.base}
    },
    insert = {a = {fg = colors.black, bg = colors.blue}},
    visual = {a = {fg = colors.black, bg = colors.teal}},
    replace = {a = {fg = colors.black, bg = colors.red}},
    terminal = {a = {fg = colors.black, bg = colors.peach}},
    command = {a = {fg = colors.black, bg = colors.green}},
    inactive = {
        a = {fg = colors.white, bg = colors.black},
        b = {fg = colors.white, bg = colors.black},
        c = {fg = colors.black, bg = colors.black}
    }
}

-- Noice config
require("noice").setup(
    {
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true
            }
        },
        -- you can enable a preset for easier configuration
        presets = {
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            lsp_doc_border = true -- add a border to hover docs and signature help
        }
    }
)

-- Lualine config
require("lualine").setup {
    options = {
        theme = catppuccin_theme,
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
        lualine_x = {
            {
                require("noice").api.status.command.get,
                cond = require("noice").api.status.command.has,
                color = {fg = colors.peach, bg = colors.base}
            }
        },
        lualine_y = {"filetype", "progress"},
        lualine_z = {
            {"location", separator = {right = ""}, left_padding = 2}
        }
    },
    tabline = {},
    extensions = {}
}

vim.opt.termguicolors = true

vim.notify = require("notify")

require("nvim-autopairs").setup {}

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

-- Conda
vim.keymap.set("n", "<Leader>cc", vim.cmd.CondaActivate, {})

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
    "<leader>nd",
    function()
        require("noice").cmd("dismiss")
    end
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
    ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "python",
        "dart",
        "typescript",
        "regex",
        "bash",
        "markdown",
        "markdown_inline"
    },
    sync_install = true,
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
