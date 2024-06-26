-- Define the time window for keypresses
local time_window = 2 -- seconds

-- Variables to keep track of 'y' keypress and the timer
local y_pressed = false
local y_timer = nil

-- Function to reset the 'y' keypress state
local function reset_y()
    y_pressed = false
    if y_timer then
        mp.cancel_timer(y_timer)
        y_timer = nil
    end
end

-- Function to handle 'y' keypress
local function handle_y()
    reset_y()
    y_pressed = true
    -- Start a timer to reset the state after 2 seconds
    y_timer = mp.add_timeout(time_window, reset_y)
end

-- Function to handle 'n' keypress
-- Copy the filename to clipboard
local function handle_n()
    if y_pressed then
        local filename = mp.get_property("filename")
        -- Use a method to copy 'filename' to clipboard (platform-specific)
        -- For example, on Unix-like systems, you might use 'xclip'
        os.execute("printf %s" .. filename .. " | xclip -selection clipboard")
        mp.osd_message("Copied filename " .. filename .. " to clipboard", 3)
        reset_y() -- Reset the 'y' keypress state
    end
end

-- Bind the keys to their respective functions

-- Function to handle 'd' keypress
-- Copy the directory to clipboard
local function handle_d()
    if y_pressed then
        local filepath = mp.get_property("path")
        local directory = string.match(filepath, "(.*/)")
        os.execute("printf %s" .. directory .. " | xclip -selection clipboard")
        mp.osd_message("Copied directory " .. directory .. " to clipboard", 3)
        reset_y()
    end
end

-- Function to handle 'p' keypress
local function handle_p()
    if y_pressed then
        local full_path = mp.get_property("path")
        os.execute("printf %s " .. full_path .. " | xclip -selection clipboard")
        mp.osd_message("Copied full path " .. full_path .. " to clipboard", 3)
        reset_y()
    end
end

mp.add_key_binding("y", "check_y", handle_y)
mp.add_key_binding("n", "check_n", handle_n)
mp.add_key_binding("p", "check_p", handle_p)
mp.add_key_binding("d", "check_d", handle_d)
