RegisterServerEvent("firearmsEnhance:updateWindows")
AddEventHandler("firearmsEnhance:updateWindows", function(closestVehicle, bone)
    TriggerClientEvent("firearmsEnhance:syncWindows", -1, closestVehicle, bone)
end)
 