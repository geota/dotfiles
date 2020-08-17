-- Ensure the IPC command line client is available
hs.ipc.cliInstall()

-- disable animation
hs.window.animationDuration = 0


function tableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end


-- Watchers and other useful objects
local configFileWatcher = nil
local appWatcher = nil
local wifiWatcher = nil
local screenWatcher = nil
local usbWatcher = nil

local mouseCircle = nil
local mouseCircleTimer = nil

-- This tracks the windows we minimize and maximize
local windows = nil
local lastWindow = nil

-- Define some keyboard modifier variables
-- (Node: Capslock bound to cmd+alt+ctrl+shift via Seil and Karabiner)
local alt = {"⌥"}
local hyper = {"⌘", "⌥", "⌃", "⇧"}

-- Define audio device names for headphone/speaker switching
local headphoneDevice = "Headphones"
local speakerDevice = "Internal Speakers"

-- Defines for WiFi watcher
local homeSSID = "firenado" -- My home WiFi SSID
local workSSID = "PGBG00123" -- My home WiFi SSID
local lastSSID = hs.wifi.currentNetwork()

-- Defines for screen watcher
local lastNumberOfScreens = tableLength(hs.screen.allScreens())

-- Define monitor names for layout purposes
local display_laptop = "Color LCD"

if lastNumberOfScreens == 1 then
    local display_monitor_1 = hs.screen.allScreens()[0]
    local display_monitor_2 = hs.screen.allScreens()[0]
elseif lastNumberOfScreens == 2 then
    local display_monitor_1 = hs.screen.allScreens()[1]
    local display_monitor_2 = hs.screen.allScreens()[1]
else
    local display_monitor_1 = hs.screen.allScreens()[1]
    local display_monitor_2 = hs.screen.allScreens()[2]
end

-- Defines for window grid
hs.grid.GRIDWIDTH = 4
hs.grid.GRIDHEIGHT = 4
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

-- Defines for window maximize toggler
local frameCache = {}

-- Define window layouts
--   Format reminder:
--     {"App name", "Window name", "Display Name", "unitrect", "framerect", "fullframerect"},

hs.application.enableSpotlightForNameSearches(true)


local internal_display = {
    {"Atom",               nil,          display_laptop, hs.layout.left25, nil, nil},
    {"Google Chrome",      nil,          display_laptop, hs.layout.right75, nil, nil}
}

local dual_display = {
    {"iTerm2",           nil,           display_laptop, hs.layout.maximized,   nil, nil},
    {"Atom",              nil,          display_monitor_1,  hs.layout.maximized, nil, nil},
    {"Google Chrome",     nil,          display_monitor_1,  hs.layout.maximized, nil, nil}
}

local tri_display = {
    {"iTerm2",           nil,           display_laptop, hs.layout.maximized,   nil, nil},
    {"Atom",              nil,          display_monitor_1,  hs.layout.maximized, nil, nil},
    {"Google Chrome",     nil,          display_monitor_2, hs.layout.right75,    nil, nil},
    {"Slack",           nil,          display_monitor_2, hs.layout.left25,   nil, nil}
}


-- Helper functions

-- Replace Caffeine.app with 18 lines of Lua :D
local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    local result
    if state then
        result = caffeine:setIcon("caffeine-on.pdf")
    else
        result = caffeine:setIcon("caffeine-off.pdf")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- Toggle between speaker and headphone sound devices (useful if you have multiple USB soundcards that are always connected)
function toggle_audio_output()
    local current = hs.audiodevice.defaultOutputDevice()
    local speakers = hs.audiodevice.findOutputByName(speakerDevice)
    local headphones = hs.audiodevice.findOutputByName(headphoneDevice)

    if not speakers or not headphones then
        hs.notify.new({title="Hammerspoon", informativeText="ERROR: Some audio devices missing", ""}):send():release()
        return
    end

    if current:name() == speakers:name() then
        headphones:setDefaultOutputDevice()
    else
        speakers:setDefaultOutputDevice()
    end
    hs.notify.new({
          title='Hammerspoon',
            informativeText='Default output device:'..hs.audiodevice.defaultOutputDevice():name()
        }):send():release()
end

-- Toggle Skype between muted/unmuted, whether it is focused or not
function toggleSkypeMute()
    local skype = hs.appfinder.appFromName("Skype")
    if not skype then
        return
    end

    local lastapp = nil
    if not skype:isFrontmost() then
        lastapp = hs.application.frontmostApplication()
        skype:activate()
    end

    if not skype:selectMenuItem({"Conversations", "Mute Microphone"}) then
        skype:selectMenuItem({"Conversations", "Unmute Microphone"})
    end

    if lastapp then
        lastapp:activate()
    end
end

-- Toggle an application between being the frontmost app, and being hidden
function toggle_application(_app)
    local app = hs.appfinder.appFromName(_app)
    if not app then
        -- FIXME: This should really launch _app
        -- If we had the .app name we could call open AppName.app
        return
    end
    local mainwin = app:mainWindow()
    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    end
end

-- Toggle a window between its normal size, and being maximized
function toggle_window_maximized()
    local win = hs.window.focusedWindow()
    if win == nil then
        print("No screen focused")
    elseif frameCache[win:id()] then
        local curFrame = win:frame()
        if (curFrame["x"] == frameCache[win:id()]["x"] and curFrame["h"] == frameCache[win:id()]["h"] and curFrame["y"] == frameCache[win:id()]["y"]) then
            print("Screen is already in position")
        else
            win:setFrame(frameCache[win:id()])
        end
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end

-- function toggle_window_minimized()
--     local l = windows
--
--     if l == nil then
--         list = {next = list, value = hs.window.focusedWindow()}
--         l = windows
--         lastWindow = l.value
--     else
--         lastWindow = l.value
--     end
--
--     while ()
--
--
--     if not lastWindow.isMinimized() then
--         lastWindow.minimize()
--     end
--
--
--
--
--
--     local currentFocusedWindow = hs.window.focusedWindow()
--     -- TODO : Implement linked list of focused window and when none are focused... pop off and show
--     -- if lastMinimizedWindow and currentFocusedWindow == nil then
--     if lastMinimizedWindow then
--
--         if lastMinimizedWindow.isMinimized() then
--             lastMinimizedWindow.unminimize()
--         end
--
--
--         lastMinimizedWindow:application():activate(true)
--         lastMinimizedWindow:application():unhide()
--         lastMinimizedWindow:focus()
--         lastMinimizedWindow = nil
--     else
--         lastMinimizedWindow = currentFocusedWindow
--         lastMinimizedWindow:application():hide()
--     end
-- end

function hide_all_windows()
    -- TODO: IMPLEMENT ME
end

-- Callback function for application events
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "Finder") then
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({"Window", "Bring All to Front"})
        end
    end
end

-- Callback function for WiFi SSID change events
function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We have gone from something that isn't my home WiFi, to something that is
        home_arrived()
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We have gone from something that is my home WiFi, to something that isn't
        home_departed()
    end

    if newSSID == workSSID and lastSSID ~= workSSID then
        -- We have gone from something that isn't my work WiFi, to something that is
        work_arrived()
    elseif newSSID ~= workSSID and lastSSID == workSSID then
        -- We have gone from something that is my home WiFi, to something that isn't
        work_departed()
    end

    lastSSID = newSSID
end

-- Callback function for USB device events
function usbDeviceCallback(data)
    print("usbDeviceCallback: "..hs.inspect(data))
    -- if (data["productName"] == "ScanSnap S1300i") then
    --     event = data["eventType"]
    --     if (event == "added") then
    --         hs.application.launchOrFocus("ScanSnap Manager")
    --     elseif (event == "removed") then
    --         app = hs.appfinder.appFromName("ScanSnap Manager")
    --         app:kill()
    --     end
    -- end
end



-- Callback function for changes in screen layout
function screensChangedCallback()
    newNumberOfScreens = tableLength(hs.screen.allScreens())

    if lastNumberOfScreens ~= newNumberOfScreens then
        if newNumberOfScreens == 1 then
            hs.layout.apply(internal_display)
        elseif newNumberOfScreens == 2 then
            hs.layout.apply(dual_display)
        elseif newNumberOfScreens == 3 then
            hs.layout.apply(tri_display)
        end
    end

    -- FIXME: We should really be calling a function here that destroys and re-creates the statuslets, in case they need to be in new places

    lastNumberOfScreens = newNumberOfScreens

end

-- Perform tasks to configure the system for my home WiFi network
function home_arrived()
    -- Do nothing for now
end

-- Perform tasks to configure the system for any WiFi network other than my home
function home_departed()
    -- Do nothing for now
end

function work_arrived()
    -- Do nothing for now
end

function work_departed()
    -- Do nothing for now
end

-- I always end up losing my mouse pointer, particularly if it's on a monitor full of terminals.
-- This draws a bright red circle around the pointer for a few seconds
function mouseHighlight()
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.getAbsolutePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(4)
    mouseCircle:show()

    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end

-- Rather than switch to Safari, copy the current URL, switch back to the previous app and paste,
-- This is a function that fetches the current URL from Safari and types it

-- FIXME: This does not work in Chrome -- see if there is a way that we can get the current chrome URL
function typeCurrentChromeURL()
    script = [[
    tell application "Google Chrome"
        set currentURL to URL of document 1
    end tell

    return currentURL
    ]]
    ok, result = hs.applescript(script)
    if (ok) then
        hs.eventtap.keyStrokes(result)
    else
        print("result typeCurrentChromeUrl: "..hs.inspect(result))
    end
end

-- Reload config
function reloadConfig(paths)
    doReload = false
    for _,file in pairs(paths) do
        if file:sub(-4) == ".lua" then
            print("A lua file changed, doing reload")
            doReload = true
        end
    end
    if not doReload then
        print("No lua file changed, skipping reload")
        return
    end

    hs.reload()
end

-- Hotkeys to move windows between screens, retaining their position/size relative to the screen
hs.hotkey.bind(hyper, ";", function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind(hyper, "'", function() hs.window.focusedWindow():moveOneScreenEast() end)

-- Hotkeys to resize windows absolutely
hs.hotkey.bind(hyper, 'p', function() hs.window.focusedWindow():moveToUnit(hs.layout.left30) end)
hs.hotkey.bind(hyper, '\\', function() hs.window.focusedWindow():moveToUnit(hs.layout.right70) end)
hs.hotkey.bind(hyper, '[', function() hs.window.focusedWindow():moveToUnit(hs.layout.left50) end)
hs.hotkey.bind(hyper, ']', function() hs.window.focusedWindow():moveToUnit(hs.layout.right50) end)
hs.hotkey.bind(hyper, '=', toggle_window_maximized)
hs.hotkey.bind(hyper, '-', function() hs.window.focusedWindow():toggleFullScreen() end)
-- hs.hotkey.bind(hyper, '-', toggle_window_minimized)

hs.hotkey.bind(hyper, 'r', function() hs.window.focusedWindow():toggleFullScreen() end)

-- Hotkeys to trigger defined layouts
hs.hotkey.bind(hyper, '1', function() hs.layout.apply(internal_display) end)
hs.hotkey.bind(hyper, '2', function() hs.layout.apply(dual_display) end)
hs.hotkey.bind(hyper, '3', function() hs.layout.apply(tri_display) end)

-- Hotkeys to interact with the window grid
hs.hotkey.bind(hyper, 'Left', hs.grid.pushWindowLeft)
hs.hotkey.bind(hyper, 'Right', hs.grid.pushWindowRight)
hs.hotkey.bind(hyper, 'Up', hs.grid.pushWindowUp)
hs.hotkey.bind(hyper, 'Down', hs.grid.pushWindowDown)

-- Cant get to work
hs.urlevent.bind('hypershiftleft', hs.grid.resizeWindowThinner)
hs.urlevent.bind('hypershiftright', hs.grid.resizeWindowWider)
hs.urlevent.bind('hypershiftup', hs.grid.resizeWindowShorter)
hs.urlevent.bind('hypershiftdown', hs.grid.resizeWindowTaller)

-- Application hotkeys
hs.hotkey.bind(hyper, 'e', function() toggle_application("iTerm2") end)
hs.hotkey.bind(hyper, 'q', function() toggle_application("Google Chrome") end)

-- Misc hotkeys
hs.hotkey.bind(hyper, 'y', hs.toggleConsole)
hs.hotkey.bind(hyper, 'n', function() os.execute("open ~") end)
hs.hotkey.bind(hyper, 'c', caffeineClicked)
hs.hotkey.bind(hyper, 'Escape', toggle_audio_output)
hs.hotkey.bind(hyper, 'm', toggleSkypeMute)
hs.hotkey.bind(hyper, 'd', mouseHighlight)
-- hs.hotkey.bind(hyper, 'u', typeCurrentChromeURL)

-- Type the current clipboard, to get around web forms that don't let you paste
-- (Note: I have Fn-v mapped to F17 in Karabiner)
-- hs.urlevent.bind('fnv', function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

local tiling = require "hs.tiling"

hs.hotkey.bind(hyper, "z", function() tiling.cyclelayout() end)
hs.hotkey.bind(hyper, "a", function() tiling.cycle(-1) end)
hs.hotkey.bind(hyper, "s", function() tiling.cycle(1) end)
hs.hotkey.bind(hyper, "space", function() tiling.promote() end)

-- If you want to set the layouts that are enabled
tiling.set('layouts', {
  'fullscreen', 'main-vertical', 'gp-vertical'
})

-- Create and start our callbacks
hs.application.watcher.new(applicationWatcher):start()

screenWatcher = hs.screen.watcher.new(screensChangedCallback)
screenWatcher:start()

-- windowWatcher = hs.window.watcher.new(windowCallback)
-- windowWatcher:start()

-- wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
-- wifiWatcher:start()

-- usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
-- usbWatcher:start()

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configFileWatcher:start()

-- Make sure we have the right location settings
if hs.wifi.currentNetwork() == "tsunani" then
    home_arrived()
else
    home_departed()
end

-- Finally, show a notification that we finished loading the config successfully
hs.notify.new({
      title='Hammerspoon',
        informativeText='Config loaded'
    }):send():release()



-- This is some developer debugging stuff. It will cause Hammerspoon to crash if any Lua is being executed on the wrong thread. You probably don't want this in your config :)
-- local function crashifnotmain(reason)
-- --  print("crashifnotmain called with reason", reason) -- may want to remove this, very verbose otherwise
--   if not hs.crash.isMainThread() then
--     print("not in main thread, crashing")
--     hs.crash.crash()
--   end
-- end
-- debug.sethook(crashifnotmain, 'c')
