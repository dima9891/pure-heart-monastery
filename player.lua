local classes = require("classes")
local rooms = require("rooms")

local player = {}

function player.createCharacter()
    print("Введите ваше имя:")
    local name = io.read()

    local choice

    repeat
        print("Выберите класс:")
        print("1. Воин")
        print("2. Плут")
        print("3. Волшебник")

        choice = io.read()
    until classes[choice]

    local selectedClass = classes[choice]

    return {
        name = name,
        class = selectedClass.class,
        hp = selectedClass.hp,
        attack = selectedClass.attack,
        room = rooms.entrance
    }
end

return player