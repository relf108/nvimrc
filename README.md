# Neovim Config

Shared Neovim config. Plugin manager is [lazy.nvim](https://github.com/folke/lazy.nvim), theme is catppuccin-mocha, leader key is `Space`.

## Requirements

**Required:**

- Neovim 0.11+ (uses the `vim.lsp.config` / `vim.lsp.enable` API)
- A [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal (icons, DB UI)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for live grep)
- Python 3 with packages from `requirements.txt`:
  ```sh
  pip install -r requirements.txt   # neovim, debugpy, ruff, pyright
  ```
  Or with Nix: `nix develop` (drops you into a shell with everything set up).

**Optional — formatter binaries.** `<leader>f` uses these per filetype; without them the filetype just falls back to LSP formatting (or nothing). Install only what you need:

| Filetype       | Formatter(s)              |
| -------------- | ------------------------- |
| Python         | `black`, `isort`          |
| Lua            | `stylua`                  |
| SQL            | `sqlfluff`                |
| Markdown, YAML | `prettier`                |
| Bash           | `beautysh`                |
| TOML           | `taplo`                   |
| XML            | `xmlstarlet`              |
| Nix            | `nixpkgs-fmt`             |

**Optional env vars:**

- `WORK_DIR` — buffers under this path get the Python formatter override (default: `/tmp`)
- `CONDA_PREFIX` — respected when resolving the Python host

## Install

```sh
git clone <this-repo> ~/.config/nvim
nvim
```

First launch bootstraps lazy.nvim and installs all plugins automatically. LSP servers (`ruff`, `pyright`, `lua_ls`, `jsonls`, `marksman`) must be on your `$PATH` — they are installed separately, not via Mason.

## Default behaviour worth knowing

- **Auto-save**: files save on text change and when leaving insert mode.
- **Auto-read**: external changes reload automatically (checked on buffer enter / cursor hold).
- **Startup**: opening `nvim` with no file drops you into a fullscreen file picker (fzf-lua). `Esc` quits.
- **Yanks go to the system clipboard.**
- Relative line numbers, spellcheck (`en_au`), 2-space indentation.

## Keymaps

Leader = `Space`.

### Tabs

| Key  | Action          |
| ---- | --------------- |
| `tt` | New tab         |
| `td` | Close tab       |
| `tj` / `tk` | Prev / next tab (accepts a count, e.g. `3tk`) |
| `th` / `tl` | First / last tab |

### Navigation

| Key         | Action                    |
| ----------- | ------------------------- |
| `<leader>ff` | Find files               |
| `<leader>fg` | Live grep                |
| `<leader>r`  | Open `requests` dir in Oil |
| `<leader>a` | Add file to harpoon  |
| `<C-e>`     | Harpoon quick menu   |
| `<C-h>` / `<C-l>` | Prev / next harpooned file |

### LSP (active when a server attaches)

| Key         | Action              |
| ----------- | ------------------- |
| `gd` / `gD` | Definition / declaration |
| `gr`        | References          |
| `gi`        | Implementation      |
| `K`         | Hover docs          |
| `<C-k>`     | Signature help      |
| `<leader>rn` | Rename symbol      |
| `<leader>ca` | Code action (normal + visual) |
| `<leader>D`  | Type definition    |
| `<leader>dd` | Diagnostics to location list |
| `<leader>f`  | Format buffer      |

### Debugging (DAP — Python, Dart, Lua)

| Key         | Action              |
| ----------- | ------------------- |
| `<F5>`      | Continue / start    |
| `<F9>`      | Terminate           |
| `<F10>` / `<F11>` / `<F12>` | Step over / into / out |
| `<leader>b` / `<leader>B` | Toggle / set breakpoint |
| `<leader>lp` | Log point          |
| `<leader>du` | Toggle DAP UI      |
| `<leader>dr` / `<leader>dl` | REPL / run last |
| `<leader>dh` / `<leader>dp` | Hover / preview value (normal + visual) |
| `<leader>df` / `<leader>ds` | Frames / scopes float |
| `<leader>vs` | Open `.vscode/launch.json` |

### Terminal (floaterm)

| Key       | Action            |
| --------- | ----------------- |
| `<C-t>`   | Toggle terminal   |
| `<C-S-n>` | New terminal      |
| `<C-S-d>` | Kill terminal     |
| `<C-S-j>` / `<C-S-k>` | Prev / next terminal |
| `<C-S-h>` / `<C-S-l>` | First / last terminal |

### Git

| Key          | Action            |
| ------------ | ----------------- |
| `<leader>gb` | Toggle git blame  |
| `<leader>dv` / `<leader>dc` | Open / close diffview |

### Misc

| Key         | Action                          |
| ----------- | ------------------------------- |
| `gc` / `gb` (normal/visual) | Comment toggle line / block |
| `<leader>s` | nvim-unstack (open stacktrace lines in qf-list)   |
| `<leader>dbt` / `<leader>dbf` | Toggle DB UI / find DB buffer |
| `<leader>nd` | Dismiss notifications (noice)  |
| `<leader>sn` | Restore line numbers           |

### Completion (blink.cmp, default preset)

`C-y` accept, `C-Space` open menu/docs, `C-n`/`C-p` navigate, `C-e` hide, `C-k` signature help.

## Layout

```
init.lua                 -- options, autocmds, core keymaps, lazy.nvim bootstrap
lua/
  plugins/               -- one file per plugin (lazy.nvim specs)
  lsp/                   -- per-language LSP setup
  dap/                   -- per-language debug adapters
  formatting/            -- per-filetype formatter definitions
  config/theme.lua       -- colours + lualine theme
  utils.lua              -- shared helpers
```

## Adding or changing formatters

Formatters live in `lua/formatting/` — one module per filetype. Each returns a function that builds a list of `plenary.job`s run in sequence against the saved file. Example (`lua/formatting/lua.lua`):

```lua
local job = require("plenary.job")
local on_exit = require("formatting.utils.format_exit")

return function()
	return {
		job:new({
			command = "stylua",
			args = { vim.g.formatting_buf_name }, -- absolute path of current buffer
			on_exit = on_exit,
		}),
	}
end
```

**Add a new filetype:**

1. Create `lua/formatting/<filetype>.lua` following the pattern above.
2. Register it in the `format_overrides` table in `lua/formatting/utils/format.lua`, keyed by the buffer's `filetype`.

**Swap the backend for an existing formatter:** edit the `command`/`args` in that filetype's module — e.g. replace `stylua` with `luaformatter` in `lua/formatting/lua.lua`. No other changes needed.

Filetypes without an entry in `format_overrides` fall back to `vim.lsp.buf.format`.
