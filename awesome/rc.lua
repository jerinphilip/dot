local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local battery = require("battery")
local keys = require("keys")
local prefs = require("prefs")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

sound_notification = nil
brightness_notification = nil
battery_notification = nil


-- {{{ Function Definitions
--
function take_screenshot()
	local fn = awful.util.pread("scrot -q 100 '%Y-%m-%d-%H%M%S_$wx$h.png' -e 'mv $f ~/Pictures/Screenshots; echo $f'")
	fn = "~/Pictures/Screenshots\n"..fn
	naughty.notify({title="Screenshot taken", text=fn})
end

function change_brightness(c)
	--Choose the closest multiple of 10
	local x = math.floor(tonumber(awful.util.pread("xbacklight -get"))/10+0.5)
	local y = (x)*10+c
	if(y>100) then y=100 end
	if(y<=0) then y=1 end
	awful.util.spawn("xbacklight -time 0 -set "..y.."%")
    if brightness_notification ~= nil then naughty.destroy(brightness_notification) end
	brightness_notification = naughty.notify({title="Brightness", text=y.."%"})
end

function change_sound(c)
    if sound_notification ~= nil then naughty.destroy(sound_notification) end
	local x = awful.util.pread("amixer set Master "..c.."| grep -i '\\[.*%\\]' -o | tail -n 1 | sed 's/\\[\\(.*\\)\\]/\\1/g'")
	sound_notification = naughty.notify({title="Sound ", text=x})
end

function toggle_sound()
	local x = awful.util.pread("amixer set Master toggle | grep -e '\\[on\\]' -e '\\[off\\]' -o| tail -n 1")
	naughty.notify({title="Sound ", text=x})
end


--}}}



-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/usr/share/awesome/themes/custom/theme.lua")

--{{{ Naughty Configurations

naughty.config.defaults.timeout          = 10 
naughty.config.defaults.screen           = 1
naughty.config.defaults.position         = "top_right"
naughty.config.defaults.margin           = 20 
-- naughty.config.defaults.width            = 300
-- naughty.config.defaults.height            = 30
naughty.config.defaults.gap              = 5 
naughty.config.defaults.ontop            = true
naughty.config.defaults.font             = "Open Sans 12"
naughty.config.defaults.icon             = "/usr/share/icons/Faenza/apps/64/gtk-help.png"
naughty.config.defaults.icon_size        = 32
naughty.config.defaults.fg               = '#ffffff'
naughty.config.defaults.bg               = '#111111'
naughty.config.presets.border_color      = '#000000'
naughty.config.defaults.border_width     = 2
naughty.config.defaults.hover_timeout    = nil

--}}}


if prefs.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(prefs.wallpaper, s, true)
    end
end

tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ "main", "web", "mail", "code", "im", "browse-fs", "media", "cw", 9 }, s, prefs.layouts[1])
end

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", prefs.terminal .. " -e man awesome" },
   { "edit config", prefs.editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", prefs.terminal },
                                    { "firefox", "firefox"},
                                    { "pidgin", "pidgin"},
                                    { "geany", "geany"}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = prefs.terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
bat = wibox.widget.textbox()
vicious.register(bat, vicious.widgets.bat, "$1$2%", 32, "BAT0")
sep = wibox.widget.textbox(" | ")
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ prefs.modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ prefs.modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))


for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(prefs.layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(prefs.layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(prefs.layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(prefs.layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
	left_layout:add(sep)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
	right_layout:add(sep)
	right_layout:add(bat)
	right_layout:add(sep)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}



clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(keys.global)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = keys.client,
                     buttons = clientbuttons } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
     --{ rule = { class = "Firefox" },
       --properties = { tag = tags[1][2] } },
     --{ rule = { class = "firefox" },
       --properties = { tag = tags[1][2] } },
    { rule = { instance="Docky"},
      type = "dock",
      properties = { floating = true,
                     border_width = 0,
                     ontop = true,
                  }},
    { rule = { class="plugin-container" },
      properties = { floating = true}},
    { rule = { class="Plugin-container" },
      properties = { floating = true}},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


--Battery Function
function check_battery()
    local left = battery.percent('BAT0')
    local charging = battery.charging('ADP0')
	if left < 10 and not charging then
        if battery_notification ~= nil 
            then naughty.destroy(battery_notification) 
        end
		battery_notification = naughty.notify({title="Battery Low",
						preset=naughty.config.presets.critical,
						text=left.."% Remaining"})
	end
end

battery_timer = timer({timeout=100})
battery_timer:connect_signal("timeout", function() check_battery() end)
battery_timer:start()
