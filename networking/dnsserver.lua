local component = require('component')
local event = require('event')
local m = component.modem
local gpu = component.gpu
local term = require('term')

-- Listening and replying port
local dnsport = 42069

-- DNS Table - Add DNS'es to the table and their respective ID's
-- ['dns name'] = 'network card address'
dnsdb = {
  ['test-server'] = 'c630e4a5-3d06-4075-b70f-be69f8b81fb9'
}


local localAddress = ''
for address, _ in component.list("modem", false) do
  localAddress = address
  break
end

m.open(dnsport)
gpu.setBackground(0x000000)
gpu.setForeground(0x00ff00)
term.clear()

print('Started DNS Server.')
gpu.setForeground(0xff00ff)
print('Listening and replying to requests on port '..dnsport)
term.write('Address: ')
gpu.setForeground(0xffffff)
term.write(localAddress)

while true do
  local _, _, from, port, _, command, param = event.pull('modem_message')
  local command = string.lower(tostring(command))
  local param = string.gsub(tostring(param), '\n', '')
  gpu.setForeground(0xffff00)
  print('Request from '..from)
  if command == 'lookup' then
    addr = tostring(dnsdb[param])
    gpu.setForeground(0xffffff)
    print('DNS Lookup: '.. param .. ' -> ' .. addr)
    m.send(from, port, addr)
  end
end