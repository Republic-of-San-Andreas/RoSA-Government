-- [[ QBCore ]]
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
PlayerJob = {}

-- [[ Resource Metadata ]] --
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    SendNUIMessage({
        action = "HideBodyCam"
    })

    SetCamActive = false
    SetBeepActive = false
end)

-- [[ Variables ]] --
local year, month, day, hour, minute, second = GetLocalTime()
local SetCamActive = false
local SetBeepActive = false

function AddZeroInfrontOfLess(number)
    if number < 10 then
        return 0 .. number
    end

    return number
end


-- [[ Functions ]] --
function UpdateBodyCamTime()
    TriggerServerEvent('RoSA-Government:Server:Time')
end

-- [[ Net Events ]] --
RegisterNetEvent('RoSA-Government:Client:RadialTrigger', function(metadata)
    if SetCamActive then
        SetCamActive = false
        TriggerEvent('RoSA-Government:Client:HideCam')
    else
        TriggerServerEvent('RoSA-Government:Server:SetBool', true)
        TriggerServerEvent('RoSA-Government:Server:GetOSDate', metadata)
        SetCamActive = true
    end
end)

RegisterNetEvent("RoSA-Government:Client:Time", function(h, m, s)
    SendNUIMessage({
        action = "ShowBodyCamTime",
        Time = day .. "/" .. month .. "/" .. year .. " " .. " - " .. AddZeroInfrontOfLess(h) .. " : " .. AddZeroInfrontOfLess(m) .. " : " .. AddZeroInfrontOfLess(s) .. " LOCAL",
    })
end)

RegisterNetEvent("RoSA-Government:Client:BodyCamStatus", function(h, m, s, Department, Rank, PlayerName, Callsign, Dept)
    local Player = QBCore.Functions.GetPlayerData()

    if Player.charinfo.gender == "0" or Player.charinfo.gender == 0 then
        gender = Config.Settings['Gender']['Male']
    else
        gender = Config.Settings['Gender']['Female']
    end

    SendNUIMessage({
        action = "ShowBodyCam",
        Player = Rank .. " " .. gender .. " " .. PlayerName,
        Callsign = "[" .. Callsign .. "]",
        Time = day .. "/" .. month .. "/" .. year .. " " .. " - " .. AddZeroInfrontOfLess(h) .. " : " .. AddZeroInfrontOfLess(m) .. " : " .. AddZeroInfrontOfLess(s) .. " LOCAL",
        Department = Department,
        DeptLogo = Dept
    })

    if not SetBeepActive then
        local myPos = GetEntityCoords(PlayerPedId(), true)
        TriggerServerEvent('InteractSound_SV:PlayWithinDistanceOnCoords', 1.0, "Axon", 0.5, myPos)
        SetBeepActive = true
    end
end)

RegisterNetEvent('RoSA-Government:Client:HideCam', function()
    SendNUIMessage({
        action = "HideBodyCam"
    })

    SetCamActive = false
    SetBeepActive = false
end)

RegisterNetEvent("RoSA-Governemnt:Client:GiveBodyCam", function()
    local Player = QBCore.Functions.GetPlayerData()
    local PlayerRank = Player.job.grade.name
    local PlayerCallsign = Player.metadata.callsign
    local PlayerName = Player.charinfo.lastname

    local PlayerDept = Config.Settings['AllowedJobs'][Player.job.name]['Label']
    local DeptImg = Config.Settings['AllowedJobs'][Player.job.name]['LogoLink']

    if not Player or not PlayerRank or not PlayerCallsign or not PlayerName or not PlayerDept or not DeptImg then return end
    TriggerServerEvent("RoSA-Bodycam:Server:CreateBodycam", PlayerRank, PlayerCallsign, PlayerName, PlayerDept, DeptImg)
end)


-- [[ Threads ]] --
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local isholdingWeapon = GetCurrentPedWeapon(ped, 11)

        if isholdingWeapon and QBCore.Functions.HasItem('bodycam') and QBCore.Functions.GetPlayerData().job.type == "leo" or QBCore.Functions.GetPlayerData().job.type == "ems" and QBCore.Functions.GetPlayerData().job.onduty then
            if IsControlJustPressed(0, 24) then
                TriggerServerEvent("RoSA-Government:Server:Time")
                SetCamActive = true
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        if SetCamActive then
            UpdateBodyCamTime()
        end
    end
end)