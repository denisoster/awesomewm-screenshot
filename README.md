awesomewm-screenshot
=======

A screenshot widget for Awesome WM.
It's compatible with Awesome 4

Requirements
------------

* maim
* xclip
* xdotool
* rubato


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
local screenshot = require("screenshot")

-- Configure the hotkeys.
awful.key({}, "Print", screenshot.take_full, { description = "Скриншот экрана", group = "screenshot" }),

awful.key({ "Shift" }, "Print", screenshot.take_area, { description = "Скриншот области", group = "screenshot" }),

awful.key({ "Control" }, "Print", screenshot.take_window, { description = "Скриншот окна", group = "screenshot" }),
```

License
------

this software is distributed in MIT License
