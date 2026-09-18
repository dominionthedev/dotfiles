--- @since 26.1.22
-- Fork of yazi-rs/plugins:git with staged/mixed state support
--
-- PATCHED: yazi's Fetcher contract changed between this fork's target version
-- (26.1.22) and whatever build you're running now — `fetch()` used to return
-- a plain boolean, it now must return a coroutine/continuation (`noop` or
-- `retry`), matching upstream yazi-rs/plugins:git@58c4f4e. That mismatch is
-- exactly what "error converting Lua boolean to function" was — Rust trying
-- to convert the boolean this fork returned into the function it now expects.
-- Everything else (the staged/mixed color logic, CODES table) is untouched.

local WINDOWS = ya.target_family() == "windows"

-- The code of supported git status,
-- also used to determine which status to show for directories when they contain different statuses
-- see `bubble_up`
---@enum CODES
local CODES = {
	unknown = 1000, -- status cannot/not yet determined
	excluded = 990, -- ignored directory
	ignored = 70,   -- ignored file
	untracked = 60,
	modified = 50,      -- unstaged modification (working tree)
	mixed = 45,         -- staged M/T + unstaged M/T both present (MM, MT, etc.)
	staged = 40,        -- staged only (index M or T, no working tree change)
	added = 30,
	added_mixed = 35,   -- staged A/C + unstaged M/T (AM, etc.)
	deleted = 20,
	updated = 10,   -- merge conflict (U, DD, AD, etc.)
	clean = 0,
}

local PATTERNS = {
	{ "!$", CODES.ignored },
	{ "?$", CODES.untracked },
	{ "^[MT][MT]", CODES.mixed },       -- both chars M or T = staged + unstaged
	{ "^[AC][MT]", CODES.added_mixed }, -- staged A/C + unstaged M/T (e.g. AM)
	{ "^[MT]", CODES.staged },          -- first char M or T = staged only
	{ "[MT]", CODES.modified },         -- second char M or T = unstaged only
	{ "[AC]", CODES.added },
	{ "D", CODES.deleted },
	{ "U", CODES.updated },
	{ "[AD][AD]", CODES.updated },
}

---@param line string
---@return CODES, string
local function match(line)
	local signs = line:sub(1, 2)
	for _, p in ipairs(PATTERNS) do
		local path, pattern, code = nil, p[1], p[2]
		if signs:find(pattern) then
			path = line:sub(4, 4) == '"' and line:sub(5, -2) or line:sub(4)
			path = WINDOWS and path:gsub("/", "\\") or path
		end
		if not path then
		elseif path:find("[/\\]$") then
			-- Mark the ignored directory as `excluded`, so we can process it further within `propagate_down`
			return code == CODES.ignored and CODES.excluded or code, path:sub(1, -2)
		else
			return code, path
		end
		---@diagnostic disable-next-line: missing-return
	end
end

---@param cwd Url
---@return string?
local function root(cwd)
	local is_worktree = function(url)
		local file, head = io.open(tostring(url)), nil
		if file then
			head = file:read(8)
			file:close()
		end
		return head == "gitdir: "
	end

	repeat
		local next = cwd:join(".git")
		local cha = fs.cha(next)
		if cha and (cha.is_dir or is_worktree(next)) then
			return tostring(cwd)
		end
		cwd = cwd.parent
	until not cwd
end

---@type UnstableFetcher
local function retry(job)
	return ya.co(function()
		for _, file in ipairs(job.files) do
			coroutine.yield(file, { retry = true })
		end
	end)
end

---@param changed Changes
---@return Changes
local function bubble_up(changed)
	local new, empty = {}, Url("")
	for path, code in pairs(changed) do
		if code ~= CODES.ignored then
			local url = Url(path).parent
			while url and url ~= empty do
				local s = tostring(url)
				new[s] = (new[s] or CODES.clean) > code and new[s] or code
				url = url.parent
			end
		end
	end
	return new
end

---@param excluded string[]
---@param cwd Url
---@param repo Url
---@return Changes
local function propagate_down(excluded, cwd, repo)
	local new, rel = {}, cwd:strip_prefix(repo)
	for _, path in ipairs(excluded) do
		if rel:starts_with(path) then
			-- If `cwd` is a subdirectory of an excluded directory, also mark it as `excluded`
			new[tostring(cwd)] = CODES.excluded
		elseif cwd == repo:join(path).parent then
			-- If `path` is a direct subdirectory of `cwd`, mark it as `ignored`
			new[path] = CODES.ignored
		else
			-- Skipping, we only care about `cwd` itself and its direct subdirectories for maximum performance
		end
	end
	return new
end

---@param cwd string
---@param repo string
---@param changed Changes
local add = ya.sync(function(st, cwd, repo, changed)
	---@cast st State

	st.dirs[cwd] = repo
	st.repos[repo] = st.repos[repo] or {}
	for path, code in pairs(changed) do
		if code == CODES.clean then
			st.repos[repo][path] = nil
		elseif code == CODES.excluded then
			-- Mark the directory with a special value `excluded` so that it can be distinguished during UI rendering
			st.dirs[path] = CODES.excluded
		else
			st.repos[repo][path] = code
		end
	end
	ui.render()
end)

---@param cwd string
local remove = ya.sync(function(st, cwd)
	---@cast st State

	local repo = st.dirs[cwd]
	if not repo then
		return
	end

	ui.render()
	st.dirs[cwd] = nil
	if not st.repos[repo] then
		return
	end

	for _, r in pairs(st.dirs) do
		if r == repo then
			return
		end
	end
	st.repos[repo] = nil
end)

---@param repo string
---@return boolean should run the (expensive) ahead/behind + stash git calls for this repo right now
local should_track = ya.sync(function(st, repo)
	---@cast st State

	local now = os.clock()
	if st.tracked_at[repo] and (now - st.tracked_at[repo]) < st.tracking_debounce then
		return false
	end
	st.tracked_at[repo] = now
	return true
end)

---@param repo string
---@param ahead number
---@param behind number
local set_tracking = ya.sync(function(st, repo, ahead, behind)
	---@cast st State
	st.tracking[repo] = { ahead = ahead, behind = behind }
	ui.render()
end)

---@param repo string
---@param count number
local set_stash = ya.sync(function(st, repo, count)
	---@cast st State
	st.stashes[repo] = count
	ui.render()
end)

---@param st State
---@param opts Options
local function setup(st, opts)
	st.dirs = {}
	st.repos = {}
	st.tracking = {} -- repo -> { ahead = n, behind = n }
	st.stashes = {} -- repo -> stash count
	st.tracked_at = {} -- repo -> os.clock() of last ahead/behind+stash refresh

	opts = opts or {}
	opts.order = opts.order or 1500
	st.tracking_debounce = opts.tracking_debounce or 2 -- seconds between ahead/behind+stash refreshes per repo

	local t = th.git or {}
	local styles = {
		[CODES.unknown] = t.unknown or ui.Style(),
		[CODES.ignored] = t.ignored or ui.Style():fg("blue"),
		[CODES.untracked] = t.untracked or ui.Style():fg("red"),
		[CODES.modified] = t.modified or ui.Style():fg("red"),
		[CODES.staged] = t.staged or ui.Style():fg("green"),
		[CODES.added] = t.added or ui.Style():fg("green"),
		[CODES.deleted] = t.deleted or ui.Style():fg("red"),
		[CODES.updated] = t.updated or ui.Style():fg("yellow"),
		[CODES.clean] = t.clean or ui.Style(),
	}
	local signs = {
		[CODES.unknown] = t.unknown_sign or "",
		[CODES.ignored] = t.ignored_sign or "!",
		[CODES.untracked] = t.untracked_sign or "??",
		[CODES.modified] = t.modified_sign or "M",
		[CODES.staged] = t.staged_sign or "M",
		[CODES.added] = t.added_sign or "A",
		[CODES.deleted] = t.deleted_sign or "D",
		[CODES.updated] = t.updated_sign or "U",
		[CODES.clean] = t.clean_sign or "",
	}
	local ahead_style = t.ahead or ui.Style():fg("green")
	local behind_style = t.behind or ui.Style():fg("red")
	local stash_style = t.stash or ui.Style():fg("yellow")
	local ahead_sign = t.ahead_sign or "↑"
	local behind_sign = t.behind_sign or "↓"
	local stash_sign = t.stash_sign or "≡"

	Linemode:children_add(function(self)
		if not self._file.in_current then
			return ""
		end

		local url = self._file.url
		local path = tostring(url)
		local repo = st.dirs[tostring(url.base or url.parent)]
		local code = CODES.unknown
		if repo then
			code = repo == CODES.excluded and CODES.ignored or st.repos[repo][path:sub(#repo + 2)] or CODES.clean
		end

		local base
		if signs[code] == "" then
			base = nil
		elseif self._file.is_hovered then
			if code == CODES.mixed then
				base = ui.Line { " ", signs[CODES.staged], signs[CODES.modified] }
			elseif code == CODES.added_mixed then
				base = ui.Line { " ", signs[CODES.added], signs[CODES.modified] }
			else
				base = signs[code] and ui.Line { " ", signs[code] } or nil
			end
		else
			if code == CODES.mixed then
				base = ui.Line {
					" ",
					ui.Span(signs[CODES.staged]):style(styles[CODES.staged]),
					ui.Span(signs[CODES.modified]):style(styles[CODES.modified]),
				}
			elseif code == CODES.added_mixed then
				base = ui.Line {
					" ",
					ui.Span(signs[CODES.added]):style(styles[CODES.added]),
					ui.Span(signs[CODES.modified]):style(styles[CODES.modified]),
				}
			else
				base = signs[code] and ui.Line { " ", ui.Span(signs[code]):style(styles[code]) } or nil
			end
		end

		-- Repo-root extras (ahead/behind, stash count) — keyed off the file's
		-- OWN path being a known repo root, independent of the per-file status
		-- lookup above, so this shows even on a `clean` repo root.
		local track = st.tracking[path]
		local stash = st.stashes[path]
		local extras = {}
		if track and track.ahead > 0 then
			extras[#extras + 1] = ui.Span(" " .. ahead_sign .. track.ahead):style(ahead_style)
		end
		if track and track.behind > 0 then
			extras[#extras + 1] = ui.Span(" " .. behind_sign .. track.behind):style(behind_style)
		end
		if stash and stash > 0 then
			extras[#extras + 1] = ui.Span(" " .. stash_sign .. stash):style(stash_style)
		end

		if #extras == 0 then
			return base or ""
		end

		local parts = base and { base } or {}
		for _, e in ipairs(extras) do
			parts[#parts + 1] = e
		end
		return ui.Line(parts)
	end, opts.order)
end

---@type UnstableFetcher
local function fetch(_, job)
	local cwd = job.files[1].url.base or job.files[1].url.parent
	local repo = root(cwd)
	if not repo then
		remove(tostring(cwd))
		return require("noop"):fetch(job)
	end

	local paths = {}
	for _, file in ipairs(job.files) do
		paths[#paths + 1] = tostring(file.url)
	end

	-- stylua: ignore
	local output, err = Command("git")
		:cwd(tostring(cwd))
		:arg({ "--no-optional-locks", "-c", "core.quotePath=", "status", "--porcelain", "-unormal", "--no-renames", "--ignored=matching" })
		:arg(paths)
		:output()
	if not output then
		ya.err("Cannot spawn `git` command, error: " .. err)
		return require("noop"):fetch(job)
	end

	local changed, excluded = {}, {}
	for line in output.stdout:gmatch("[^\r\n]+") do
		local code, path = match(line)
		if code == CODES.excluded then
			excluded[#excluded + 1] = path
		else
			changed[path] = code
		end
	end

	if job.files[1].cha.is_dir then
		ya.dict_merge(changed, bubble_up(changed))
	end
	ya.dict_merge(changed, propagate_down(excluded, cwd, Url(repo)))

	-- Reset the status of any files that don't appear in the output of `git status` to `clean`,
	-- so that cleaning up outdated statuses from `st.repos`
	for _, path in ipairs(paths) do
		local s = path:sub(#repo + 2)
		changed[s] = changed[s] or CODES.clean
	end

	add(tostring(cwd), repo, changed)

	-- Ahead/behind vs upstream + stash count. Repo-wide (not per-file), so it's
	-- wasteful to recompute on every fetch tick — gated by st.tracking_debounce
	-- (default 2s/repo) so rapid navigation doesn't spam two extra git spawns
	-- per tick. This does NOT gate the file-status fetch above; that stays as
	-- responsive as core's own scheduling makes it.
	if should_track(repo) then
		local track_output = Command("git")
			:cwd(repo)
			:arg({ "rev-list", "--left-right", "--count", "@{upstream}...HEAD" })
			:output()
		local ahead, behind = 0, 0
		if track_output and track_output.stdout then
			local b, a = track_output.stdout:match("(%d+)%s+(%d+)")
			ahead, behind = tonumber(a) or 0, tonumber(b) or 0
		end
		set_tracking(repo, ahead, behind)

		local stash_output = Command("git"):cwd(repo):arg({ "stash", "list" }):output()
		local stash_count = 0
		if stash_output and stash_output.stdout then
			for _ in stash_output.stdout:gmatch("[^\r\n]+") do
				stash_count = stash_count + 1
			end
		end
		set_stash(repo, stash_count)
	end

	return retry(job)
end

return { setup = setup, fetch = fetch }
