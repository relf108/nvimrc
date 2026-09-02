# Neovim Config

Shared Neovim config. Plugins are installed and loaded by native [`vim.pack`](https://neovim.io/doc/user/pack.html#vim.pack). Theme is catppuccin-mocha; leader key is `Space`.

## Requirements

**Required:**

- Neovim 0.12+ (uses `vim.pack` and the `vim.lsp.config` / `vim.lsp.enable` API)
- A [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal (icons, DB UI)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for live grep)
- Python 3 with packages from `requirements.txt`:
  ```sh
  pip install -r requirements.txt   # neovim, debugpy, ruff, ty
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

First launch installs the revisions in `nvim-pack-lock.json` automatically. LSP servers (`ruff`, `ty`, `lua_ls`, `jsonls`, `marksman`) must be on your `$PATH` — they are installed separately, not via Mason.

Use `:lua vim.pack.update()` to review plugin updates. Write the generated buffer to apply them, then commit the updated lockfile.

### Plugin loading differences

- Files under `plugin/` are native runtime files sourced automatically by Neovim. Each file owns its `vim.pack.add()` call, setup, mappings, and lazy-loading events.
- Startup-critical plugins load immediately. Event-driven plugins register with `load = function() end` and load later through one-shot autocommands or explicit mappings.
- Shared Lua and runtime dependencies load with `:packadd!` semantics in `plugin/00-dependencies.lua`; their plugin scripts are not executed.
- `lua/plugin_loader.lua` makes `:packadd` plus setup idempotent. It does not implement plugin discovery, dependency resolution, or trigger replay.
- Native `CmdUndefined` autocommands preserve direct commands for command-driven plugins.
- `vim.pack` has no UI, profiler, background update checker, or automatic build hooks. Use its Lua API for package operations.

### Adding a plugin

Create one runtime file under `plugin/`. Neovim discovers and sources it automatically:

```lua
vim.pack.add({ "https://github.com/owner/plugin.nvim" }, { confirm = false, load = true })
require("plugin").setup({})
```

For event-based lazy loading, register without loading and use the shared loader once needed:

```lua
local loader = require("plugin_loader")

vim.pack.add({ "https://github.com/owner/plugin.nvim" }, {
	confirm = false,
	load = function() end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		loader.load("plugin.nvim", function()
			require("plugin").setup({})
		end)
	end,
})
```

Use `name` when the package name differs from the repository name, and `version` for a branch, tag, commit, or `vim.VersionRange`. Add shared Lua/runtime-only dependencies to `plugin/00-dependencies.lua`.

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
init.lua                 -- options, autocmds, core keymaps
lua/
  plugin_loader.lua      -- idempotent native packadd + setup helper
  lsp/                   -- per-language LSP setup
  dap/                   -- per-language debug adapters
  formatting/            -- per-filetype formatter definitions
  config/theme.lua       -- colours + lualine theme
  utils.lua              -- shared helpers
plugin/                  -- native runtime files, one per plugin or feature
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
