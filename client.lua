--[[
		Smashes Vehicle Windows Indefinitly on a Press of a Button
			Script Made by Welshy
			Animation Made by Jude
			For Release in Sinners Modshop
		Script V1.0
]]--

RegisterNetEvent("firearmsEnhance:syncWindows")
AddEventHandler("firearmsEnhance:syncWindows", function(closestVehicle, bone)

	if bone == "window_lf" then SmashVehicleWindow(closestVehicle, 0) print("Broken window_lf") Citizen.Wait(2) 
	elseif bone == "window_lr" then SmashVehicleWindow(closestVehicle, 2) print("Broken window_lr") Citizen.Wait(2) 
	elseif bone == "window_rf" then SmashVehicleWindow(closestVehicle, 1) print("Broken window_rf") Citizen.Wait(2) 
	elseif bone == "window_rr" then SmashVehicleWindow(closestVehicle, 3) print("Broken window_rr") Citizen.Wait(2)  
	elseif bone == "windscreen" then SmashVehicleWindow(closestVehicle, -1) Citizen.Wait(2)
	elseif bone == "windscreen_r" then SmashVehicleWindow(closestVehicle, 22) Citizen.Wait(2)  
	else SmashVehicleWindow(closestVehicle, 4)  Citizen.Wait(2) end	


end)

Citizen.CreateThread(function()

	local e_key = 103

	while true do
		local pedArmed = IsPedArmed(PlayerPedId(), 5)
		Citizen.Wait(2)

		if IsControlJustReleased(1,  e_key) and pedArmed == 1 then

			local coords = GetEntityCoords(PlayerPedId())
			local closestVehicle, distance, closestBone, boneDist = -1, 9999, -1, 9999
			local vehTable = GetGamePool('CVehicle')

			local boneArray = {"window_lf", "window_lr","window_rf","window_rr","windscreen","windscreen_r"}

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

				local windowViable = 0

				if bone == "window_lf" then SmashVehicleWindow(closestVehicle, 0) print("Broken window_lf") Citizen.Wait(2) 
				elseif bone == "window_lr" then windowVialbe = 2
				elseif bone == "window_rf" then windowVialbe = 1 
				elseif bone == "window_rr" then  windowVialbe = 3  
				elseif bone == "windscreen" then  windowVialbe = -1
				elseif bone == "windscreen_r" then windowVialbe = 22
				else  windowVialbe = 4 end

				if IsVehicleWindowIntact(closestVehicle, windowVialbe) then
					anim(PlayerPedId())
					TriggerServerEvent("firearmsEnhance:updateWindows", closestVehicle, bone)

					Citizen.Wait(2)
				end
			end
		end
	  end
	end
end)

function anim(pid)
			RequestAnimDict("melee")
			RequestAnimDict("melee@rifle")
			RequestAnimDict("melee@rifle@player_front_takedown_kill")
			while (not HasAnimDictLoaded("melee@rifle@streamed_core")) do Citizen.Wait(0) end
			TaskPlayAnim(pid,"melee@rifle@streamed_core","rifle_aim_whip",1.0,-1.0, 5000, 0, 1, true, true, true)
end