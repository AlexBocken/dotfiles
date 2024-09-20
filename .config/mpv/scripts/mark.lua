-- mpv script to mark videos
local utils = require 'mp.utils'
local marked_videos = {}
local marked_file = "marked"

function toggle_mark()
    local path = mp.get_property("path")
    if marked_videos[path] then
        marked_videos[path] = nil
        mp.osd_message("Unmarked: " .. path)
    else
        marked_videos[path] = true
        mp.osd_message("Marked: " .. path)
    end
end

function save_marks()
    -- Do not write anything if "marked_videos" is empty
    if next(marked_videos) == nil then
	return
    end
    local file = io.open(marked_file, "a")
    for path, _ in pairs(marked_videos) do
        file:write(path .. "\n")
    end
    file:close()
end

mp.add_key_binding("M", "toggle_mark", toggle_mark)
mp.register_event("shutdown", save_marks)
