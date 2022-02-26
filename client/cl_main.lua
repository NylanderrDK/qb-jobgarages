local QBCore = exports["qb-core"]:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()
local LoggedIn = false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    PlayerData = QBCore.Functions.GetPlayerData()
    LoggedIn = true
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
    PlayerData = {}
    LoggedIn = false
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate", function(info)
    PlayerData.job = info
end)

RegisterNetEvent("QBCore:Player:SetPlayerData", function(info)
    PlayerData = info
end)

--[[
    Load
]]
Citizen.CreateThread(function()
    for k, v in pairs(Config.Garages) do
        print("[Info/Load] " .. Lang:t("logging.creating_blips"))
        QBCore.Functions.CreateBlip(v.position, 50, 4, 0.8, 0, true, Lang:t("general.blip"))
    end
end)

--[[
    Threads
]]
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    local headerDrawn = false

    while true do
        local sleep = 2000

        if LoggedIn then
            local pos = GetEntityCoords(PlayerPedId())

            for k, v in pairs(Config.Garages) do
                local garagePos = vector3(v.position.x, v.position.y, v.position.z)

                if PlayerData.job.name == v.job then
                    if #(pos - garagePos) < 7.5 then
                        sleep = 5
                        DrawMarker(2, v.position.x, v.position.y, v.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)

                        if #(pos - garagePos) <= 1.5 then
                            if not headerDrawn then
                                headerDrawn = true
                                exports["qb-menu"]:showHeader({
                                    {
                                        header = Lang:t("menu.header"),
                                        params = {
                                            event = "job-garages:client:GarageMenu",
                                            args = {
                                                garage = v
                                            }
                                        }
                                    }
                                })
                            end
                        else
                            if headerDrawn then
                                headerDrawn = false
                                exports["qb-menu"]:closeMenu()
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(sleep)
    end
end)

--[[
    Events
]]
RegisterNetEvent("job-garages:client:GarageMenu", function(data)
    print("[Info/GarageMenu] " .. Lang:t("logging.opening_menu"))
    local garage = data.garage
    local menu = {
        {
            header = Lang:t("menu.header"),
            isMenuHeader = true
        }
    }

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        menu[#menu + 1] = {
            header = Lang:t("menu.return_vehicle"),
            txt = "",
            params = {
                event = "job-garages:client:ReturnVehicle"
            }
        }
    else
        local vehicles = garage.vehicles[PlayerData.job.grade.level]

        if type(vehicles) == "table" then
            for k, v in pairs(vehicles) do
                menu[#menu + 1] = {
                    header = v,
                    txt = "",
                    params = {
                        event = "job-garages:client:SpawnVehicle",
                        args = {
                            vehicle = k,
                            position = garage.position
                        }
                    }
                }
            end
        else
            menu[#menu + 1] = {
                header = Lang:t("menu.no_vehicles"),
                txt = "",
                isMenuHeader = true
            }
        end
    end

    exports["qb-menu"]:openMenu(menu)
end)

RegisterNetEvent("job-garages:client:SpawnVehicle", function(data)
    print("[Info/SpawnVehicle] " .. Lang:t("logging.spawn_vehicle"))
    local vehicle = data.vehicle
    local position = data.position

    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "JOB" .. tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, position.w)
        exports["LegacyFuel"]:SetFuel(veh, 100.0)
        exports["qb-menu"]:closeMenu()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        QBCore.Functions.Notify(Lang:t("notifications.received_keys"))
    end, position, true)
end)

RegisterNetEvent("job-garages:client:ReturnVehicle", function()
    print("[Info/ReturnVehicle] " .. Lang:t("logging.return_vehicle"))
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
        QBCore.Functions.Notify(Lang:t("notifications.returned_vehicle"))
    end
end)