function Linemode:size_human()
  local size = self._file:size()
  return size and ya.readable_size(size) or "-"
end

-- Inline git status per file (M/A/??/etc). Install first:
--   ya pkg add masaki39/git
-- (a fork of the official yazi-rs/plugins:git with clearer staged/unstaged
-- coloring — also needs the fetchers added to yazi.toml, see below)
require("git"):setup()
