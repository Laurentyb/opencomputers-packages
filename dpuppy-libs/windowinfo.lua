local component = require("component")
local gpu = component.gpu
local computer = require("computer")
local event = require("event")
local ser = require("serialization")
local unicode = require("unicode")
local wm = require("wm")
local gui = require("guiElements")

-- Program parameters
-- FIXME: Change to your options
local programName = "Window info"
local releaseYear = "2017"
local versionMajor = 1
local versionMinor = 0
local author = "S.Kempa"
local windowWidth = 30
local windowHeight = 9
local hideWindowFromList = true


local ScreenWidth, screenHeight = gpu.getResolution()
local args = {...}
local myID = args[1]
local myIcon = args[4]

-- Function that will called, if one of the exit buttons is clicked
local function exitButtonCallback(self, win)
  wm.closeWindow(win)
  wm.setRunningState(myID, false)
end

if args[2] == "load" then
  -- FIXME: insert code that will executed when program is loaded
  
elseif args[2] == "unload" then
  -- FIXME: insert code that will executed when program is unloaded
  
  
elseif args[2] == "execute" and args[3] == 1 then
  wm.setRunningState(myID, true)
  local infoWindow = wm.newWindow(math.floor(ScreenWidth/2) - 15, math.floor(screenHeight/2) - 4, 32, 10, programName .. " info")
  wm.setWindowSticky(infoWindow, true)
  wm.disableWindowButtons(infoWindow, true)
  local infoVersion = gui.newLabel(1, 2, 30, 1, string.format("%s v%d.%d", programName, versionMajor, versionMinor))
  gui.setElementAlignment(infoVersion, "center")
  wm.addElement(infoWindow, infoVersion)
  local infoCopyright = gui.newLabel(1, 4, 30, 1, string.format("Copyright%s %s by",  unicode.char(0x00A9), releaseYear))
  gui.setElementAlignment(infoCopyright, "center")
  wm.addElement(infoWindow, infoCopyright)
  local infoCopyright2 = gui.newLabel(1, 5, 30, 1, string.format("%s", author))
  gui.setElementAlignment(infoCopyright2, "center")
  wm.addElement(infoWindow, infoCopyright2)
  local infoMemory = gui.newLabel(1, 7, 30, 1, string.format("%d Kb of %d Kb mem free", computer.freeMemory()/1024, computer.totalMemory()/1024))
  gui.setElementAlignment(infoMemory, "center")
  wm.addElement(infoWindow, infoMemory)
  local infoExitButton = gui.newButton(13, 9, 6, 1, "exit", exitButtonCallback)
  wm.addElement(infoWindow, infoExitButton)
  wm.raiseWindow(infoWindow)
elseif args[2] == "execute" and args[3] == 0 then
  wm.setRunningState(myID, true)
  local activeWindow = wm.getActiveWindow()
  local winX, winY, winW, winH, winText, numElements = wm.getWindowInfo(activeWindow)

  local window = wm.newWindow(1, 1, 30, 9, "Window information")
  wm.setWindowSticky(window, true)
  wm.disableWindowButtons(window, true)
  wm.hideWindow(window, hideWindowFromList)

  local windowTextLabel = gui.newLabel(1, 2, 28, 1, winText)
  gui.setElementAlignment(windowTextLabel, "center")
  wm.addElement(window, windowTextLabel)

  local line1 = gui.newLine(1, 3, 28)
  wm.addElement(window, line1)

  local windowPositionLabel = gui.newLabel(1, 4, 28, 1, string.format("Position  : x %3d  y %3d", winX, winY))
  wm.addElement(window, windowPositionLabel)

  local windowDimensionLabel = gui.newLabel(1, 5, 28, 1, string.format("Dimension : w %3d  h %3d", winW, winH))
  wm.addElement(window, windowDimensionLabel)

  local windowElementsLabel = gui.newLabel(1, 6, 28, 1, string.format("Elements  : %d", numElements))
  wm.addElement(window, windowElementsLabel)

  local windowExitButton = gui.newButton(math.floor(windowWidth/2) - 3, windowHeight - 1, 6, 1, "exit", exitButtonCallback)
  wm.addElement(window, windowExitButton)
  
  wm.raiseWindow(window)
end


