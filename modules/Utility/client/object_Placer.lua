Utility = Utility or {}

local activePlacementProp = nil
lib.locale()

-- Object placer --
local placementText = {
    locale('place_object'),
    locale('place_object_place'),
    locale('place_object_cancel'),
    locale('place_object_scroll_up'),
    locale('place_object_scroll_down')
}

local function finishPlacing()
    Bridge.notify.HideHelpText()
    if activePlacementProp == nil then return end
    DeleteObject(activePlacementProp)
    activePlacementProp = nil
end

Utility.PlaceObject = function(object, distance, snapToGround, allowedMats, offset)
    if activePlacementProp then return end

    if not object then Prints.Error('no_prop_defined') end

    local propObject = type(object) == 'string' and joaat(object) or object
    local heading = 0.0
    local checkDist = distance or 10.0

    Utility.LoadModel(propObject)

    activePlacementProp = CreateObject(propObject, 1.0, 1.0, 1.0, false, true, true)
    SetModelAsNoLongerNeeded(propObject)
    SetEntityAlpha(activePlacementProp, 150, false)
    SetEntityCollision(activePlacementProp, false, false)
    SetEntityInvincible(activePlacementProp, true)
    FreezeEntityPosition(activePlacementProp, true)

    Bridge.notify.ShowHelpText(type(placementText) == 'table' and table.concat(placementText) or placementText, {
        position = "left-center",
    })

    local outLine = false

    while activePlacementProp do
        --local hit, _, coords, _, materialHash = lib.raycast.fromCamera(1, 4)
        --local hit, _, coords, _, materialHash = lib.raycast.fromCamera(1, 4, nil)
        local hit, _, coords, _, materialHash = lib.raycast.fromCamera(1, 4)
        if hit then
            if offset then
                coords += offset
            end

            SetEntityCoords(activePlacementProp, coords.x, coords.y, coords.z, false, false, false, false)
            local distCheck = #(GetEntityCoords(cache.ped) - coords)
            SetEntityHeading(activePlacementProp, heading)

            if snapToGround then
                PlaceObjectOnGroundProperly(activePlacementProp)
            end

            if outLine then
                outLine = false
                SetEntityDrawOutline(activePlacementProp, false)
            end

            if (allowedMats and not allowedMats[materialHash]) or distCheck >= checkDist then
                if not outLine then
                outLine = true
                SetEntityDrawOutline(activePlacementProp, true)
                end
            end

            if IsControlJustReleased(0, 38) then
                if not outLine and (not allowedMats or allowedMats[materialHash]) and distCheck < checkDist then
                    finishPlacing()

                    return coords, heading
                end
            end

            if IsControlJustReleased(0, 73) then
                finishPlacing()

                return nil, nil
            end

            if IsControlJustReleased(0, 14) then
                heading = heading + 5
                if heading > 360 then heading = 0.0 end
            end

            if IsControlJustReleased(0, 15) then
                heading = heading - 5
                if heading < 0 then
                    heading = 360.0
                end
            end
        end
    end
end

Utility.StopPlacing = function()
    if not activePlacementProp then return end
    finishPlacing()
end

-- This is derrived and slightly altered from its creator and licensed under GPL-3.0 license Author:Zoo, the original is located here https://github.com/Renewed-Scripts/Renewed-Lib/tree/main