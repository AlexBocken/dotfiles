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
local function handle_n()
    if y_pressed then
        -- Copy the filename to clipboard
        local filename = mp.get_property("filename")
        -- Use a method to copy 'filename' to clipboard (platform-specific)
        -- For example, on Unix-like systems, you might use 'xclip'
        os.execute("echo " .. filename .. " | xclip -selection clipboard")
        mp.osd_message("Copied filename " .. filename .. " to clipboard", 3)
        reset_y() -- Reset the 'y' keypress state
    end
end

-- Bind the keys to their respective functions
mp.add_key_binding("y", "check_y", handle_y)
mp.add_key_binding("n", "check_n", handle_n)

-- Function to handle 'd' keypress
local function handle_d()
    if y_pressed then
        -- Copy the directory to clipboard
        local filepath = mp.get_property("path")
        local directory = string.match(filepath, "(.*/)")
        -- Use a method to copy 'directory' to clipboard (platform-specific)
        -- For example, on Unix-like systems, you might use 'xclip'
        os.execute("echo " .. directory .. " | xclip -selection clipboard")
        mp.osd_message("Copied directory " .. directory .. " to clipboard", 3)
        reset_y() -- Reset the 'y' keypress state
    end
end

-- Bind the 'd' key to its respective function
mp.add_key_binding("d", "check_d", handle_d)
