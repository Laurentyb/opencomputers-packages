local component = require("component")
local gpu = component.gpu
local computer = require("computer")
local fs = require("filesystem")
local event = require("event")
local unicode = require("unicode")
local wm = require("wm")
local gui = require("guiElements")
local ser = require("serialization")

-- Program parameters
-- NOTE: Change to your options
local programName = "filesystem monitor"
local releaseYear = "2017"
local versionMajor = 1
local versionMinor = 0
local author = "S.Kempa"
local windowWidth = 62
local windowHeight = 17
local hideWindowFromList = true


local ScreenWidth, screenHeight = gpu.getResolution()
local args = {...}
local myID = args[1]
local myIcon = args[4]

local symbols = {
  unicode.char(0x258F),
  unicode.char(0x258E),
  unicode.char(0x258D),
  unicode.char(0x258C),
  unicode.char(0x258B),
  unicode.char(0x258A),
  unicode.char(0x2589),
  unicode.char(0x2588),
}
--[[
local symbols = {
  unicode.char(0x2581),
  unicode.char(0x2582),
  unicode.char(0x2583),
  unicode.char(0x2584),
  unicode.char(0x2585),
  unicode.char(0x2586),
  unicode.char(0x2587),
  unicode.char(0x2588),
}
]]--


local function formatSize(size)
  local sizes = {"", "K", "M", "G"}
  local unit = 1
  while size > 1024 and unit < #sizes do
    unit = unit + 1
    size = size / 1024
  end
  return math.floor(size * 10) / 10 .. sizes[unit]
end



-- Function that will called, if one of the exit buttons is clicked
local function exitButtonCallback(self, win)
  --NOTE: Put code here, that you need before window is closed
  
  wm.closeWindow(win)
  wm.setRunningState(myID, false)
end


local function checkboxCallback(self, win)
  dockingList[selected].show = gui.getElementState(self)
  gpu.set(1,25, ser.serialize(dockingList))
end


if args[2] == "load" then

  
elseif args[2] == "unload" then
  
  
elseif args[2] == "execute" and args[3] == 1 then
  wm.setRunningState(myID, true)
  local infoWindow = wm.newWindow(math.floor(ScreenWidth/2) - 15, math.floor(screenHeight/2) - 4, 32, 10, "Info")
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
  local infoExitButton = gui.newButton(13, 9, 6, 1, "exit", exitButtonCallback)
  wm.addElement(infoWindow, infoExitButton)
  wm.raiseWindow(infoWindow)
elseif args[2] == "execute" and args[3] == 0 then
local dockingList = {}
local mounts = {}
local selected = 1

  wm.setRunningState(myID, true)
  window = wm.newWindow(math.floor(ScreenWidth/2) - math.floor(windowWidth/2), math.floor(screenHeight/2) - math.floor(windowHeight/2), windowWidth, windowHeight,  programName)
  wm.hideWindow(window, hideWindowFromList)
  wm.disableWindowButtons(window, true)
  local windowExitButton = gui.newButton(math.floor(windowWidth/2) - 4, windowHeight - 1, 7, 1, "close", exitButtonCallback)
  wm.addElement(window, windowExitButton)

  
  List = gui.newList(2, 2, 57, 10, "", function() selected = gui.getElementSelected(List) gui.setElementValue(Slider, selected) gui.drawElement(window, Slider) gui.setElementState(dockingCheckbox, dockingList[selected].show) gui.drawElement(window, dockingCheckbox) end)
  gui.clearElementData(List)
  wm.addElement(window, List)
  gui.setElementBackground(List, 0xFFFFFF)
  gui.setElementActiveBackground(List, 0x202020)
  gui.setElementForeground(List, 0x000000)
  gui.setElementActiveForeground(List, 0xFFFFFF)


  for proxy, path in fs.mounts() do
    if not mounts[proxy] or mounts[proxy]:len() > path:len() then
      mounts[proxy] = path
    end
  end

  for proxy, path in pairs(mounts) do
    local label = proxy.getLabel() or proxy.address
    local used, total = proxy.spaceUsed(), proxy.spaceTotal()
    local available, percent
    if total ~= math.huge then
      available = total - used
      percent = used / total
      if percent == percent then 
	percent = math.ceil(percent * 100) .. "%"
	table.insert(dockingList, {["show"] = false, ["label"] = label, ["used"] = used, ["total"] = total})
	gui.insertElementData(List, string.format("%-10s %10s %10s %5s %-20s",label, formatSize(used), formatSize(available), percent, path))
      end
    end
  end

--  print(ser.serialize(dockingList))
--  print(ser.serialize(List.data))

    
  Slider = gui.newVSlider(59, 2, 10, function() selected = gui.getElementValue(Slider) gui.setElementSelected(List, selected) gui.drawElement(window, List) gui.setElementState(dockingCheckbox, dockingList[selected].show) gui.drawElement(window, dockingCheckbox) end)
  gui.setElementMin(Slider, 1)
  gui.setElementValue(Slider, 1)
  wm.addElement(window, Slider)
  gui.setElementMax(Slider, #dockingList)
  
  wm.addElement(window, gui.newLine(1, 13, 60))
  
  dockingCheckbox = gui.newCheckbox(2, 14, "Dock monitor symbol ", checkboxCallback)
  wm.addElement(window, dockingCheckbox)
  
  wm.addElement(window, gui.newLine(1, 15, 60))
  wm.raiseWindow(window)
--[[
  while running == true do
    local num = 0
    for i = 1, #dockingList do
      if dockingList[i].show == true then
	num = num + 1
      end
    end
  --  gpu.set(1,1,tostring(num))
    if num < 1 then
      return
    end
    wm.setSymbolSize(myID, num)
    local used, total
    local posX, posY = wm.getSymbolPos(myID)
    for i = 1, #dockingList do
      if dockingList[i].show == true then
	used = dockingList[i].used
	total = dockingList[i].total
	dockingSymbol = math.floor(8 / total * used)
	gpu.setBackground(0x202020)
	if dockingSymbol < 4 and dockingSymbol > 2 then
	  gpu.setForeground(0xA0A000)
	elseif dockingSymbol > 2 then
	  gpu.setForeground(0x008000)
	else
	  gpu.setForeground(0xFF0000)
	end
	if dockingSymbol > 0 then
	  gpu.set(posX - i , posY, symbols[dockingSymbol])
	end
      end
    end
  os.sleep(1)
  end
]]--
end


