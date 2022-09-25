---discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)

-- Genereate Plate

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local pass = true
	
	while pass do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		
		generatedPlate = string.upper(GetRandomLetter(3) .. ' ' .. GetRandomNumber(4))
		
		MySQL.Async.fetchScalar('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
			['@plate'] = generatedPlate
		}, function (result)			
			if result == nil then
				pass = false
			end
		end)
	end

	return generatedPlate
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	
	math.randomseed(os.time())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	
	math.randomseed(os.time())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end
--- discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks

Cases = {
	['przemyt'] = {
		{ name = 'bandage', count = {1, 2}, type = 'item', label = 'BANDAŻ', desc = 'ZWYKŁY', color = 'blue' },
        { name = 'ammo-9', count = {25, 50}, type = 'item', label = 'PISTOL AMMO', desc = 'ZWYKŁY', color = 'blue' },
        { name = 'scratchplus', count = {1, 2}, type = 'item', label = 'ZDRAPKA PLUS', desc = 'RZADKI', color = 'violet' },
        { name = 'weed', count = {1, 5}, type = 'item', label = 'GRAM MARICHUANY', desc = 'RZADKI', color = 'violet' },
        { name = 'WEAPON_MOLOTOV', count = {1, 2}, type = 'item', label = 'MOLOTOV', desc = 'ZABYTKOWY', color = 'pink' },
        { name = 'money', count = {30000, 50000}, type = 'money', label = 'GOTÓWKA', desc = 'ZABYTKOWY', color = 'pink' },
        { name = 'WEAPON_REVOLVER', count = {1, 1}, type = 'item', label = 'REVOLVER', desc = 'MITYCZNY', color = 'red' },
        { name = 'c7', type = 'car', label = 'BON - CHEVROLET CORVETTE C7', desc = 'LEGENDARNY', color = 'gold' },
	},
}
for name, data in pairs(Cases) do
	if name ~= nil and data ~= nil then
		ESX.RegisterUsableItem(name, function(source)
			local _source = source
			
			if _source ~= nil then
				local xPlayer = ESX.GetPlayerFromId(_source)
				
				if xPlayer ~= nil then
					TriggerClientEvent('esx_cases:openCase', _source, name, data, xPlayer.getInventoryItem(name).count)
				end
			end
		end)
	end
end
--- discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks discord.gg/redleaks

ESX.RegisterServerCallback('esx_cases:rollCase', function(source, cb, name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if name ~= nil and xPlayer ~= nil then
		if Cases[name] ~= nil then	
			local itemData = xPlayer.getInventoryItem(name)
			
			if itemData ~= nil and itemData.count > 0 then
				local rand = math.random(1, #Cases[name])
				
				if rand ~= nil then
					local item = Cases[name][rand]
					
					if item ~= nil then
						xPlayer.removeInventoryItem(name, 1)
						
						if item.type == 'item' then
							local count = math.random(item.count[1], item.count[2])
							
							if count ~= nil and xPlayer.canCarryItem(item.name, count) then
								xPlayer.addInventoryItem(item.name, count)
							end
						elseif item.type == 'money' then
							local count = math.random(item.count[1], item.count[2])
							
							if count ~= nil then
								xPlayer.addMoney(count)

							end
						elseif item.type == 'weapon' then
							local ammo = math.random(item.ammo[1], item.ammo[2])
							
							if ammo ~= nil then
								xPlayer.addInventoryWeapon(item.name,1, 100, true)
							end
						elseif item.type == 'car' then	
							local tablice = GeneratePlate()
							local DefaultProp = {
								model = GetHashKey(item.name), 
								plate = tablice, 
								name = string.upper(item.name),
								
								modHydrolic = -1, 
								modPlateHolder = -1,
								modBackWheelsCustom = false,
								modAPlate = -1,
								modSuspension = -1,
								modHood = -1,
								modSpeakers = -1,
								tyreSmokeColor = {255, 255, 255},
								neonEnabled = {false, false, false, false},
								modFender = -1,
								dirtLevel = 1.0,
								model = GetHashKey(item.name),
								modSmokeEnabled = false,
								modXenon = false,
								modXenonColor = 255,
								modLiveryVariant = -1,
								modBackWheels = -1,
								modEngine = -1,
								modStruts = -1,
								modAerials = -1,
								modShifterLeavers = -1,
								modSpoilers = -1,
								modVanityPlate = -1,
								doors = {},
								oilLevel = 5.0,
								extras = {},
								modArmor = -1,
								modDashboard = -1,
								modWindows = -1,
								modFrontWheelsCustom = false,
								wheelColor = 156,
								plate = tablice,
								color1 = 7,
								modFrontWheels = -1,
								bulletProofTyre = false,
								modSideSkirt = -1,
								neonColor = {255, 0, 255},
								modExhaust = -1,
								modTank = -1,
								modDial = -1,
								modFrame = -1,
								pearlescentColor = 4,
								modRightFender = -1,
								plateIndex = 0,
								dashboardColor = 0,
								modBrakes = -1,
								modHydrolic = -1,
								modSteeringWheel = -1,
								modArchCover = -1,
								windowTint = -1,
								modTrunk = -1,
								modTurbo = false,
								color2 = 0,
								tankHealth = 1000.00,
								health = 1000,
								modGrille = -1,
								modOrnaments = -1,
								modSeats = -1,
								modTransmission = -1,
								modRoof = -1,
								interiorColor = 0,
								modTrimA = -1,
								bodyHealth = 1000.00,
								modTrimB = -1,
								modEngineBlock = -1,
								engineHealth = 1000.00,
								wheels = 0,
								modAirFilter = -1,
								modLivery = -1,
								name = string.upper(item.name),
								modRearBumper = -1,
								modFrontBumper = -1,
								modHorns = -1,
								tyres = {},
								windows = {1,2,3,4,5,6,7,8,9,10,11,12,13}
							}			
							MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, digit, state, type) VALUES (@owner, @plate, @vehicle, @digit, @state, @type)',{								['@owner']  = xPlayer.identifier,
								['@owner']  = xPlayer.identifier,
								['@plate'] = DefaultProp.plate,
								['@vehicle'] = json.encode(DefaultProp),
								['@digit'] = xPlayer.getDigit(),
								['@state'] = 'stored',
								['@type'] = 'car',
							})		
						end
						
						cb(rand)
					else
						cb(nil)
					end
				else
					cb(nil)
				end
			else
				cb(nil)
			end
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)