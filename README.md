awesomewm-screenshot
=======

A screenshot widget for Awesome WM.
It's compatible with Awesome 4

Requirements
------------

* maim
* xclip
* xdotool


Get it
------

```sh
cd $XDG_CONFIG_HOME/awesome/
git clone https://github.com/denisoster/awesomewm-screenshot.git
```

Use it
------

Just put these line to the appropriate places in
*$XDG_CONFIG_HOME/awesome/rc.lua*.

```lua
-- Load the widget.
local screenshot = require("awesomewm-screenshot.screenshot")

-- Configure the hotkeys.
        awful.key({}, "Print", take_full_screenshot, { description = "Скриншот экрана", group = "screenshot" }),

        awful.key({ "Shift" }, "Print", take_area_screenshot, { description = "Скриншот области", group = "screenshot" }),

        awful.key({ "Control" }, "Print", take_window_screenshot, { description = "Скриншот окна", group = "screenshot" }),
```

License
------

this software is distributed in MIT License
