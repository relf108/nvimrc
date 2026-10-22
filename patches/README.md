# Local FZF-lua scheduler patch

`fzf-lua-cooperative-streaming.patch` adds cooperative single-process formatting
to FZF-lua revision `a306c293b37bd7c8c1e8e1e6c0d7d3d9c3de3f21`.

The formatter yields between roughly 4 ms batches. A bounded producer queue
applies backpressure, and closing or reloading the picker cancels queued work.
Icons, previews, actions, and resume still use FZF-lua's existing implementation.
There are no project-size thresholds.

The patch is applied to the local plugin checkout, not published or pinned to a
fork. Its changes are unstaged in that separate Git repository. The config only
enables single-process file picking when the provider advertises the patched
`cooperative_streaming` capability. Without it, FZF-lua uses its normal worker.

## Reapply after a clean installation

```sh
plugin_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/core/opt/fzf-lua"
patch_file="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/patches/fzf-lua-cooperative-streaming.patch"
git -C "$plugin_dir" apply --check "$patch_file"
git -C "$plugin_dir" apply "$patch_file"
```

If the check fails, inspect the plugin revision and local edits rather than
forcing the patch. Package updates may require reconciling this local patch;
the capability guard safely retains worker mode on an unpatched installation.
Nothing reapplies the patch automatically at startup.

## Tests and limits

Ten new stream tests cover ordering, timer fairness, bounded buffering,
cancellation, broken pipes, partial lines, NUL delimiters, and UTF-8. The existing
libuv and shell suites also pass on macOS / Neovim 0.12.6 (Windows-only cases
were skipped). Linux and Windows validation is still pending.

With FZF-lua's test dependencies installed, run from the plugin checkout:

```sh
make test glob=stream
make test glob=libuv
make test glob=shell
```

Measured prototype startup latency was 277 ms versus 239 ms (eight alternating
warm-start comparisons). A synthetic 200,000-entry stream kept the editor's worst
heartbeat gap around 15 ms. A cooperative budget cannot preempt a single blocking
user-defined formatter.
