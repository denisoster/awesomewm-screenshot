local screenshot_dir = os.getenv("HOME") .. "/Pictures/Screenshots/"

local thumbnail = {
    popup = nil,
    timer = nil,
}

local function close_thumbnail()
    if thumbnail.timer and thumbnail.timer.started then
        thumbnail.timer:stop()
    end

    if thumbnail.popup then
        thumbnail.popup.visible = false
    end

    thumbnail.popup = nil
    thumbnail.timer = nil
end

local function show_thumbnail(image_path)
    close_thumbnail()

    local image_widget = wibox.widget {
        image = image_path,
        forced_height = 180,
        forced_width = 320,
        widget = wibox.widget.imagebox
    }

    image_widget:buttons(gears.table.join(
            awful.button({}, 1, function()
                if image_path then
                    awful.spawn.with_shell("xdg-open '" .. image_path .. "'")
                end
                close_thumbnail()
            end)
    ))

    thumbnail.popup = awful.popup {
        widget = image_widget,
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

    thumbnail.timer = gears.timer {
        timeout = 3,
        autostart = true,
        single_shot = true,
        callback = close_thumbnail
    }

end

local function take_full_screenshot()
    local filename = screenshot_dir .. "screenshot_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"

    awful.spawn.easy_async("maim " .. filename, function()
        awful.spawn.spawn("xclip -selection clipboard -t image/png -i " .. filename)
        show_thumbnail(filename)
    end)

end

local function take_area_screenshot()
    local filename = screenshot_dir .. "area_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"

    awful.spawn.easy_async("maim -s " .. filename, function()
        awful.spawn.spawn("xclip -selection clipboard -t image/png -i " .. filename)
        show_thumbnail(filename)
    end)
end

local function take_window_screenshot()
    local filename = screenshot_dir .. "window_" .. os.date("%Y-%m-%d_%H-%M-%S") .. ".png"

    awful.spawn.easy_async("maim -i $(xdotool getactivewindow) " .. filename, function()
        awful.spawn.spawn("xclip -selection clipboard -t image/png -i " .. filename)
        show_thumbnail(filename)
    end)
end
