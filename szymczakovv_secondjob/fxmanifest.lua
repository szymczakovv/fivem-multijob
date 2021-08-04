fx_version "bodacious"
games {"gta5"}
lua54 'yes'
author 'szymczakovv#1937'
description 'Multi Job System'

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}