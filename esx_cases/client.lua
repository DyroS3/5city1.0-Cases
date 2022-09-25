--- discord.gg/redleaks  discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks
--- discord.gg/redleaks  discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks 
--- discord.gg/redleaks  discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks
--- discord.gg/redleaks  discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks 
--- discord.gg/redleaks  discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks
--- discord.gg/redleaks  discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks 
ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj 
		end)
		
        Citizen.Wait(250)
    end
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false, false)
	
	if cb then
		cb(true)
	end
end)

RegisterNUICallback('openCase', function(data, cb)
	if data ~= nil and data.name ~= nil then
		ESX.TriggerServerCallback('esx_cases:rollCase', function(key) 
			if key ~= nil then
				cb({ itemKey = key })
			else
				cb({error = true})
			end
		end, data.name)
	else
		cb({error = true})
	end
end)

RegisterNetEvent('esx_cases:openCase')
AddEventHandler('esx_cases:openCase', function(name, items, count)
	if name ~= nil and count ~= nil and items ~= nil then
		SetNuiFocus(true, true)
		SendNUIMessage({
			type = 'toggle',
			name = name,
			cases = count,
			items = items
		}) 	
		ESX.TriggerServerCallback('esx_cases:rollCase', function(key) 
		end)
	end
end)

