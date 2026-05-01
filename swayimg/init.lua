-- 基础设置
swayimg.set_mode("gallery")           -- 启动时进入画廊模式
swayimg.enable_decoration(true)
-- swayimg.set_window_size(720, 480)   -- 若需要指定窗口大小

-- 查看器背景色
swayimg.viewer.set_window_background(0xff000000)   -- 黑色不透明

-- 画廊背景色
swayimg.gallery.set_window_color(0xff000000)

-- 画廊模式按键绑定
swayimg.gallery.on_key("Shift-s", function()
    local img = swayimg.gallery.get_image()
    os.execute("~/.config/scripts/wallpaper-hyprpaper.sh " .. img.path .. " &")
end)

swayimg.gallery.on_key("j", function()
    swayimg.gallery.switch_image("down")   -- 或 "next"
end)

swayimg.gallery.on_key("h", function()
    swayimg.gallery.switch_image("left")
end)

swayimg.gallery.on_key("k", function()
    swayimg.gallery.switch_image("up")     -- 或 "prev"
end)

swayimg.gallery.on_key("l", function()
    swayimg.gallery.switch_image("right")
end)

swayimg.gallery.on_key("Ctrl-c", function()
    local img = swayimg.gallery.get_image()
    os.execute("wl-copy " .. img.path)
end)

swayimg.gallery.on_key("Ctrl-Shift-c", function()
    local img = swayimg.gallery.get_image()
    os.execute("wl-copy < " .. img.path)
end)

-- 查看器模式按键绑定
swayimg.viewer.on_key("Shift-i", function()
    local img = swayimg.viewer.get_image()
    os.execute("convert " .. img.path .. " -channel RGB -negate - | swayimg -")
end)

swayimg.viewer.on_key("BackSpace", function()
    swayimg.exit()
end)

