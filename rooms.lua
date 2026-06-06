local rooms = {
    entrance = {
        name = "Вход в подземелье",
        description = "Темные каменные ступени ведут в холодную влажную тьму.",
    },
    hall = {
        name = "Большой зал",
        description = "Большой гулкий пустой зал слегка освещаемый свечами возле одной из стен",
    },
    crypt = {
        name = "Крипта",
        description = "Место упокоения, здесь в каменных гробах лежат тела монахов",
    }
}

rooms.entrance.south = rooms.hall

rooms.hall.north = rooms.entrance
rooms.hall.south = rooms.crypt

rooms.crypt.north = rooms.hall

return rooms