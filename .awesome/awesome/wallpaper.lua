function wallpaper_cycle()
    wp_index = 1
    wp_timeout = 20
    wp_path = "/home/jerin/Dropbox/wallpaper/girls/"
    wp_files = {}
    for img in string.gmatch(awful.util.pread("ls -1 "..wp_path), "([^\n]+)\n") do
        table.insert(wp_files, img)
    end

    function file_exists(fn)
        local f = io.open(fn)
        local t = f ~= nil
        if t then
            io.close(f)
        end
        return t 
    end
    wp_timer = timer { timeout = wp_timeout }
    wp_timer:connect_signal("timeout", function ()
            local fname = wp_path..wp_files[wp_index]
            while not file_exists(fname) do
                wp_index = math.fmod(wp_index, #wp_files) +  1
                fname = wp_path..wp_files[wp_index]
            end
            gears.wallpaper.maximized( wp_path..wp_files[wp_index], s, true)
            wp_timer:stop()
            wp_index = math.fmod(wp_index, #wp_files) +  1

            wp_timer.timeout = wp_timeout
            wp_timer:start()
        end)

        wp_timer:start()

end


