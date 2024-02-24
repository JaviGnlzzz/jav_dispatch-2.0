fx_version 'cerulean'

games { 'gta5' }

author 'Javi'

lua54 'yes'

client_scripts {
    'client/**.lua'
}

server_scripts {
    'server/*.lua'
}

shared_scripts {
    'shared/*.lua',
    'locales/*.lua',
}

ui_page {
    'web/index.html'
}

files {
    'web/**/**/*.*'
}