if GetResourceState('mk_vehiclekeys') ~= 'started' then return end
VehicleKey = {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    return exports["mk_vehiclekeys"]:AddKey(vehicle)
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) then return false end
    return exports["mk_vehiclekeys"]:RemoveKey(vehicle)
end