local awful = require("awful")
local naughty = require("naughty")

Timers = { 5, 10 }
Date = os.date("%Y-%m-%d_%H:%M:%S")                                 --Change File Format Here
Screenshot = os.getenv("HOME") .. "/Pictures/Screenshots/" .. Date  --Change Directory Here

function scrot_full()
  
    awful.spawn.easy_async_with_shell("scrot " .. Screenshot,
    function() awful.spawn.easy_async_with_shell("xclip -selection clipboard -t image/png -i " .. Screenshot,
            scrot_callback("Take a screenshot entire screen")) end)
end

function scrot_selection()
   
    awful.spawn.easy_async_with_shell("scrot -s " .. Screenshot,
        function() awful.spawn.easy_async_with_shell("xclip -selection clipboard -t image/png -i " .. Screenshot,
                scrot_callback("Take a screenshot of selection")) end)

  
end

function scrot_window()
  
    awful.spawn.easy_async_with_shell("scrot -u " .. Screenshot,
    function() awful.spawn.easy_async_with_shell("xclip -selection clipboard -t image/png -i " .. Screenshot,
            scrot_callback("Take a screenshot of focused window")) end)

end

function scrot_delay()
    items = {}
    for key, value in ipairs(Timers) do
        items[#items + 1] = { tostring(value),
            "scrot -d " .. value .. " " .. Screenshot .. " -e 'xclip -selection c -t image/png < $f'",
            "Take a screenshot of delay" }
    end
    awful.menu.new(
        {
            items = items
        }
    ):show({ keygrabber = true })
    scrot_callback()
end

function scrot(cmd, callback, args)
    awful.util.spawn_with_shell(cmd)
    callback(args)
end

function scrot_callback(text)
    naughty.notify({
        text = text,
        timeout = 1
    })
end


