local component = require("component")
local gpu = component.gpu
local event = require("event")
local ser = require("serialization")
local wm = require("wm")
local gui = require("guiElements")
local printserver = require("printserver")
local networkdriver = require("networkdriver")
local user = require("usermanagement")

wm.startGui()
wm.useShadows(false)
local versionMajor, versionMinor, versionState = wm.getVersion()
wm.setTopText(string.format("Window Manager v%d.%d %s", versionMajor, versionMinor, versionState))

printserver.start()
networkdriver.start()
user.start()

--user.login()
--wm.setUsername("")


wm.newSymbol("P", "/home/printer.lua", 0)
wm.newSymbol("N", "/home/network.lua", 0)
wm.newSymbol("F", "/home/plugin_framework.lua", 0)
wm.newSymbol(" ", "/home/memorymonitor.lua", 0)
wm.newSymbol(" ", "/home/energymonitor.lua", 0)
--wm.newSymbol("D", "/home/fsmonitor.lua", 0)

--wm.enableStartMenu(false)
wm.addStartMenu("User manager", "/home/usermanager.lua", nil, 99, 0)
wm.addStartMenu("Driver Info", "/home/driverinfo.lua", nil, 0, 0)
wm.addStartMenu("Program Frame", "/home/program_frame.lua", nil, 0, 0)
wm.addStartMenu("Messenger", "/home/messenger.lua", nil, 0, 0)
wm.addStartMenu("Terminal", "/home/terminal.lua", nil, 0, 0)

wm.setSystemMenuPos("right")
wm.addSystemMenu("Exit", wm.exitGui, nil, 0, 1)
wm.addSystemMenu("Shutdown", wm.shutdown, nil, 0, 1)
wm.addSystemMenu("Reboot", wm.shutdown, true, 0, 1)
if wm.getUsername() ~= "" then
  wm.addSystemMenu("logout", user.logout, nil, 0, 1)
end


local running = true
while running == true do
  os.sleep(0)
end
