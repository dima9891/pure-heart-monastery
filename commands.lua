local PlayerFactory = require("playerFactory")
---@type table
local rooms = require("data.room.room")
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
    print("equip")
    print("inventory")
    print("talk")
    print("attack")
    print("help")
    print("quit")
end

---@param player Player
commands.stats = function(player)
    print("Name: " .. player.name)
    print("Class: " .. player.class)
    print("Health Point: " .. player.hp)
    print("Strength: " .. player.str)
    print("Dextreity: " .. player.dex)
    print("Will: " .. player.will)
    print("Experience Points: " .. player.exp)
    print("Level: " .. player.lvl)
end

---@param player Player
commands.look = function(player)
    print(player.room)

    ---@type table
    local room = rooms[player.room]

    ---@param type string
    ---@param msg string
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
    showAll('monster', "В комнате вас поджидают")

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

---@param element? table
---@param number? integer
---@param msg table<string, string>
---@return boolean
function CanInteract(element, number, msg)
    if not element then
        print(msg.noEl)
        return false
    end

    if not number then
        print(msg.noNumber)
        return false
    end

    if not element[number] then
        print(msg.wrongNumber)
        return false
    end

    return true
end

---@param player Player
---@param npcIndex string
commands.talk = function(player, npcIndex)
    local room = rooms[player.room]
    local msg = {
        noEl = "В комнате никого нет",
        noNumber = "Укажи номер персонажа",
        wrongNumber = "Такого персонажа нет"
    }

    local function dialogLoop(dialog)
        local current = 'greeting'

        ---@param line string
        ---@return nil
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

    local n = tonumber(npcIndex)

    if CanInteract(room.npc, n, msg) == false then
        return
    end

    local npc = room.npc[n]
    print(npc.description)
    dialogLoop(npc.dialog)
end

---@param player Player
---@param itemIndex string
commands.take = function(player, itemIndex)
    local room = rooms[player.room]
    local msg = {
        noEl = "В комнате ничего нет",
        noNumber = "Укажи номер предмета",
        wrongNumber = "Такого предмета нет"
    }

    local i = tonumber(itemIndex)

    if CanInteract(room.items, i, msg) == false then
        return
    end

    local item = room.items[i]

    table.insert(player.inventory, item)
    table.remove(room.items, i)

    print("Ты подобрал: " .. item.name)
end

---@param player Player
---@param index string
commands.attack = function(player, index)
    local room = rooms[player.room]
    local msg = {
        noEl = "В комнате никого нет",
        noNumber = "Укажи номер монстра",
        wrongNumber = "Такого монстра нет"
    }

    local n = tonumber(index)

    if CanInteract(room.monster, n, msg) == false then
        return
    end

    print('Команда a чтобы атаковать')
    print('Команда p чтобы помолиться')

    local monster = room.monster[n]
    local monsterHP = monster.hp

    print('Перед вами ' .. monster.name)
    print(monster.description)

    local monsterHit = function()
        local hit = math.random(0, monster.attack)
        print(monster.name .. ' атакует вас с силой ' .. hit)
        player.hp = player.hp - hit
        print('Ваше текущее здоровье: ' .. player.hp)
    end

    local playerHit = function()
        local hit = 1
        if player.equip then
            hit = math.random(1, player.equip.attack)
        end
        monsterHP = monsterHP - hit
        print('Вы атакуете ' .. monster.name .. ' с силой ' .. hit)
    end

    while monsterHP > 0 do
        io.write("+> ")
        local playerMaxHP = player.hp

        local input = io.read()

        if input == 'a' then
            playerHit()
            monsterHit()
        elseif input == 'p' then
            print('Вы молитесь и получаете благословение')
            if player.hp < playerMaxHP then
                player.hp = player.hp + 1
            end
            monsterHit()
        else
            print('Неизвестная команда')
        end

        if monsterHP <= 0 then
            print(monster.name .. ' повержен')
            player.exp = player.exp + monster.expPoints
            break
        end

        if player.hp <= 0 then
            print('Вы умерли')
            break
        end
    end

    table.remove(room.monster, n)
end

---@param player Player
commands.inventory = function(player)
    for index, item in ipairs(player.inventory) do
        print(index, item.name)
    end

    if player.equip then
        print('Экипирован ' .. player.equip.name)
    end
end

---@param player Player
---@param index string
commands.equip = function(player, index)
    local i = tonumber(index)
    local item = player.inventory[i]

    if not item then
        print('Такого предмета в инвентаре нет')
        return
    end

    if item.equip == false then
        print('Предмет нельзя экипировать')
        return
    end

    if player.equip then
        table.insert(player.inventory, player.equip)
    end

    player.equip = item
    table.remove(player.inventory, i)
    print('Экипирован ' .. player.equip.name)
end

---@param player Player
---@param direction string
commands.move = function(player, direction)
    local destination = rooms[player.room][direction]

    if destination then
        player.room = destination.id
        commands.look(player)
    else
        print("Ты не можешь туда пойти")
    end
end

---@param player Player
commands.save = function(player)
    PlayerFactory.save(player)
end

return commands
