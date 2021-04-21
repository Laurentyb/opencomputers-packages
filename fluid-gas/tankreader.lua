local component = require("component")

function readTanks()
  for address, componentType in component.list("tank_controller") do
    percent = (component.proxy(component.get(address)).getFluidInTank(1)[1].amount / component.proxy(component.get(address)).getFluidInTank(1)[1].capacity) * 100
    print("Fuel Type: "..component.proxy(component.get(address)).getFluidInTank(1)[1].label)
    print("Amount: "..component.proxy(component.get(address)).getFluidInTank(1)[1].amount.."/"..component.proxy(component.get(address)).getFluidInTank(1)[1].capacity)
    print(math.floor(percent + 0.5).."% Full")
  end
end

while true do
  readTanks()
  os.sleep(0.1)
  term.clear()
end