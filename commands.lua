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

function CanInteract(object, element, number, msg)
    if not object[element] then
        print(msg.noEl)
        return false
    end

    number = tonumber(number)

    if not number then
        print(msg.noNumber)
        return false
    end

    if not object[element][number] then
        print(msg.wrongNumber)
        return false
    end

    return true
end

commands.talk = function(player, npcIndex)
    local room = rooms[player.room]
    local msg = {
        noEL = "В комнате никого нет",
        noNumber = "Укажи номер персонажа",
        wrongNumber = "Такого персонажа нет"
    }

    local function dialogLoop(dialog)
        local current = 'greeting'

        local function dprint(line)
            print('- ' .. line)
        end

        local function printAnswers(speechline)
            if speechline.answers == nil then
                dprint(dialog.bye.line)
                return
            end
            for index, item in ipairs(speechline.answers) do
                print(index, item.line)
            end
        end

        dprint(dialog[current].line)
        printAnswers(dialog[current])

        while true do
            if dialog[current].answers == nil then
                break
            end

            io.write(">> ")

            local input = io.read()

            if input == "bye" then
                printAnswers(dialog.bye)
                break
            end

            local variant = tonumber(input)

            if dialog[current].answers[variant] then
                local nextId = dialog[current].answers[variant].next
                if nextId == nil then
                    break
                end

                current = nextId
                dprint(dialog[current].line)
                printAnswers(dialog[current])
            else
                print("Неизвестная команда")
            end
        end
    end

    if CanInteract(room, 'npc', npcIndex, msg) == false then
        return
    end

    npcIndex = tonumber(npcIndex)
    local npc = room.npc[npcIndex]
    print(npc.description)
    dialogLoop(npc.dialog)
end

commands.take = function(player, itemIndex)
    local room = rooms[player.room]
    local msg = {
        noEL = "В комнате ничего нет",
        noNumber = "Укажи номер предмета",
        wrongNumber = "Такого предмета нет"
    }

    if CanInteract(room, 'items', itemIndex, msg) == false then
        return
    end

    itemIndex = tonumber(itemIndex)
    local item = room.items[itemIndex]

    table.insert(player.inventory, item)
    table.remove(room.items, itemIndex)

    print("Ты подобрал: " .. item.name)
end

commands.inventory = function(player)
    for index, item in ipairs(player.inventory) do
        print(index, item.name)
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
