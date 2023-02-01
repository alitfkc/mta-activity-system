------------------------
-- Global Table
-----------------------
settings = {}
settings.player_count = 0
activity_players ={}
activity_players_data = {}
admins = {}
activity_vehicles = {}
----------------------------------------
-- Activity Pannel Open
------------------------------------
local panel_status = false
function panel_open(thePlayer)
    local hesap = getAccountName ( getPlayerAccount ( thePlayer ) ) 
    if isObjectInACLGroup ("user."..hesap, aclGetGroup (panel_acl) ) then 
        if not panel_status then
            triggerClientEvent(thePlayer, rs_name.."_activity_panel_open" ,thePlayer,settings,activity_players) 
            if admins[thePlayer] then 
                admins[thePlayer] = nil 
                panel_status = false
            else
                admins[thePlayer] = thePlayer
                panel_status = true
            end
        else
            if admins[thePlayer] then 
                triggerClientEvent(thePlayer, rs_name.."_activity_panel_open" ,thePlayer,settings,activity_players) 
                admins[thePlayer] = nil 
                panel_status = false
            end
        end
    end
end
addCommandHandler ( panel_command, panel_open ) 

--------------------------------------
--Sent to players
--------------------------------------
function sent_to_players()
    for k,v in pairs(admins) do 
        triggerClientEvent(v,rs_name.."_sent_to_players" ,v,activity_players,settings.player_count) 
    end
end


-------------------------------------
-- Return player weapons and position 
---------------------------------------------
function get_player_data(p)
    local skills = {}
    for i = 0,230 do 
        local value = getPedStat(p,i)
        table.insert(skills,{i,value})
    end
    local weapons = {}
    for i = 0,12 do 
        local weapon = getPedWeapon(p,i)
        local ammo =  getPedTotalAmmo (p,i)
        table.insert(weapons,{weapon,ammo})
    end
    local model = getElementModel(p)
    local health = getElementHealth(p)
    local armor = getPedArmor(p)
    local dimens = getElementDimension(p)
    local interior = getElementInterior(p)
    local _,_,rz = getElementRotation(p)
    local x,y,z = getElementPosition(p)
    local position = {x,y,z,rz}
    local save_table = {}
    save_table.skills = skills
    save_table.weapons = weapons
    save_table.model = model 
    save_table.health = health
    save_table.armor = armor
    save_table.dimens = dimens
    save_table.interior = interior
    save_table.position = position
    save_table = toJSON(save_table)
    return save_table
end


--------------------------------
-- Take Player weapon and armor
---------------------------------
function take_player_property(p)
    takeAllWeapons(p)
    setElementHealth(p,100)
    setPedArmor(p,0)
end

---------------------------------
--Load Player Data
----------------------------------
function load_player_data(p,t)
    source = p
    local table = fromJSON(t)
    for k,v in ipairs(table.skills) do 
        setPedStat(source,v[1],v[2])
    end
    for k,v in ipairs(table.weapons) do 
        giveWeapon(source,v[1],v[2])
    end
    setElementModel(source,table.model)
    setElementHealth(source,table.health)
    setPedArmor(source,table.armor)
    local x,y,z,rz = unpack(table.position)
    setElementPosition(source,x,y,z)
    setElementRotation(source,0,0,rz)
    setElementDimension(source,table.dimens)
    setElementInterior(source,table.interior)
end
---------------------------------
-- Join Activity
---------------------------------
function join_activity(player)
    if settings.activity_status then 
        if not settings.player_count then 
            settings.player_count = 0 
        end
        print(settings.player_count)
        if settings.player_count >= settings.players_limit then 
            outputChatBox(language[language_section].limit_players,player,255,0,0)
            return 
        end
        if activity_players[player] then
            outputChatBox(language[language_section].activity_joined,player,255,0,0)
        else
            local veh = getPedOccupiedVehicle(player) 
            if veh then 
                removePedFromVehicle(player)
            end
            settings.player_count = settings.player_count + 1
            activity_players[player] = player
            activity_players_data[player] = {player = player,data = get_player_data(player)}
            outputChatBox(language[language_section].activity_join,player,0,255,0)
            sent_to_players()
            take_player_property(player)
            on_off_ghost_player_mode()
            setElementPosition(player,math.random(settings.x-settings.w,settings.x+settings.w),math.random(settings.y-settings.w,settings.y+settings.w),settings.z)
            setElementDimension(player,settings.dim or 0)
            setElementFrozen(player,settings.freeze)
            toggleAllControls(player,not settings.freeze)
            if settings.fire then
                for l,c in pairs(controls) do
                    toggleControl(player,c,not settings.fire)
                end
            end
            setPedWeaponSlot(player,0)
            triggerClientEvent(player,rs_name.."_join_or_leave_activity",player,true)
        end
    else
        outputChatBox(language[language_section].activity_started,player,255,0,0)
    end
end 
addCommandHandler(activity_cmd,join_activity)

------------------------------------------------
--leave activity 
-------------------------------------------------
function leave_activity(player)
    if activity_players[player] then
        take_player_property(player)
        load_player_data(player,activity_players_data[player].data)
        activity_players[player]  = nil
        activity_players_data[player] = nil
        setElementFrozen(player,false)
        toggleAllControls(player,true)
        for l,c in pairs(controls) do
            toggleControl(player,c,true)
        end
        settings.player_count = settings.player_count - 1
        removeElementData(player,immortal_data,settings.immortal)
        triggerClientEvent(player,rs_name.."_ghost_players_state",player,true)
        outputChatBox(language[language_section].activity_leaved,player,255,0,0)
        sent_to_players()
        triggerClientEvent(player,rs_name.."_join_or_leave_activity",player,false)
    end
end 
addCommandHandler(activity_leave_cmd,leave_activity)




addEventHandler("onPlayerWasted",root,function()
    setTimer(function(player) leave_activity(player) end,6000,1,source)
end)

addEventHandler("onPlayerQuit",root,function()
    leave_activity(source)
    if admins[source] then 
        admins[source] = nil 
        panel_status = false
    end
end)
---------------------------------
-- Activity Status On - Off
---------------------------------
function activity_onoff_s(t)
    settings = t
    settings.player_count = 0
end

--------------------------------------------------
-- Finish Activity
--------------------------------------------------
function finish_activity_s()
    remove_vehicles_s()
    for k,v in pairs(activity_players) do 
        take_player_property(v)
        load_player_data(v,activity_players_data[v].data)
        settings.player_count = 0
        activity_players[v]  = nil
        activity_players_data[v] = nil
        setElementFrozen(v,false)
        for l,c in pairs(controls) do
            toggleControl(v,c,true)
        end
        toggleAllControls(v,true)
        triggerClientEvent(v,rs_name.."_ghost_players_state",v,true)
        outputChatBox(language[language_section].activity_finished,v,0,255,0)
        triggerClientEvent(v,rs_name.."_join_or_leave_activity",v,false)
    end
    outputChatBox(language[language_section].activity_finished,source,0,255,0)
end


---------------------------------------------------
--Teleport Players
---------------------------------------------------
function teleport_players_s(t)
    for k,v in pairs(activity_players) do  
        setElementPosition(v,math.random(t.x-t.w,t.x+t.w),math.random(t.y-t.w,t.y+t.w),t.z)
        setElementDimension(v,t.dimens)
    end
    outputChatBox(language[language_section].teleports_players,source,0,255,0)
end


---------------------------------------------------
--kick Player
---------------------------------------------------
function kick_player_s(player)
    take_player_property(player)
    load_player_data(player,activity_players_data[player].data)
    activity_players[player]  = nil
    activity_players_data[player] = nil
    setElementFrozen(player,false)
    toggleAllControls(player,true)
    settings.player_count = settings.player_count -1
    outputChatBox(language[language_section].activity_leaved,player,255,0,0)
    sent_to_players()
    outputChatBox(language[language_section].kick_player:format(string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "")),source,0,255,0)
end

---------------------------------------------------
--Freeze Players
---------------------------------------------------
function freeze_players_s()
    settings.freeze = not settings.freeze
    for k,v in pairs(activity_players) do   
        setElementFrozen(v,settings.freeze)
        toggleAllControls(v,not settings.freeze)
        local veh = getPedOccupiedVehicle(v)
        if veh then 
            freeze_vehicle(veh)
        end
    end
    outputChatBox(language[language_section].freeze_players,source,0,255,0)
end


function freeze_vehicle(veh)
    setElementFrozen(veh,settings.freeze)
end



---------------------------------------------------
--freeze Player
---------------------------------------------------
function freeze_player_s(player)
    setElementFrozen(player,not isElementFrozen(player))
    toggleAllControls(player,not isElementFrozen(player))
    outputChatBox(language[language_section].freeze_player:format(string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "")),source,0,255,0)
end

---------------------------------------------------
--Give Weapon Players
---------------------------------------------------
function give_weapon_players_s(id,ammo)
    for k,v in pairs(activity_players) do   
        giveWeapon(v,id,ammo)
    end
    outputChatBox(language[language_section].give_weapons_players:format(getWeaponNameFromID(id)),source,0,255,0)
end
---------------------------------------------------
--Give Weapon Player
---------------------------------------------------
function give_weapon_player_s(player,id,ammo)
    giveWeapon(player,id,ammo)
    outputChatBox(language[language_section].give_weapons_player:format(string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", ""),getWeaponNameFromID(id)),source,0,255,0)
end

---------------------------------------------------
--Take players weapons
---------------------------------------------------
function take_players_weapons_s()
    for k,v in pairs(activity_players) do   
        takeAllWeapons(v)
    end
    outputChatBox(language[language_section].take_weapons_players,source,0,255,0)
end

---------------------------------------------------
--take player weapon
---------------------------------------------------
function take_player_weapon_s(player,id)
    takeWeapon(player,id)
    outputChatBox(language[language_section].give_weapons_player:format(string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", ""),getWeaponNameFromID(id)),source,0,255,0)
end

-------------------------------------------------
--Players set health
--------------------------------------------------
function set_players_healths_s(health)
    for k,v in pairs(activity_players) do   
        setElementHealth(v,health)
    end
    outputChatBox(language[language_section].give_health_players:format(health),source,0,255,0)
end

--------------------------------------------------
--Player set health
--------------------------------------------------
function set_player_health_s(player,health)
    setElementHealth(player,health)
    outputChatBox(language[language_section].give_health_player:format(string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", ""),health),source,0,255,0)
end

-------------------------------------------------
--Players set armor
--------------------------------------------------
function set_players_armors_s(armor)
    for k,v in pairs(activity_players) do   
        setPedArmor(v,armor)
    end
    outputChatBox(language[language_section].give_armor_players:format(armor),source,0,255,0)
end

--------------------------------------------------
--Player set armor
--------------------------------------------------
function set_player_armor_s(player,armor)
    setPedArmor(player,armor)
    outputChatBox(language[language_section].give_armor_player:format(string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", ""),armor),source,0,255,0)
end
----------------------------
--Teleport Admin
-----------------------------
function teleport_admin_s(t)
    setElementPosition(source,t.x,t.y,t.z)
    setElementDimension(source,t.dimens)
end

-------------------------
-- sent to announcement
-------------------------
function sent_to_announcement_s(text)
    for k,v in pairs(activity_players) do   
        triggerClientEvent(v,rs_name.."_sent_announcement",v,text)
    end
    outputChatBox(language[language_section].send_announcement_activity_player,source,0,255,0)
end

function sent_to_everyone_announcement_s(text)
    for k,v in pairs(getElementsByType("player")) do   
        if not activity_players[v] then 
            triggerClientEvent(v,rs_name.."_sent_announcement",v,text)
        end
    end
    outputChatBox(language[language_section].send_announcement_all_player,source,0,255,0)
end

--------------
--- set immortal player
------------------------

function set_immortal_players()
    settings.immortal = not settings.immortal
    for k,v in pairs(activity_players) do   
        setElementData(v,immortal_data,settings.immortal)
    end
    if settings.immortal then      
        outputChatBox(language[language_section].god_mode_player_on,source,0,255,0)
    else
        outputChatBox(language[language_section].god_mode_player_off,source,0,255,0)
    end
end


----------------------------
--blocked fire 
-----------------------------
function blocked_fire_s()
    settings.fire = not settings.fire
    for k,v in pairs(activity_players) do   
        for l,c in pairs(controls) do
            toggleControl(v,c,not settings.fire)
        end
        setPedWeaponSlot(v,0)
    end
    if settings.fire then      
        outputChatBox(language[language_section].blocke_fire_on,source,0,255,0)
    else
        outputChatBox(language[language_section].blocke_fire_off,source,0,255,0)
    end
end

------------------------
--Ghost Mode
------------------------
function on_off_ghost_player_mode()
    if settings.ghost_players then 
        for k,v in pairs(activity_players) do  
            triggerClientEvent(v,rs_name.."_ghost_players_state",v,false)
        end
    end
end

function ghost_players_s()
    settings.ghost_players = not settings.ghost_players
    if settings.ghost_players then 
        for k,v in pairs(activity_players) do  
            triggerClientEvent(v,rs_name.."_ghost_players_state",v,false)
        end
    else
        for k,v in pairs(activity_players) do  
            triggerClientEvent(v,rs_name.."_ghost_players_state",v,true)
        end
    end

    if settings.ghost_players then      
        outputChatBox(language[language_section].ghost_player_on,source,0,255,0)
    else
        outputChatBox(language[language_section].ghost_player_off,source,0,255,0)
    end
end


-------------------------------------
--sent to countdown
-------------------------------------
local countdown_timers = false 
local countdown_count = 0
function sent_to_countdown_s(countdown)
    for k,v in pairs(activity_players) do   
        triggerClientEvent(v,rs_name.."_sent_countdown_client",v,countdown)
    end
    outputChatBox(language[language_section].countdown_sent:format(countdown),source,0,255,0)

    if isTimer(countdown_timers) then 
        killTimer(countdown_timers) 
        countdown_timers = false
    end
    countdown_timers = setTimer(function(player,countdown)
        outputChatBox(language[language_section].finish_countdown:format(countdown),player,0,255,0)
    end,countdown*1000,1,source,countdown)
end
-----
-- Set player limit from activity
function set_to_activity_player_limit_s(limit)
    settings.players_limit = limit
end

-----------
-- Teleport helper activity admin
--------------------
addCommandHandler(tp_player_cmd,function(thePlayer,cmd,selected_player)
    local hesap = getAccountName ( getPlayerAccount ( thePlayer ) ) 
    if isObjectInACLGroup ("user."..hesap, aclGetGroup (panel_acl) ) then 
        local selected_player = getPlayerFromName(selected_player)
        if selected_player then 
            local x,y,z = getElementPosition(thePlayer)
            local dim = getElementDimension(thePlayer)
            setElementPosition(selected_player,x,y,z)
            setElementDimension(selected_player,dim)
        else
            outputChatBox(language[language_section].no_player,source,255,0,0)
        end
    end
end)

-------------------------------------------------------------
--Give Vehicle to players 
-------------------------------------------------------------
function give_vehicle_to_players_s(id)
    local vh = getVehicleNameFromModel(id)
    if vh then 
        for k,v in pairs(activity_players) do   
            local x,y,z = getElementPosition(v)
            local _,_,rz = getElementRotation(v)
            local dim = getElementDimension(v)
            local veh = createVehicle(id,x,y,z,0,0,rz)
            freeze_vehicle(veh)
            setElementDimension(veh,dim)
            warpPedIntoVehicle(v,veh)
            table.insert(activity_vehicles,veh)
            setElementID(veh,"activity_arac"..#activity_vehicles)
        end
    else
        outputChatBox(language[language_section].no_id:format(id),source,255,0,0)
    end
    on_off_ghost_vehicles_mode()
end
-----------------------
-- Fix Vehicles
---------------------
function fix_vehicles_s()
    for k,v in pairs(activity_vehicles) do
        fixVehicle(v)
    end  
end


------------------------
--Ghost Mode Vehicle
------------------------
function on_off_ghost_vehicles_mode()
    if settings.ghost_players then 
        for k,v in pairs(activity_players) do  
            triggerClientEvent(v,rs_name.."_ghost_players_state",v,false)
        end
    end
end

function ghost_vehicles_s()
    settings.ghost_vehicles = not settings.ghost_vehicles
    if settings.ghost_vehicles then 
        for k,v in pairs(activity_players) do  
            triggerClientEvent(v,rs_name.."_ghost_vehicles_state",v,false,activity_vehicles)
        end
    else
        for k,v in pairs(activity_players) do  
            triggerClientEvent(v,rs_name.."_ghost_vehicles_state",v,true,activity_vehicles)
        end
    end

    if settings.ghost_vehicles then      
        outputChatBox(language[language_section].ghost_player_on,source,0,255,0)
    else
        outputChatBox(language[language_section].ghost_player_off,source,0,255,0)
    end
end

---------------------------------
--function no exit vehicles
----------------------------------
function no_exit_veh(p)
    if activity_players[p] then 
        cancelEvent()
    end
end
function no_exit_vehicles_s()
    settings.no_exit_vehicles = not settings.no_exit_vehicles_s
    if settings.no_exit_vehicles then 
        addEventHandler("onVehicleStartExit",getRootElement(),no_exit_veh)
    else
        removeEventHandler("onVehicleStartExit",getRootElement(),no_exit_veh)
    end
end

--------------------------------------
---Destroy All Vehicles
---------------------------------------
function remove_vehicles_s()
    for k,v in pairs(activity_vehicles) do  
        destroyElement(v)
    end
    activity_vehicles = {}
end

-----------------------------------------------
--Remove player vehicle
-----------------------------------------------
function remove_player_vehicle_s(player)
    local vehicle = getPedOccupiedVehicle(player) 
    if vehicle then 
        destroyElement(vehicle)
        iprint(getElementID(vehicle))
        local index = tonumber(string.gsub(getElementID(vehicle), "%a", ""))
        table.remove(activity_vehicle,index)
    end
end


-----------------------------------------------
--give player vehicle
-----------------------------------------------
function give_player_vehicle_s(player,id)
    local vh = getVehicleNameFromModel(id)
    if vh then   
        local x,y,z = getElementPosition(player)
        local _,_,rz = getElementRotation(player)
        local dim = getElementDimension(player)
        local veh = createVehicle(id,x,y,z,0,0,rz)
        freeze_vehicle(veh)
        setElementDimension(veh,dim)
        warpPedIntoVehicle(player,veh)
        table.insert(activity_vehicles,veh)
        setElementID(veh,"activity_arac"..#activity_vehicles)
    else
        outputChatBox(language[language_section].no_id:format(id),source,255,0,0)
    end
    on_off_ghost_vehicles_mode()
end
---------------------------------------
-- remove vehicle command
---------------------------------------
function remove_select_veh(thePlayer)
    local hesap = getAccountName ( getPlayerAccount ( thePlayer ) ) 
    if isObjectInACLGroup ("user."..hesap, aclGetGroup (panel_acl) ) then 
        local vehicle = getPedOccupiedVehicle(player) 
        if vehicle then 
            destroyElement(vehicle)
            local index = tonumber(string.gsub(getElementID(vehicle), "%a", ""))
            table.remove(activity_vehicle,index)
        end
    end
end
addCommandHandler(remove_veh_cmd,remove_select_veh)



--------------------------------------------
--create map cars
--------------------------------------------
function create_map_vehicle_s(select_map)
    for k,v in ipairs(maps[select_map]) do 
        local veh = createVehicle(v[1],v[2],v[3],v[4],0,0,v[5])
        freeze_vehicle(veh)
        setElementDimension(veh,settings.dim)
        table.insert(activity_vehicles,veh)
        setElementID(veh,"activity_arac"..#activity_vehicles)
    end
    on_off_ghost_vehicles_mode()
end


---------------------------------------------
--Teleport players created vehicles
---------------------------------------------
function teleport_players_created_vehicles_s()
    local a = 1
    for s,p in pairs(activity_players) do 
        warpPedIntoVehicle(p,activity_vehicles[a])
        a = a  + 1 
    end
end




-------------------------
--Event Handlers
-------------------------
local events = {
    {event_name = "_activity_status_change",func =activity_onoff_s},
    {event_name = "_activity_finish",func =finish_activity_s},
    {event_name = "_teleport_players",func = teleport_players_s},
    {event_name = "_kick_player",func = kick_player_s},
    {event_name = "_freeze_players",func=freeze_players_s},
    {event_name = "_freeze_player",func = freeze_player_s},
    {event_name = "_give_weapon_players",func =give_weapon_players_s},
    {event_name = "_give_weapon_player",func = give_weapon_player_s,},
    {event_name = "_take_players_weapons",func = take_players_weapons_s,},
    {event_name = "_take_player_weapon",func = take_player_weapon_s,},
    {event_name = "_set_players_healths",func  =set_players_healths_s},
    {event_name = "_set_player_health",func  =set_player_health_s},
    {event_name = "_set_players_armors",func  =set_players_armors_s},
    {event_name = "_set_player_armor",func  =set_player_armor_s},
    {event_name = "_teleport_admin",func = teleport_admin_s},
    {event_name = "_sent_to_announcement",func = sent_to_announcement_s},
    {event_name = "_immortal_players",func = set_immortal_players_s},
    {event_name = "_blocked_fire",func = blocked_fire_s},
    {event_name = "_ghost_players",func = ghost_players_s},
    {event_name = "_sent_to_countdown",func = sent_to_countdown_s},
    {event_name = "_sent_to_everyone_announcement",func = sent_to_everyone_announcement_s,},
    {event_name = "_set_to_activity_player_limit", func = set_to_activity_player_limit_s},
    {event_name = "_give_vehicle_to_players",func = give_vehicle_to_players_s},
    {event_name = "_fix_vehicles",func = fix_vehicles_s},
    {event_name = "_ghost_vehicles",func = ghost_vehicles_s},
    {event_name = "_no_exit_vehicles",func= no_exit_vehicles_s},
    {event_name = "_remove_vehicles",func = remove_vehicles_s},
    {event_name = "_remove_player_vehicle",func = remove_player_vehicle_s},
    {event_name ="_give_player_vehicle",func = give_player_vehicle_s},
    {event_name = "_create_map_vehicle",func = create_map_vehicle_s},
    {event_name = "_teleport_players_created_vehicles",func = teleport_players_created_vehicles_s },
}

for k,v in ipairs(events) do
    if v.event_name and v.func then 
        addEvent(rs_name..v.event_name,true)
        addEventHandler(rs_name..v.event_name,root,v.func)
    end
end



