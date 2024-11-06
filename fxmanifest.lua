fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '_Mequ_'
description 'Skrypt na wpożyczalnie łódek https://github.com/Mequ0/mequ_boatrental/'

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target'
}

client_scripts {
    'client.lua',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

server_scripts {
    'server.lua'
}

