local awful = require("awful")
local beautiful = require("beautiful")
local prefs = require("prefs")

local menu = {}

local wm_menu = {
   { "manual", prefs.terminal .. " -e man awesome" },
   { "edit config", prefs.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}
menu.main = awful.menu({ items = { { "awesome", wm_menu, beautiful.awesome_icon },
                                    { "open terminal", prefs.terminal },
                                    { "firefox", "firefox"},
                                    { "pidgin", "pidgin"},
                                    { "geany", "geany"}
                                  }
                        })

return menu
