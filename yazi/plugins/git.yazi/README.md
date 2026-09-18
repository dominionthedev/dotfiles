# git.yazi

A [Yazi](https://github.com/sxyazi/yazi) plugin to show Git file status as linemode.

Fork of [masaki39/git.yazi](https://github.com/masaki39/git.yazi) (itself a fork of
[yazi-rs/plugins:git](https://github.com/yazi-rs/plugins)) — kept alive after the
upstream fork was archived (archived repos disable issues and PRs, so there was
nowhere left to send this upstream).

## What's different from masaki39/git.yazi

- **Fixed for yazi's current `Fetcher` contract.** `fetch()` now returns a
  coroutine continuation (`noop`/`retry`) instead of a plain boolean, matching
  `yazi-rs/plugins:git@58c4f4e`. Without this, current yazi builds fail with
  `error converting Lua boolean to function`.
- **Ahead/behind count.** Shows `↑2 ↓1` on a repo's root directory entry when
  it has an upstream tracking branch that's diverged.
- **Stash indicator.** Shows `≡N` on a repo's root directory entry when
  `git stash list` is non-empty.
- **`types.lua` updated** to match — the `UnstableFetcher` alias no longer
  claims `fetch()` returns `boolean, Error?` (it doesn't, anymore), and the new
  state fields are typed.

Everything from the original fork — staged/mixed color logic, the `CODES`
table, the sign/style theming pattern — is untouched.

## Installation

```sh
ya pkg add dominionthedev/git
```

## Setup

`~/.config/yazi/init.lua`:

```lua
require("git"):setup()
-- or, to change the ahead/behind+stash refresh interval (default 2 seconds):
-- require("git"):setup({ tracking_debounce = 5 })
```

`~/.config/yazi/yazi.toml`:

```toml
[[plugin.prepend_fetchers]]
url   = "*"
run   = "git"
group = "git"

[[plugin.prepend_fetchers]]
url   = "*/"
run   = "git"
group = "git"
```

(That `group` field is required by current yazi and isn't mentioned in the
original fork's docs — without it you'll get a TOML parse error on startup.)

## Status Signs

| Sign | Color     | Meaning                                               |
| ---- | --------- | ----------------------------------------------------- |
| `M`  | green     | Modified (staged only)                                |
| `M`  | red       | Modified (unstaged only)                              |
| `MM` | green+red | Modified (staged left, unstaged right)                |
| `A`  | green     | Added (staged)                                        |
| `AM` | green+red | Added and then modified (staged left, unstaged right) |
| `??` | red       | Untracked                                             |
| `!`  | blue      | Ignored                                               |
| `D`  | red       | Deleted                                               |
| `U`  | yellow    | Conflict                                              |
| `↑N` | green     | N commits ahead of upstream (repo root only)          |
| `↓N` | red       | N commits behind upstream (repo root only)            |
| `≡N` | yellow    | N stashes (repo root only)                            |

## Theming

Set any of these under `[git]` in `~/.config/yazi/theme.toml` to override the
defaults — all are optional:

```toml
[git]
# per-status colors (ui.Style values) and signs (strings), same as upstream:
unknown = ...     unknown_sign = ...
ignored = ...     ignored_sign = "!"
untracked = ...   untracked_sign = "??"
modified = ...    modified_sign = "M"
staged = ...      staged_sign = "M"
added = ...       added_sign = "A"
deleted = ...     deleted_sign = "D"
updated = ...     updated_sign = "U"
clean = ...       clean_sign = ""

# new in this fork — ahead/behind/stash colors and signs:
ahead = ...        ahead_sign = "↑"
behind = ...       behind_sign = "↓"
stash = ...        stash_sign = "≡"
```

## Why this fork exists

`masaki39/git.yazi` was archived by its owner. Since yazi's plugin API has no
stability guarantee (the official plugin gallery says as much), a plugin with
no maintainer eventually breaks against a moving target. This fork exists to
keep taking that hit so you don't have to re-diagnose it every yazi upgrade.

If yazi's `Fetcher` contract changes again, the fix is almost always in
`fetch()` and `setup()` — diff those two functions against
[upstream `yazi-rs/plugins:git`](https://github.com/yazi-rs/plugins/tree/main/git.yazi)
first; that's the surface area that actually moves.

## License

MIT — see [LICENSE](LICENSE). Carries forward the copyright chain from
yazi-rs and masaki39.
