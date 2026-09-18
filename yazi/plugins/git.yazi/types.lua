---@class State
---@field dirs table<string, string|CODES> Mapping between a directory and its corresponding repository
---@field repos table<string, Changes> Mapping between a repository and the status of each of its files
---@field tracking table<string, { ahead: number, behind: number }> Ahead/behind counts vs upstream, keyed by repo root
---@field stashes table<string, number> Stash count, keyed by repo root
---@field tracked_at table<string, number> os.clock() of the last ahead/behind+stash refresh, keyed by repo root
---@field tracking_debounce number Minimum seconds between ahead/behind+stash refreshes for the same repo

---@class Options
---@field order number The order in which the status is displayed
---@field renamed boolean Whether to include renamed files in the status (or treat them as modified)
---@field tracking_debounce number Minimum seconds between ahead/behind+stash refreshes for the same repo (default 2)

-- TODO: move this to `types.yazi` once it's get stable
---@alias UnstableFetcher fun(self: unknown, job: { files: File[] })

---@alias Changes table<string, CODES>
