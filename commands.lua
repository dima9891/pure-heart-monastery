local commands = {}

commands.help = function()
    print("Доступные команды: ")
    print("stats")
    print("look")
    print("move north")
    print("move south")
    print("help")
    print("quit")
end

commands.stats = function(player)
    print("Name: " .. player.name)
    print("Class: " .. player.class)
    print("HP: " .. player.hp)
    print("Attack: " .. player.attack)
end

commands.look = function(player)
    local room = player.room

    print(room.name)
    print(room.description)

    print("\nВыходы:")

    if room.north then
        print("- north")
    end

    if room.south then
        print("- south")
    end
end

commands.move = function(player, direction)
    local destination = player.room[direction]

    if destination then
        player.room = destination
        print("Ты идешь " .. direction)
        commands.look(player)
    else
        print("Ты не можешь туда пойти")
    end
end

return commands
