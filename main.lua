local playerModule = require("player")
local commands = require("commands")

local player = playerModule.createCharacter()

while true do
    io.write("> ")

    local command = io.read()

    if command == "stats" then
        commands.showStats(player)

    elseif command == "help" then
        commands.showHelp()

    elseif command == "look" then
        commands.lookAround(player)

    elseif command == "move north" then
        commands.movePlayer(player, "north")

    elseif command == "move south" then
        commands.movePlayer(player, "south")

    elseif command == "quit" then
        break

    else
        print("Unknown command")
    end
end
