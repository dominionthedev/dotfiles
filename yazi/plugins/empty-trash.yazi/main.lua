-- Empties the system trash via `trash -ey`, gated behind a y/n prompt.
-- This is deliberately NOT a bare keypress: unlike `D` (permanently delete
-- selection), this isn't scoped to whatever you've selected — it's global
-- and irreversible, so it gets its own "are you sure".
return {
  entry = function()
    local idx = ya.which({
      cands = {
        { on = "y", desc = "Yes — permanently empty the trash" },
        { on = "n", desc = "No — cancel" },
      },
    })
    if idx ~= 1 then
      return -- cancelled: Esc, "n", or anything else
    end

    -- Feedback before the (possibly slow) command runs, so a big trash
    -- can doesn't look like a second hang.
    ya.notify({ title = "trash", content = "Emptying trash…", level = "info", timeout = 2 })

    local output, err = Command("trash"):arg({ "-ey" }):output()
    if not output then
      ya.notify({ title = "trash", content = "Failed to run trash: " .. tostring(err), level = "error", timeout = 5 })
    elseif output.status.success then
      ya.notify({ title = "trash", content = "Trash emptied", level = "info", timeout = 3 })
    else
      ya.notify({ title = "trash", content = "trash -ey failed:\n" .. output.stderr, level = "error", timeout = 5 })
    end
  end,
}
