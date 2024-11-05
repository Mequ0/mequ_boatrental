ESX.RegisterServerCallback('mequ_rental:wynajmijlodke', function(source, cb, zwrotlodki)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    local hajs = exports.ox_inventory:GetItem(source, 'money', nil, true)
    
    if hajs >= zwrotlodki then
        exports.ox_inventory:RemoveItem(source, 'money', zwrotlodki)
        cb(true)  
    else
        cb(false) 
    end
end)

local wynajeteLodki = {}

RegisterNetEvent('mequ_rental:zwrotlodki')
AddEventHandler('mequ_rental:zwrotlodki', function(kwotaZwrotu)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if not wynajeteLodki[_source] then
        TriggerClientEvent('lib.notify', _source, {description = 'Nie wynająłeś żadnej łódki!'})
        return
    end

    if wynajeteLodki[_source].zwrocona then
        TriggerClientEvent('lib.notify', _source, {description = 'Łódka została już zwrócona!'})
        return
    end

    local expectedZwrot = math.floor(wynajeteLodki[_source].cena * Config.ZwrotProcent)
    if kwotaZwrotu ~= expectedZwrot then
        TriggerClientEvent('lib.notify', _source, {description = 'Nieprawidłowa kwota zwrotu!'})
        return
    end

    exports.ox_inventory:AddItem(source, 'money', kwotaZwrotu)

    wynajeteLodki[_source].zwrocona = true

    TriggerClientEvent('lib.notify', _source, {description = 'Zwrócono łódkę i otrzymałeś $'..kwotaZwrotu})
end)


RegisterNetEvent('mequ_rental:wynajmijlodke')
AddEventHandler('mequ_rental:wynajmijlodke', function(cenaLodki)
    local _source = source
    wynajeteLodki[_source] = {cena = cenaLodki, zwrocona = false}
end)