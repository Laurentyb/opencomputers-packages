local component = require("component")
local gpu = component.gpu
local computer = require("computer")
local event = require("event")
local wm = require("wm")
local gui = require("guiElements")
local printserver = require("printserver")
local networkdriver = require("networkdriver")
local user = require("usermanagement")
local term = require("term")

local shell = require("shell")
local text = require("text")
local sh = require("sh")


local ScreenWidth, screenHeight = gpu.getResolution()

local args = { ... }

local myID = args[1]

-- NOTE: Change to your options
local ProgramName = "Terminal"
local windowWidth = 60
local windowHeight = 20
local windowX = math.floor(ScreenWidth/2) - math.floor(windowWidth/2)
local windowY = math.floor(screenHeight/2) - math.floor(windowHeight/2)

--NOTE: Put your gui element here, if you use them global in your program
local window, CloseButton

local running = true

local function windowCloseCallback(win)
  -- NOTE: Insert your code, that will be execute before closing the window here

  wm.exitProgram(myID)
end



local function windowLowerCallback(win)
  -- NOTE: Insert your code, that will be execute when lowering the window here
end



local function buttonCallback(self, win)
  -- NOTE: Insert your code, that will be execute before closing the window here

  running = false
  wm.exitProgram(myID)
  wm.closeWindow(window) 
end


window = wm.newWindow(windowX, windowY, windowWidth, windowHeight, ProgramName)
wm.setOnCloseCallback(window, windowCloseCallback)
wm.setOnLowerCallback(window, windowLowerCallback)
--wm.disableWindowButtons(window, true)
--wm.hideWindow(window, hideWindowFromList)
--wm.setWindowSticky(window, true)

terminal = gui.newTerminal(1, 1, windowWidth, windowHeight)
wm.addElement(window, terminal)
terminal.firstCall = true

wm.raiseWindow(window)


--[[
program = assert(loadfile("/bin/component.lua"))
local status, err = pcall(program)
gpu.set(1,1, tostring(status).." ".. tostring(err))
  while running == true do
    if wm.getActiveWindow() == window then					-- prevent window from updating, if it is not the top windows
    end
  os.sleep(0.000001)
  end
]]--
--wm.closeWindow(window)


