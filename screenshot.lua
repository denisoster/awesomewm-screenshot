local awful = require("awful")
local naughty = require("naughty")

screenshot = os.getenv("HOME") .. "/Pictures/$(date +%F_%T).png"

function scrot_full()
    local cmd = "scrot " .. screenshot .. " -e 'xclip -selection c -t image/png < $f'"
    awful.util.spawn_with_shell(cmd)
    naughty.notify({
        text = "Take a screenshot of entire screen",
        timeout = 0.5
    })
end

function scrot_selection()
    local cmd = "sleep 0.5 && scrot -s " .. screenshot .. " -e 'xclip -selection c -t image/png < $f'"
    awful.util.spawn_with_shell(cmd)
    naughty.notify({
        text = "Take a screenshot of selection",
        timeout = 0.5
    })
end

function scrot_window()
    local cmd = "scrot -u " .. screenshot .. " -e 'xclip -selection c -t image/png < $f'"
    awful.util.spawn_with_shell(cmd)
    naughty.notify({
        text = "Take a screenshot of focused window",
        timeout = 0.5
    })
end

function scrot_delay()
    local cmd5 = "scrot -d 5 " .. screenshot .. " -e 'xclip -selection c -t image/png < $f'"
    local cmd10 = "scrot -d 10 " .. screenshot .. " -e 'xclip -selection c -t image/png < $f'"
    awful.menu.new({
        items = { { "5", awful.util.spawn_with_shell(cmd5) },
            { "10", awful.util.spawn_with_shell(cmd10) },
        }
    }):show({keygrabber= true})
    naughty.notify({
        text = "Take a screenshot of delay",
        timeout = 0.5
    })
end