package = "rpg"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/dima9891/pure-heart-monastery.git"
}
description = {
   summary = "Этот опустевший монастырь буквально вырублен в скале и нависает над всеми путниками, которые проходят мимо.",
   detailed = "Этот опустевший монастырь буквально вырублен в скале и нависает над всеми путниками, которые проходят мимо. К нему ведет узкая каменистая тропа, заросшая чертополохом и душистыми травами.",
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
dependencies = {
   "lua >= 5.5",
   "json.lua"
}
build = {
   type = "builtin",
   modules = {
      class = "data/class/class.lua",
      commands = "commands.lua",
      main = "main.lua",
      monster = "data/monster/monster.lua"
      room = "data/room/room.lua"
   }
}
