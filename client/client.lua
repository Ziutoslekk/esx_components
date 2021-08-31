Citizen.CreateThread(function()
    while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while true do
		if not IsPedSittingInAnyVehicle(PlayerPedId()) then
			if IsControlJustPressed(0, 74) then
				OpenComponentsMenu()
			end
		else
			Citizen.Wait(250)
		end

		Citizen.Wait(0)
	end
end)

OpenComponentsMenu = function()
	local weapon = GetSelectedPedWeapon(PlayerPedId())

	if Config.Components[weapon] then
		local elements = {}

		for k,v in pairs(Config.Components[weapon]) do
			if Config.Locales[k] then
				table.insert(elements, {
					label = Config.Locales[k],
					value = k
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_components', {
			title    = Config.Components[weapon].label,
			align    = 'right',
			elements = elements
		}, function(data, menu)
			AttachComponent(weapon, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	else
		if weapon == `weapon_unarmed` then
			ESX.ShowNotification("~r~Wybierz model broń do której chcesz zamontować dodatek.")
		else
			ESX.ShowNotification("~r~Aktualny model broni nie posiada dodatków.")
		end
	end
end

AttachComponent = function(weaponHash, componentType)
	if Config.Components[weaponHash] then
		if Config.Components[weaponHash][componentType] then
			if DoesWeaponTakeWeaponComponent(weaponHash, Config.Components[weaponHash][componentType]) then
				if not HasPedGotWeaponComponent(PlayerPedId(), weaponHash, Config.Components[weaponHash][componentType]) then
					GiveWeaponComponentToPed(PlayerPedId(), weaponHash, Config.Components[weaponHash][componentType])
					ESX.ShowNotification("~g~Zamontowałeś dodatek.")    
				else 
					RemoveWeaponComponentFromPed(PlayerPedId(), weaponHash, Config.Components[weaponHash][componentType])
					ESX.ShowNotification("~r~Zdjąłeś dodatek.")
				end
			else
				ESX.ShowNotification("~r~Ten dodatek nie pasuje do tej broni!")
			end
		else
			ESX.ShowNotification("~r~Aktualny model broni nie posiada tego dodatku.")
		end
	else
		if weaponHash == `weapon_unarmed` then
			ESX.ShowNotification("~r~Wybierz model broń do której chcesz zamontować dodatek.")
		else
			ESX.ShowNotification("~r~Aktualny model broni nie posiada dodatków.")
		end
	end
end