local PlayerFactory = require("playerFactory")
local commands = require("commands")

local player = PlayerFactory.loadOrCreate()

while true do
    io.write("> ")

    local input = io.read()

    if input == "quit" then
        break
    end

    local action, argument = input:match("^(%S+)%s*(.*)$")

    if commands[action] then
        commands[action](player, argument)
    else
        print("Неизвестная команда")
    end
end
