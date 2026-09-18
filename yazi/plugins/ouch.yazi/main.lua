-- Compress/decompress via `ouch`, bound to keys instead of buried in the
-- "open with" opener menu.
--
--   C  -> compress selection (or hovered file/folder) into an archive
--   U  -> decompress selection (or hovered archive)
--
-- Both work on your current selection (space to multi-select), and both use
-- your CURRENT directory as the default destination — so "select stuff, cd
-- somewhere else, press the key" lands the archive/extracted files wherever
-- you navigated to, exactly as asked. The destination prompt is editable if
-- you want somewhere else instead.
--
-- Bind in keymap.toml:
--   { on = "C", run = "plugin ouch compress",   desc = "Compress selection (via ouch)" },
--   { on = "U", run = "plugin ouch decompress", desc = "Decompress selection (via ouch)" },

local FORMATS = {
	{ on = "z", ext = "zip", desc = "zip (.zip)" },
	{ on = "t", ext = "tar.gz", desc = "tar.gz (.tar.gz)" },
	{ on = "b", ext = "tar.bz2", desc = "tar.bz2 (.tar.bz2)" },
	{ on = "x", ext = "tar.xz", desc = "tar.xz (.tar.xz)" },
	{ on = "s", ext = "tar.zst", desc = "tar.zst (.tar.zst)" },
	{ on = "7", ext = "7z", desc = "7z (.7z)" },
}

-- State access has to go through ya.sync — `entry` itself runs off the main
-- thread so it can await ya.input()/Command() without blocking the UI.
local selected_or_hovered = ya.sync(function()
	local tab, urls = cx.active, {}
	for _, f in pairs(tab.selected) do
		urls[#urls + 1] = f.url
	end
	if #urls == 0 and tab.current.hovered then
		urls[1] = tab.current.hovered.url
	end
	return urls
end)

local cwd = ya.sync(function() return tostring(cx.active.current.cwd) end)

local function notify(content, level)
	ya.notify({ title = "ouch", content = content, level = level or "info", timeout = 5 })
end

---@param dir string
---@return boolean
local function ensure_dir(dir)
	local url = Url(dir)
	local cha = fs.cha(url)
	if cha then
		return cha.is_dir
	end
	local ok, err = fs.create("dir_all", url)
	if not ok then
		notify("Couldn't create " .. dir .. ": " .. tostring(err), "error")
		return false
	end
	return true
end

---@param title string
---@param default string
---@return string?
local function ask_dir(title, default)
	local value, event = ya.input({
		title = title,
		value = default,
		pos = { "top-center", y = 3, w = 60 },
	})
	if event ~= 1 or not value or value == "" then
		return nil
	end
	return (value:gsub("/+$", "")) -- drop a trailing slash if they left one
end

local function compress()
	ya.emit("escape", { visual = true })

	local urls = selected_or_hovered()
	if #urls == 0 then
		return notify("Nothing selected to compress", "warn")
	end

	local cands = {}
	for _, f in ipairs(FORMATS) do
		cands[#cands + 1] = { on = f.on, desc = f.desc }
	end
	local idx = ya.which({ cands = cands })
	if not idx then
		return -- cancelled
	end
	local format = FORMATS[idx]

	local dir = cwd()
	local default_name
	if #urls == 1 then
		default_name = (urls[1].name or "archive") .. "." .. format.ext
	else
		default_name = (dir:match("([^/]+)/?$") or "archive") .. "." .. format.ext
	end

	local dest_dir = ask_dir("Compress to folder:", dir)
	if not dest_dir then
		return -- cancelled
	end
	if not ensure_dir(dest_dir) then
		return
	end

	local archive_path = dest_dir .. "/" .. default_name
	local paths = {}
	for _, u in ipairs(urls) do
		paths[#paths + 1] = tostring(u)
	end

	local output, err = Command("ouch"):arg({ "compress" }):arg(paths):arg({ archive_path, "-y" }):output()

	if not output then
		notify("Failed to run ouch: " .. tostring(err), "error")
	elseif output.status.success then
		notify("Created " .. archive_path)
	else
		notify("Compress failed:\n" .. output.stderr, "error")
	end
end

local function decompress()
	ya.emit("escape", { visual = true })

	local urls = selected_or_hovered()
	if #urls == 0 then
		return notify("No archive selected", "warn")
	end

	local dest_dir = ask_dir("Extract to folder:", cwd())
	if not dest_dir then
		return -- cancelled
	end
	if not ensure_dir(dest_dir) then
		return
	end

	local paths = {}
	for _, u in ipairs(urls) do
		paths[#paths + 1] = tostring(u)
	end

	local output, err = Command("ouch"):arg({ "decompress" }):arg(paths):arg({ "-d", dest_dir, "-y" }):output()

	if not output then
		notify("Failed to run ouch: " .. tostring(err), "error")
	elseif output.status.success then
		notify("Extracted to " .. dest_dir)
	else
		notify("Decompress failed:\n" .. output.stderr, "error")
	end
end

return {
	entry = function(_, job)
		local action = job.args and job.args[1]
		if action == "compress" then
			compress()
		elseif action == "decompress" then
			decompress()
		else
			notify("usage: plugin ouch compress|decompress", "warn")
		end
	end,
}
