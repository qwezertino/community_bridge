if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports["es_extended"]:getSharedObject()

Framework = {}

-- Framework.GetPlayerIdentifier(src)
-- Returns the citizen ID of the player.
Framework.GetPlayerIdentifier = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.getIdentifier()
end

-- Framework.GetPlayerName(src)
-- Returns the first and last name of the player.
Framework.GetPlayerName = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.variables.firstName, xPlayer.variables.lastName
end

-- Framework.GetItem(src, item, metadata)
-- Returns a table of items matching the specified name and if passed metadata from the player's inventory.
-- returns {name = v.name, count = v.amount, metadata = v.info, slot = v.slot}
Framework.GetItem = function(src, item, _)
    local playerItems = ESX.GetPlayerFromId(src).getInventory()
    local repackedTable = {}
    for _, v in pairs(playerItems) do
        if v.name == item then
            table.insert(repackedTable, {
                name = v.name,
                count = v.count,
                --metadata = v.metadata,
                --slot = v.slot,
            })
        end
    end
    return repackedTable
end

-- Framework.GetItemCount(src, item, _)
-- Returns the count of items matching the specified name and if passed metadata from the player's inventory.
Framework.GetItemCount = function(src, item, _)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.getInventoryItem(item).count
end

-- Framework.GetPlayerInventory(src)
-- Returns the entire inventory of the player as a table.
-- returns {name = v.name, count = v.amount, _, _}
Framework.GetPlayerInventory = function(src)
    local playerItems = ESX.GetPlayerFromId(src).getInventory()
    local repackedTable = {}
    for _, v in pairs(playerItems) do
		if v.count > 0 then
			table.insert(repackedTable, {
				name = v.name,
				count = v.count,
				--metadata = v.metadata,
				--slot = v.slot,
			})
		end
    end
    return repackedTable
end

-- Framework.SetMetadata(src, metadata, value)
-- Adds the specified metadata key and number value to the player's data.
Framework.SetPlayerMetadata = function(src, metadata, value)
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.setMeta(metadata, value, nil)
    return true
end

-- Framework.GetMetadata(src, metadata)
-- Gets the specified metadata key and value to the player's data.
Framework.GetPlayerMetadata = function(src, metadata)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.getMeta(metadata) or false
end

-- defualt esx Available tables are
-- identifier, accounts, group, inventory, job, job_grade, loadout, 
-- metadata, position, firstname, lastname, dateofbirth, sex, height, 
-- skin, status, is_dead, id, disabled, last_property, created_at, last_seen, 
-- phone_number, pincode
Framework.GetStatus = function(src, column)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.get(column) or nil
end

-- Framework.AddThirst(src, value)
-- Adds the specified value from the player's thirst level.
Framework.AddThirst = function(src, value)
    local clampIT = Math.Clamp(value, 0, 200000)
    local levelForEsx = clampIT * 2000
    TriggerClientEvent('esx_status:add', src, 'thirst', levelForEsx)
    return levelForEsx
end

-- Framework.AddHunger(src, value)
-- Adds the specified value from the player's hunger level.
Framework.AddHunger = function(src, value)
    local clampIT = Math.Clamp(value, 0, 200000)
    local levelForEsx = clampIT * 2000
    TriggerClientEvent('esx_status:add', src, 'hunger', levelForEsx)
    return levelForEsx
end

Framework.GetHunger = function(src)
    local status = Framework.GetStatus(src, "status")
    if not status then return 0 end
    return status.hunger
end

Framework.GetThirst = function(src)
    local status = Framework.GetStatus(src, "status")
    if not status then return 0 end
    return status.thirst
end

-- Framework.GetPlayerPhone(src)
-- Returns the phone number of the player.
Framework.GetPlayerPhone = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.get("phone_number")
end

-- Framework.GetPlayerJob(src)
-- Returns the job name, label, grade name, and grade level of the player.
Framework.GetPlayerJob = function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.getJob().name, xPlayer.getJob().label, xPlayer.getJob().grade_label, xPlayer.getJob().grade
end

-- Framework.GetPlayersByJob(jobname)
-- returns a table of player sources that have the specified job name.
Framework.GetPlayersByJob = function(job)
    local players = GetPlayers()
    local playerList = {}
    for _, src in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getJob().name == job then
            table.insert(playerList, src)
        end
    end
    return playerList
end

-- Framework.SetPlayerJob(src, name, grade)
-- Sets the player's job to the specified name and grade.
Framework.SetPlayerJob = function(src, name, grade)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not ESX.DoesJobExist(name, grade) then lib.print.error("Job Does Not Exsist In Framework :NAME "..name.." Grade:"..grade) return end
    return xPlayer.setJob(name, grade)
end

-- Framework.AddAccountBalance(src, _type, amount)
-- Adds the specified amount to the player's account balance of the specified type.
Framework.AddAccountBalance = function(src, _type, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.addAccountMoney(_type, amount)
end

-- Framework.RemoveAccountBalance(src, _type, amount)
-- Removes the specified amount from the player's account balance of the specified type.
Framework.RemoveAccountBalance = function(src, _type, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.removeAccountMoney(_type, amount)
end

-- Framework.GetAccountBalance(src, _type)
-- Returns the player's account balance of the specified type.
Framework.GetAccountBalance = function(src, _type)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.getAccount(_type).money
end

-- Framework.AddItem(src, item, amount, _, _)
-- Adds the specified item to the player's inventory.
Framework.AddItem = function(src, item, amount, slot, metadata)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.addInventoryItem(item, amount)
end

-- Framework.RemoveItem(src, item, amount, _, _)
-- Removes the specified item from the player's inventory.
Framework.RemoveItem = function(src, item, amount, slot, metadata)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer.removeInventoryItem(item, amount)
end

-- Framework.RegisterUsableItem(item, cb)
-- Registers a usable item with a callback function.
Framework.RegisterUsableItem = function(item, cb)
    ESX.RegisterUsableItem(item, cb)
end