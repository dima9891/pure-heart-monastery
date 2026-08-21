local npc = require('data.npc.npc');
local items = require('data.item.item');
local monster = require('data.monster.monster');

local rooms = {
    entrance = {
        id = 'entrance',
        name = "Вход в подземелье",
        description = "Темные каменные ступени ведут в холодную влажную тьму.",
    },
    hall = {
        id = 'hall',
        name = "Большой зал",
        description = "Большой гулкий пустой зал слегка освещаемый свечами возле одной из стен",
    },
    pit = {
        id = 'pit',
        name = "Яма",
        description = "По краю ямы спускается старая лестница. Она ведет в темные глубины",
    },
    pitBottom = {
        id = 'pitBottom',
        name = "Дно ямы",
        description = "На дне ямы лежат скелеты бедняг, которые здесь погибли",
    },
    crypt = {
        id = 'crypt',
        name = "Крипта",
        description = "Место упокоения, здесь в каменных гробах лежат тела монахов",
    }
}

--[[
    entrance
    |
    hall - pit
    |       |
    crypt  pit-bottom
]]-- 

rooms.entrance.south = rooms.hall

rooms.hall.north = rooms.entrance
rooms.hall.south = rooms.crypt
rooms.hall.east = rooms.pit

rooms.pit.west = rooms.hall
rooms.pit.south = rooms.pitBottom

rooms.pitBottom.north = rooms.pit

rooms.crypt.north = rooms.hall

rooms.hall.items = {
    items.sword,
    items.torch
}

rooms.hall.npc = {
    npc.toma
}

rooms.pitBottom.monster = {
    monster.skelet,
    monster.skelet,
    monster.skelet
}

return rooms