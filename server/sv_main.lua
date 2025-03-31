-- [[ QBCore ]]
local QBCore = exports['qb-core']:GetCoreObject()

-- [[ Resource Metadata ]] --


-- [[ Variables ]] --
local ActiveBodycam = false

-- [[ Functions ]] --

-- [[ Net Events ]] --
RegisterNetEvent('RoSA-Government:Server:SetBool', function(bool)
    ActiveBodycam = bool
end)

RegisterNetEvent('RoSA-Government:Server:GetOSDate', function(metadata)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    local Department = metadata.Department
    local Rank = metadata.Rank
    local PlayerName = metadata.PlayerName
    local Callsign = metadata.Callsign
    local Dept = metadata.Dept
    TriggerClientEvent('RoSA-Government:Client:BodyCamStatus', src, tonumber(os.date("%H")), tonumber(os.date("%M")), tonumber(os.date("%S")), Department, Rank, PlayerName, Callsign, Dept)
end)

RegisterNetEvent('RoSA-Government:Server:Time', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.Functions.GetItemByName("bodycam") then
        local bodycam = exports.ox_inventory:Search(source, 1, 'bodycam')
        for _, v in pairs(bodycam) do
            bodycam = v
            break
        end
        TriggerClientEvent("RoSA-Government:Client:BodyCamStatus", src, tonumber(os.date("%H")), tonumber(os.date("%M")), tonumber(os.date("%S")), bodycam.metadata.Department, bodycam.metadata.Rank, bodycam.metadata.PlayerName, bodycam.metadata.Callsign, bodycam.metadata.Dept)
    end
    -- TriggerClientEvent("RoSA-Government:Client:BodyCamStatus", src, tonumber(os.date("%H")), tonumber(os.date("%M")), tonumber(os.date("%S")), Department, Rank, PlayerName, Callsign, Dept)
end)

RegisterNetEvent("RoSA-Bodycam:Server:CreateBodycam", function(PlayerRank, PlayerCallsign, PlayerName, PlayerDept, DeptImg)
    local itemData = {
        description = string.format("Department: %s  \nRank: %s  \nName: %s  \nCallsign: %s",
            PlayerDept,
            PlayerRank,
            PlayerName,
            PlayerCallsign
        ),
        Department = PlayerDept,
        Rank = PlayerRank,
        PlayerName = PlayerName,
        Callsign = PlayerCallsign,
        Dept = DeptImg,
    }
    exports.ox_inventory:AddItem(source, "bodycam", 1, itemData)
end)

-- QBCore Usable Item
QBCore.Functions.CreateUseableItem("bodycam", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName(item.name) then
        local bodycam = exports.ox_inventory:Search(source, 1, 'bodycam')
        for _, v in pairs(bodycam) do
            bodycam = v
            break
        end
        TriggerClientEvent("RoSA-Government:Client:RadialTrigger", source, bodycam.metadata)
    end
end)

-- QBCore Commands
QBCore.Commands.Add('hidebodycam', 'Hides bodycam in case of character switching', {}, false, function(source, args)
    local src = source
    TriggerClientEvent('RoSA-Government:Client:HideCam', src)
end)