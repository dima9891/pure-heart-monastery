local playerModule = require("player")
local commands = require("commands")

local player = playerModule.createCharacter()

while true do
    io.write("> ")

    local input = io.read()

    if input == "quit" then
        break
    end

    local command = commands[input]

    if command then
        command(player)
    else
        print("Неизвестная команда")
    end
end
