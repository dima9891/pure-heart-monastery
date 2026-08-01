local PlayerFactory = require("playerFactory")
local rooms = require("rooms")
local commands = {}

commands.help = function()
    print("Доступные команды: ")
    print("stats")
    print("look")
    print("move north")
    print("move south")
    print("move east")
    print("move west")
    print("take")
    print("inventory")
    print("talk")
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
    print(player.room)
    local room = rooms[player.room]
    local function showAll(type, msg)
        if room[type] == nil then
            return
        end
        print(msg)
        for index, item in ipairs(room[type]) do
            print(index, item.name)
        end
    end

    print(room.name)
    print(room.description)
    showAll('items', "В комнате есть следующие предметы:")
    showAll('npc', "В комнате находятся:")

    print("\nВыходы:")

    if room.north then
        print("- north")
    end

    if room.south then
        print("- south")
    end

    if room.east then
        print("- east")
    end

    if room.west then
        print("- west")
    end
end

commands.talk = function(player, npcIndex)
    local room = rooms[player.room]

    if not room.npc then
        print("В комнате никого нет")
        return
    end

    npcIndex = tonumber(npcIndex)
    local npc = room.npc[npcIndex]

    print(npc.description)

end

commands.take = function(player, itemIndex)
    local room = rooms[player.room]

    if not room.items then
        print("В комнате ничего нет")
        return
    end
    itemIndex = tonumber(itemIndex)

    if not itemIndex then
        print("Укажи номер предмета")
        return
    end

    local item = room.items[itemIndex]

    if not item then
        print("Такого предмета нет")
        return
    end

    table.insert(player.inventory, item)
    table.remove(room.items, itemIndex)

    print("Ты подобрал: " .. item)
end

commands.inventory = function(player)
    for index, item in ipairs(player.inventory) do
        print(index, item)
    end
end

commands.move = function(player, direction)
    local destination = rooms[player.room][direction]

    if destination then
        player.room = destination.id
        commands.look(player)
    else
        print("Ты не можешь туда пойти")
    end
end

commands.save = function(player)
    PlayerFactory.save(player)
end

return commands
