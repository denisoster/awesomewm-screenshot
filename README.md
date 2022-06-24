awesomewm-screenshot
=======

A screenshot widget for Awesome WM.
It's compatible with Awesome 4

Requirements
------------

* scrot
* xclip


Get it
------

```sh
cd $HOME/.config/awesome/
git clone https://github.com/GourSE/awesomewm-screenshot.git
```

Use it
------

Just put these line to the appropriate places in
*$HOME/.config/awesome/rc.lua*.

```lua
-- Load the widget.
local screenshot = require("awesomewm-screenshot.screenshot")
	     

-- Configure the hotkeys.
	awful.key({ }, "Print", scrot_full,
          {description = "Take a screenshot of entire screen", group = "screenshot"}),
        awful.key({ modkey, }, "Print", scrot_selection,
          {description = "Take a screenshot of selection", group = "screenshot"}),
        awful.key({ "Shift" }, "Print", scrot_window,
          {description = "Take a screenshot of focused window", group = "screenshot"}),
        awful.key({ "Ctrl" }, "Print", scrot_delay,
          {description = "Take a screenshot of delay", group = "screenshot"}),
-- Add _d to the end for copy to clipboard only
-- 	awful.key({ }, "Print", scrot_full_d,
--        {description = "Take a screenshot of entire screen and copy to clipboard only", group = "screenshot"}),
```

the default storage of the ~/Pictures/

License
------

this software is distributed in MIT License
