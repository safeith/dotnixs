{ pkgs, ... }:

{
  home.file.".hammerspoon/init.lua".text = ''
    -- Hammerspoon Configuration
    hs.window.animationDuration = 0

    -- Window Management Functions
    local function snapLeft()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      
      f.x = max.x
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h
      win:setFrame(f)
    end

    local function snapRight()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      
      f.x = max.x + (max.w / 2)
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h
      win:setFrame(f)
    end

    local function snapUp()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      
      f.x = max.x
      f.y = max.y
      f.w = max.w
      f.h = max.h / 2
      win:setFrame(f)
    end

    local function snapDown()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      
      f.x = max.x
      f.y = max.y + (max.h / 2)
      f.w = max.w
      f.h = max.h / 2
      win:setFrame(f)
    end

    local function maximize()
      local win = hs.window.focusedWindow()
      win:maximize()
    end

    local function centerWindow()
      local win = hs.window.focusedWindow()
      win:centerOnScreen()
    end

    -- Quarter Screen Functions
    local function snapTopLeft()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      
      f.x = max.x
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h / 2
      win:setFrame(f)
    end

    local function snapBottomLeft()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      
      f.x = max.x
      f.y = max.y + (max.h / 2)
      f.w = max.w / 2
      f.h = max.h / 2
      win:setFrame(f)
    end

    local function snapTopRight()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      
      f.x = max.x + (max.w / 2)
      f.y = max.y
      f.w = max.w / 2
      f.h = max.h / 2
      win:setFrame(f)
    end

    local function snapBottomRight()
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      
      f.x = max.x + (max.w / 2)
      f.y = max.y + (max.h / 2)
      f.w = max.w / 2
      f.h = max.h / 2
      win:setFrame(f)
    end

    -- Application Launcher Functions
    local function launchOrFocusBrave()
      local app = hs.application.get("Brave Browser")
      if app then
        if app:isFrontmost() then
          app:hide()
        else
          app:activate()
        end
      else
        hs.application.launchOrFocus("Brave Browser")
      end
    end

    local function launchOrFocusKitty()
      local app = hs.application.get("kitty")
      if app then
        if app:isFrontmost() then
          app:hide()
        else
          app:activate()
        end
      else
        hs.application.launchOrFocus("kitty")
      end
    end

    local function launchOrFocusScreenshot()
      hs.application.launchOrFocus("Screenshot")
    end

    local function launchOrFocusObsidian()
      local app = hs.application.get("Obsidian")
      if app then
        if app:isFrontmost() then
          app:hide()
        else
          app:activate()
        end
      else
        hs.application.launchOrFocus("Obsidian")
      end
    end

    -- Keybindings for Quarter Screens (Option + q/w/a/s)
    hs.hotkey.bind({"alt"}, "q", snapTopLeft)
    hs.hotkey.bind({"alt"}, "a", snapBottomLeft)
    hs.hotkey.bind({"alt"}, "w", snapTopRight)
    hs.hotkey.bind({"alt"}, "s", snapBottomRight)

    -- Keybindings for Application Launchers (Option + Shift + key)
    hs.hotkey.bind({"alt", "shift"}, "b", launchOrFocusBrave)
    hs.hotkey.bind({"alt", "shift"}, "t", launchOrFocusKitty)
    hs.hotkey.bind({"alt", "shift"}, "p", launchOrFocusScreenshot)
    hs.hotkey.bind({"alt", "shift"}, "o", launchOrFocusObsidian)

    -- Keybindings for Basic Window Management (Option + h/j/k/l/m/c)
    hs.hotkey.bind({"alt"}, "h", snapLeft)
    hs.hotkey.bind({"alt"}, "l", snapRight)
    hs.hotkey.bind({"alt"}, "k", snapUp)
    hs.hotkey.bind({"alt"}, "j", snapDown)
    hs.hotkey.bind({"alt"}, "m", maximize)
    hs.hotkey.bind({"alt"}, "c", centerWindow)

    -- Notification
    hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()
  '';
}
