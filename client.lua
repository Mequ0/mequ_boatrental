local npcPed = nil
local respawnLodkiCoords = vector4(-858.8272, -1327.9170, 1.9813, 109.5666)
local radiusRespawnu = 10.0
local czyWypozyczonoLodke = false
local wypozyczonaLodka = nil
local cenaWypozyczonejLodki = 0

Citizen.CreateThread(function()
    local model = GetHashKey(Config.Ped.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    npcPed = CreatePed(4, model, Config.Ped.coords.x, Config.Ped.coords.y, Config.Ped.coords.z, Config.Ped.coords.w, false, true)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
    
    exports.ox_target:addLocalEntity(npcPed, {
        {
            label = 'Wynajmij łódkę',
            icon = 'fa-solid fa-ship',
            onSelect = function()
                otworzMenuLodek()
            end,
        },
        {
            label = 'Zwróć łódkę',
            icon = 'fa-solid fa-ship',
            onSelect = function()
                zwrocLodke()
            end
        }
    })

    local blip = AddBlipForCoord(Config.Blip.coords)
    SetBlipSprite(blip, Config.Blip.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, Config.Blip.scale)
    SetBlipColour(blip, Config.Blip.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blip.label)
    EndTextCommandSetBlipName(blip)
end)

function otworzMenuLodek()
    local options = {}

    for i, lodka in ipairs(Config.Lodki) do
        table.insert(options, {
            title = lodka.label,
            description = 'Koszt wynajmu: $'..lodka.cena,
            icon = 'fa-solid fa-ship',
            image = lodka.image,
            onSelect = function()
                if miejsceRespawnuZajete() then
                    lib.notify({description = 'Miejsce spawnu łódki jest zajęte!'})
                    return
                end
                if czyWypozyczonoLodke then
                    lib.notify({description = 'Masz już wynajętą łódkę!'})
                    return
                end

                ESX.TriggerServerCallback('mequ_rental:wynajmijlodke', function(success)
                    if success then
                        wynajmijLodke(lodka.model, lodka.cena)
                    else
                        lib.notify({description = 'Nie masz wystarczającej ilości pieniędzy! Koszt wynajmu to $'..lodka.cena})
                    end
                end, lodka.cena)
            end
        })
    end

    lib.registerContext({
        id = 'menu_wypozyczalni_lodek',
        title = 'Wypożyczalnia łódek',
        options = options
    })
    lib.showContext('menu_wypozyczalni_lodek')
end

function wynajmijLodke(modelLodki, cenaLodki)
    local vehicleModel = GetHashKey(modelLodki)
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        Wait(10)
    end
    wypozyczonaLodka = CreateVehicle(vehicleModel, respawnLodkiCoords.x, respawnLodkiCoords.y, respawnLodkiCoords.z, respawnLodkiCoords.w, true, false)
    
    local plate = GetVehicleNumberPlateText(wypozyczonaLodka)
    -- exports['mequ_carkeys']:AddKey(plate)
    -- Jeśli posiadasz skrypt na kluczyki dodaj tu export
    
    czyWypozyczonoLodke = true
    cenaWypozyczonejLodki = cenaLodki
    TriggerServerEvent('mequ_rental:wynajmijlodke', cenaLodki)

    lib.notify({description = 'Wynająłeś łódkę za $'..cenaLodki})

end

function miejsceRespawnuZajete()
    local vehicles = CzyLodkaJestWPunkcie(respawnLodkiCoords, radiusRespawnu)
    return #vehicles > 0
end

function czyLodkaWZasiegu()
    local nearbyBoats = CzyLodkaJestWPunkcie(respawnLodkiCoords, radiusRespawnu)
    for _, lodka in ipairs(nearbyBoats) do
        if lodka == wypozyczonaLodka then
            return true
        end
    end
    return false
end



function zwrocLodke()
    if not czyWypozyczonoLodke then
        lib.notify({description = 'Nie wynająłeś żadnej łódki!'})
        return
    end
    
    if not czyLodkaWZasiegu() then
        lib.notify({description = 'Nie znaleziono łódki w pobliżu miejsca zwrotu!'})
        return
    end

    local zwrot = math.floor(cenaWypozyczonejLodki * Config.ZwrotProcent)

    DeleteVehicle(wypozyczonaLodka)
    local plate = GetVehicleNumberPlateText(wypozyczonaLodka)
    -- exports['mequ_carkeys']:RemoveKey(plate)
    -- Jeśli posiadasz skrypt na kluczyki dodaj tu export
    
    wypozyczonaLodka = nil
    czyWypozyczonoLodke = false
    cenaWypozyczonejLodki = 0

    TriggerServerEvent('mequ_rental:zwrotlodki', zwrot)

end


function CzyLodkaJestWPunkcie(coords, radius)
    local vehicles = GetGamePool('CVehicle')
    local nearbyVehicles = {}
    for _, vehicle in ipairs(vehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = Vdist(coords.x, coords.y, coords.z, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
        if distance <= radius then
            table.insert(nearbyVehicles, vehicle)
        end
    end
    return nearbyVehicles
end
