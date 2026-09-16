function Linemode:size_human()
    local size = self._file:size()
    return size and ya.readable_size(size) or "-"
end
