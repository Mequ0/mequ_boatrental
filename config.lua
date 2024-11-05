-- Jeśli posiadasz skrypt na kluczyki możesz dodać export w client.lua: 94, 138

Config = {}

Config.Lodki = { -- Łodki które będą widoczne w menu
    {label = 'Dinghy', model = 'dinghy2', cena = 10000, image = 'https://r2.fivemanage.com/5THhxQauna8FJ4GzBHBD7/images/800px-Dinghy2.png'},
    {label = 'Toro', model = 'toro2', cena = 15000, image = 'https://r2.fivemanage.com/5THhxQauna8FJ4GzBHBD7/images/800px-Toro2.png'},
    {label = 'Tropic', model = 'tropic2', cena = 5000, image = 'https://r2.fivemanage.com/5THhxQauna8FJ4GzBHBD7/images/800px-Tropic2.png'},
}

Config.Blip = { -- Miejsce Blipa
    coords = vector3(-864.6467, -1325.0128, 0.6052),
    sprite = 427,
    color = 3,
    scale = 0.8,
    label = "Wypożyczalnia Łódek"
}

Config.Ped = { -- Ustawienie Peda
    coords = vector4(-864.6467, -1325.0128, 0.6052, 290.8842),
    model = "cs_floyd"
}

Config.ZwrotProcent = 0.75 -- Procent zwrotu za łódkę