RegisterCommand('drop', function()

	local ped = GetPlayerPed(-1)
	local wep = GetSelectedPedWeapon(ped)
	SetPedDropsInventoryWeapon(ped, wep, 1.5, 2.0, 0, -1) -- Drop weapon from the Chords set. 
	GiveWeaponToPed(ped, 0xA2719263, 0, 0, 1)

end, false)


Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1)

		if IsPedRagdoll(GetPlayerPed(-1,true)) then
			Citizen.Wait(1)

			local ped = GetPlayerPed(-1)
			local wep = GetSelectedPedWeapon(ped)
			local intChance = math.random(1,10) -- Calculating random chance

			if intChance > 3 then
				if(IsPedStill(ped)) then
					--print("Still")
					posX = 2.0
					posY = 0
					posZ = -1
				elseif(IsPedWalking(ped)) then
					--print("Walking")
					posX = 3.0
					posY = 0
					posZ = -1
				elseif(IsPedRunning(ped)) or (IsPedSprinting(ped)) then
					--print("Running/Sprinting")
					posX = 5.0
					posY = 0
					posZ = -1
				else
					posX = 3.0
					posY = 0
					posZ = -1
				end

				SetPedDropsInventoryWeapon(ped, wep, 0, posX, posY, posZ) -- Drop weapon from the Chords set. 
				GiveWeaponToPed(ped, 0xA2719263, 0, 0, 1)
			end
		end
	end
end)


Citizen.CreateThread(function()

	local e_key = 103

	while true do
		local pedArmed = IsPedArmed(PlayerPedId(), 5)
		Citizen.Wait(1)

		if IsControlJustReleased(1,  e_key) and pedArmed == 1 then

		local coords = GetEntityCoords(PlayerPedId())
		local closestVehicle, distance, closestBone, boneDist = -1, 9999, -1, 9999
		local vehTable = GetGamePool('CVehicle')

		local boneArray = {"window_lf", "window_lr","window_rf","window_rr"}

		for i = 1, #vehTable do
			local veh = vehTable[i]
			local dist = #(GetEntityCoords(veh)- coords)
			if closestVehicle == -1 or dist  < distance then
				closestVehicle = veh
				distance = dist
			end 
		end

		for x = 1, #boneArray do

			local bone = boneArray[x]
			local boneIndex = GetEntityBoneIndexByName(closestVehicle, boneArray[x])
			local vehBoneloc = #(GetWorldPositionOfEntityBone(closestVehicle, boneIndex)- coords)  --https://docs.fivem.net/natives/?_0x44A8FCB8ED227738
			-- https://docs.fivem.net/natives/?_0xFB71170B7E76ACBA

			if vehBoneloc < 1.0 then
				if bone == "window_lf" then SmashVehicleWindow(closestVehicle, 0) print("Broken window_lf") Citizen.Wait(2) break
				elseif bone == "window_lr" then SmashVehicleWindow(closestVehicle, 2) print("Broken window_lr") Citizen.Wait(2) break
				elseif bone == "window_rf" then SmashVehicleWindow(closestVehicle, 1) print("Broken window_rf") Citizen.Wait(2) break
				elseif bone == "window_rr" then SmashVehicleWindow(closestVehicle, 3) print("Broken window_rr") Citizen.Wait(2)  break
				else SmashVehicleWindow(closestVehicle, 4)  Citizen.Wait(2) break
				end
			end

			local pid = PlayerPedId()
			RequestAnimDict("melee")
			RequestAnimDict("melee@rifle")
			RequestAnimDict("melee@rifle@player_front_takedown_kill")
		
			while (not HasAnimDictLoaded("melee@rifle@streamed_core")) do Citizen.Wait(0) end
			
			TaskPlayAnim(pid,"melee@rifle@streamed_core","rifle_aim_whip",1.0,-1.0, 5000, 0, 1, true, true, true)
		
		
			print("anim")
		end	
	  end
	end
end)
