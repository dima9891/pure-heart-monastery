local playerModule = require("player")
local commands = require("commands")

local player = playerModule.createCharacter()

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
