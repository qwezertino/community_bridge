if GetResourceState('ox_lib') ~= 'started' and (BridgeClientConfig.MenuSystem ~= "ox" or BridgeClientConfig.MenuSystem ~= "auto") then return end

--- Converts a QB menu to an Ox menu.
---@param id string The menu ID.
---@param menu table The QB menu data.
---@return table The Ox menu data.
local function QBToOxMenu(id, menu)
    local oxMenu = {
        id = id,
        title = "",
        canClose = true,
        options = {},
    }
    for i, v in pairs(menu) do
        if v.isMenuHeader then
            if oxMenu.title == "" then
                oxMenu.title = v.header
            end
        else
            local option = {
                title = v.header,
                description = v.txt,
                icon = v.icon,
                args = v.params.args,
                onSelect = function(selected, secondary, args)
                    local params = menu[id]?.options?[selected]?.params
                    if not params then return end
                    local event = params.event
                    local isServer = params.isServer
                    if not event then return end
                    if isServer then
                        return TriggerServerEvent(event, args)
                    end
                    return TriggerEvent(event, args)
                end

            }
            table.insert(oxMenu.options, option)
        end
    end
    return oxMenu
end



OpenMenu = function(id, data, useQBinput)
    if useQBinput then 
        data = QBToOxMenu(id, data)
    end 
    return exports['qb-menu']:openMenu(data)
end