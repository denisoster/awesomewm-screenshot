local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local rubato = require("lib.rubato")

local M = {}

local xdg_pictures = os.getenv("XDG_PICTURES_DIR") or (os.getenv("HOME") .. "/Pictures")
local screenshot_dir = xdg_pictures .. "/Screenshots/"
awful.spawn.with_shell("mkdir -p \"" .. screenshot_dir .. "\"")

local thumbnail = {
    popup = nil,
    timer = nil,
    animation = nil
}

local function close_thumbnail()
    if thumbnail.timer and thumbnail.timer.started then
        thumbnail.timer:stop()
    end

    thumbnail.animation = nil

    if thumbnail.popup then
        thumbnail.popup.visible = false
        thumbnail.popup = nil
    end

    thumbnail.timer = nil
end

local function thumbnail_widget(image_path)
    local widget = wibox.widget {
        image = image_path,
        forced_height = 180,
        forced_width = 320,
        widget = wibox.widget.imagebox
    }

    widget:buttons(gears.table.join(
            awful.button({}, 1, function()
                close_thumbnail()
                awful.spawn.with_shell("xdg-open '" .. image_path .. "'")
            end)
    ))

    return widget
end

local function setup_animation()
    local screen_width = awful.screen.focused().geometry.width
    local initial_x = screen_width - 320 - 50

    thumbnail.animation = rubato.timed {
        pos = initial_x,
        rate = 60,
        duration = 0.5,
        intro = 0,
        override_dt = true,
        subscribed = function(pos)
            if thumbnail.popup then
                thumbnail.popup.x = pos
            end
        end,
        easing = rubato.quadratic
    }
end

local function setup_timer()
    thumbnail.timer = gears.timer {
        timeout = 3,
        autostart = true,
        single_shot = true,
        callback = function()
            local screen_width = awful.screen.focused().geometry.width
            thumbnail.animation.target = screen_width + 320

            gears.timer {
                timeout = 0.6,
                autostart = true,
                single_shot = true,
                callback = close_thumbnail
            }
        end
    }
end

local function show_thumbnail(image_path)
    close_thumbnail()

    thumbnail.popup = awful.popup {
        widget = thumbnail_widget(image_path),
        border_color = "#FFFFFF",
        border_width = 2,
        ontop = true,
        visible = true,
        placement = function(d)
            awful.placement.bottom_right(d, {
                margins = {
                    bottom = 50,
                    right = 50
                }
            })
        end,
        screen = awful.screen.focused()
    }

    setup_animation()
    setup_timer()
end

local function generate_filename(prefix)
    return screenshot_dir .. os.date("%Y-%m-%d_%H-%M-%S") .. "_" .. prefix .. ".png"
end

local function copy_to_clipboard(filepath)
    awful.spawn("xclip -selection clipboard -t image/png -i " .. filepath)
end

function M.take_full()
    local filename = generate_filename("full")

    awful.spawn.easy_async("maim " .. filename, function(_, _, _, exit_code)
        if exit_code == 0 then
            copy_to_clipboard(filename)
            show_thumbnail(filename)
        end
    end)
end

function M.take_area()
    local filename = generate_filename("area")

    awful.spawn.easy_async("maim -s " .. filename, function(_, _, _, exit_code)
        if exit_code == 0 then
            copy_to_clipboard(filename)
            show_thumbnail(filename)
        end
    end)
end

function M.take_window()
    local filename = generate_filename("window")

    awful.spawn.easy_async("xdotool getactivewindow", function(stdout, _, _, exit_code)
        if exit_code ~= 0 then return end

        local window_id = stdout:gsub("%s+", "")
        if window_id == "" then return end

        awful.spawn.easy_async("xdotool selectwindow", function(selected_window, _, _, select_exit)
            if select_exit ~= 0 or not selected_window or selected_window == "" then
                return
            end

            awful.spawn.easy_async("maim -i " .. selected_window .. " " .. filename, function(_, _, _, maim_exit)
                if maim_exit == 0 then
                    copy_to_clipboard(filename)
                    show_thumbnail(filename)
                end
            end)
        end)
    end)
end

return M