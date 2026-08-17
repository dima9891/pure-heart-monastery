local json = require("json")
local classes = require("data.class.class")

local player = {}

function player.loadOrCreate()
    local choice

    repeat
        print("Выберите new или load чтобы загрузить персонажа")
        choice = io.read()
    until choice == "new" or choice == "load"

    if choice == 'load' then
        return player.load()
    end

    if choice == 'new' then
        return player.createCharacter()
    end
end

function player.createCharacter()
    print("Введите ваше имя:")
    local name = io.read()

    local choice

    repeat
        print("Выберите класс:")

        for index, class in pairs(classes) do
            print(index .. ') ' .. class.class)
        end

        choice = io.read()
    until classes[choice]

    local selectedClass = classes[choice]

    return {
        name = name,
        class = selectedClass.class,
        hp = selectedClass.hp,
        attack = selectedClass.attack,
        room = 'entrance',
        inventory = {}
    }
end

function player.load()
    local file, err = io.open("save.json", "r")

    if not file then
        error("Could not open file: " .. tostring(err))
        return
    end

    local content = file:read("*all")

    file:close()
    return json.decode(content)
end

function player.save(playerTable)
    local file = assert(io.open("save.json", "w"))
    file:write(json.encode(playerTable))
    file:close()
    print("Сохранено")
end

return player
