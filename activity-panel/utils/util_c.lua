settings = {}
activity_players = {}
----------------------------------------
-- Activity Pannel Open
------------------------------------
function pannel_on_off(s_table,p_table)
    settings = s_table
    local state = not guiGetVisible(main)
    guiSetVisible(main,state)
    showCursor(state)
    write_players(p_table)
    load_settings()
end
addEvent(rs_name.."_activity_panel_open",true)
addEventHandler(rs_name.."_activity_panel_open",localPlayer,pannel_on_off)

-------------------------------
--load settings 
-------------------------------
function load_settings()
    if settings.activity_status then 
        guiSetText(gui.activity_status_label,"Etkinliğe Katılma Aktif")
        guiLabelSetColor(gui.activity_status_label,0,255,0)
    else
        guiSetText(gui.activity_status_label,"Etkinliğe Katılma Deaktif")
        guiLabelSetColor(gui.activity_status_label,255,0,0)
    end
    guiCheckBoxSetSelected(gui.no_damage_players,settings.immortal or false)
    guiCheckBoxSetSelected(gui.freeze_players ,settings.freeze or false)
end

----------------------------------
-- Set Position
----------------------------------
function set_text_pos()
    local x,y,z =getElementPosition(localPlayer)
    local dim = getElementDimension(localPlayer)
    guiSetText(gui.position_x_edit,tostring(math.floor(x)))
    guiSetText(gui.position_y_edit,tostring(math.floor(y)))
    guiSetText(gui.position_z_edit,tostring(math.floor(z)))
    guiSetText(gui.position_w_edit,"0")
    guiSetText(gui.position_dim_edit,tostring(math.floor(dim)))
end




---------------------------------
-- Activity Status On - Off
---------------------------------
function activity_onoff()
    local x ,y,z,w,dim = get_pos()
    if not x then  outputChatBox(language[language_section].error_type,255,0,0)  guiAlertAnim(main,true)  return end
    settings.activity_status = not settings.activity_status
    if settings.activity_status then 
        guiSetText(gui.activity_status_label,"Etkinliğe Katılma Aktif")
        guiLabelSetColor(gui.activity_status_label,0,255,0)
    else
        guiSetText(gui.activity_status_label,"Etkinliğe Katılma Deaktif")
        guiLabelSetColor(gui.activity_status_label,255,0,0)
    end
    if settings.activity_status then 
        settings.freeze = settings.activity_status
        settings.immortal = settings.activity_status
        settings.ghost_players = settings.activity_status
        settings.ghost_vehicles = settings.activity_status
        settings.x = x 
        settings.y = y
        settings.z = z 
        settings.w = w
        settings.dim = dim
        local limit = guiGetText(gui.player_limit_edit)
        settings.players_limit = tonumber(limit ~="" and limit or 0)
        guiCheckBoxSetSelected(gui.no_damage_players,settings.activity_status)
        guiCheckBoxSetSelected(gui.freeze_players ,settings.activity_status)
        guiCheckBoxSetSelected(gui.no_collision_player,settings.activity_status)
        guiCheckBoxSetSelected(gui.no_collision_vehicle,settings.activity_status)
    end
    triggerServerEvent(rs_name.."_activity_status_change",localPlayer,settings)
end
-----------------------------
--Get Pos
-----------------------------
function get_pos()
    local x ,y,z,w,dim = guiGetText(gui.position_x_edit),guiGetText(gui.position_y_edit),guiGetText(gui.position_z_edit),guiGetText(gui.position_w_edit),guiGetText(gui.position_dim_edit)
    local t = {x=x,y=y,z=z,width=w,dimens=dim}
    local status
    for k,v in ipairs(t) do 
        if type(tonumber(v)) ~= "number" then 
            outputChatBox(language[language_section].error_type,255,0,0)
            print(k,rs_name.." = hatalı")
            status = true 
            break
        end
    end
    if status then return false end
    return tonumber(x),tonumber(y),tonumber(z) ,tonumber(w) ,tonumber(dim)
end
------------------------------------------------
--Get Selected Player
-------------------------------------------------
function get_selected_player()
    local selected = guiGridListGetSelectedItem(player_list)
    if selected ~=-1 then
        local selected_player  = guiGridListGetItemText(player_list ,selected,col1)
        local player = false
        for k,v in pairs(activity_players) do 
            if selected_player == string.gsub(getPlayerName(v), "#%x%x%x%x%x%x", "") then 
                player = v
                break
            end
        end
        return player
    end
end

--------------------------------------------------
-- Finish Activity
--------------------------------------------------
function finish_activity()
    settings.activity_status = false
    guiSetText(gui.activity_status_label,"Etkinliğe Katılma Deaktif")
    guiLabelSetColor(gui.activity_status_label,255,0,0)
    guiGridListClear(player_list)
    triggerServerEvent(rs_name.."_activity_finish",localPlayer)
    triggerServerEvent(rs_name.."_activity_status_change",localPlayer,settings)
    guiSetText(gui.players_count_label,"Oyuncu Sayısı : "..tostring(0))
end


---------------------------------------------------
--Teleport Players
---------------------------------------------------
function teleport_players()
    local x ,y,z,w,dim = get_pos()
    if not x then  outputChatBox(language[language_section].error_type,255,0,0) guiAlertAnim(main,true) return end
    triggerServerEvent(rs_name.."_teleport_players",localPlayer,{x=x,y=y,z=z,w=w,dimens=dim})
end


---------------------------------------------------
--Freeze Players
---------------------------------------------------
function freeze_players()
    settings.freeze = not settings.freeze 
    triggerServerEvent(rs_name.."_freeze_players",localPlayer)
end


---------------------------------------------------
--freeze Player
---------------------------------------------------
function freeze_player()
    local player = get_selected_player()
    if not player then outputChatBox(language[language_section].error_player,255,0,0) guiAlertAnim(player_list,true) return end
    triggerServerEvent(rs_name.."_freeze_player",localPlayer,player)
end
---------------------------------------------------
--Give Weapon Players
---------------------------------------------------
function give_weapon_players()
    local weapon = guiComboBoxGetItemText(gui.weapons_combobox,guiComboBoxGetSelected(gui.weapons_combobox))
    local ammo  = guiGetText(gui.weapon_ammo_edit)
    if weapon then 
        if ammo ~="" then
            local id = getWeaponIDFromName(weapon)
            triggerServerEvent(rs_name.."_give_weapon_players",localPlayer,id,ammo)
        else
            guiAlertAnim(gui.weapon_ammo_edit,true)
        end
    end
end


---------------------------------------------------
--Give Weapon Player
---------------------------------------------------
function give_weapon_player()
    local player = get_selected_player()
    local ammo  = guiGetText(gui.weapon_ammo_edit)
    if not player then outputChatBox(language[language_section].error_player,255,0,0) guiAlertAnim(player_list,true) return end
    local weapon = guiComboBoxGetItemText(gui.weapons_combobox,guiComboBoxGetSelected(gui.weapons_combobox))
    if weapon then 
        if ammo ~="" then
            local id = getWeaponIDFromName(weapon)
            triggerServerEvent(rs_name.."_give_weapon_player",localPlayer,player,id,ammo)
        else
            guiAlertAnim(gui.weapon_ammo_edit,true)
        end
    end
end


---------------------------------------------------
--Take players weapons
---------------------------------------------------
function take_players_weapons()
    triggerServerEvent(rs_name.."_take_players_weapons",localPlayer)
end

---------------------------------------------------
--take player weapon
---------------------------------------------------
function take_player_weapon()
    local player = get_selected_player()
    if not player then outputChatBox(language[language_section].error_player,255,0,0) guiAlertAnim(player_list,true) return end
    local weapon = guiComboBoxGetItemText(gui.weapons_combobox,guiComboBoxGetSelected(gui.weapons_combobox))
    if weapon then 
        local id = getWeaponIDFromName(weapon)
        triggerServerEvent(rs_name.."_take_player_weapon",localPlayer,player,id)
    end
end

--------------------------------------------------
--Players set health
--------------------------------------------------
function set_players_healths()
    local health = guiGetText(gui.health_edit)
    if health ~= "" then 
        health = tonumber(health)
        triggerServerEvent(rs_name.."_set_players_healths",localPlayer,health)
    else 
        guiAlertAnim(gui.health_edit,true)
    end
end

--------------------------------------------------
--Player set health
--------------------------------------------------
function set_player_health()
    local player = get_selected_player()
    if not player then outputChatBox(language[language_section].error_player,255,0,0) guiAlertAnim(player_list,true) return end
    local health = guiGetText(gui.health_edit)
    if  health ~= ""  then 
        health = tonumber(health)
        triggerServerEvent(rs_name.."_set_player_health",localPlayer,player,health)
    else 
        guiAlertAnim(gui.health_edit,true)
    end
end


--------------------------------------------------
--Players set armor
------------------------------------------------get_selected_player--
function set_players_armors()
    local armor = guiGetText(gui.armor_edit)
    if armor ~= "" then 
        armor = tonumber(armor)
        triggerServerEvent(rs_name.."_set_players_armors",localPlayer,armor)
    else
        guiAlertAnim(gui.armor_edit,true)
    end
end

--------------------------------------------------
--Player set armor
--------------------------------------------------
function set_player_armor()
    local player = get_selected_player()
    if not player then outputChatBox(language[language_section].error_player,255,0,0) guiAlertAnim(player_list,true)  return end
    local armor = guiGetText(gui.armor_edit)
    if  armor ~= ""  then 
        armor = tonumber(armor)
        triggerServerEvent(rs_name.."_set_player_armor",localPlayer,player,armor)
    else
        guiAlertAnim(gui.armor_edit,true)
    end
end
----------------------------------------------
--Teleport Admin
---------------------------------------------------
function teleport_admin()
    local x ,y,z,w,dim = get_pos()
    if not x then  outputChatBox(language[language_section].error_type,255,0,0) guiAlertAnim(player_list,true) return end
    triggerServerEvent(rs_name.."_teleport_admin",localPlayer,{x=x,y=y,z=z,w=w,dimens=dim})
end
--------------------------------------------------
-- Activity Player Set List
--------------------------------------------------
function write_players(t,count)
    activity_players = t 
    settings.player_count = count
    guiGridListClear(player_list)
    for k,v in pairs(activity_players) do 
        guiGridListAddRow(player_list,string.gsub(getPlayerName(v), "#%x%x%x%x%x%x", "") )
    end
    guiSetText(gui.players_count_label,"Oyuncu Sayısı : "..tostring(settings.player_count or 0))
end
addEvent(rs_name.."_sent_to_players" ,true)
addEventHandler(rs_name.."_sent_to_players" ,localPlayer,write_players)


-----------------------------------------------------
---Search Players
-----------------------------------------------------
function search_player()
    local text = guiGetText(gui.search_player)
    if text ~= "" then 
        guiGridListClear(player_list)
        for k,v in pairs(activity_players) do 
            local name = string.gsub(getPlayerName(v), "#%x%x%x%x%x%x", "")
            if string.find(string.lower(name),string.lower(text),1,true) then 
                guiGridListAddRow(player_list,name )
            end
        end
    else
        guiGridListClear(player_list)
        for k,v in pairs(activity_players) do 
            local name = string.gsub(getPlayerName(v), "#%x%x%x%x%x%x", "")
            guiGridListAddRow(player_list,name )
        end
    end
end

-------------------------------------------
-- Kick Player Activity
--------------------------------------------
function kick_player()
    local player = get_selected_player()
    if not player then outputChatBox(language[language_section].error_player,255,0,0) guiAlertAnim(player_list,true)  return end
    triggerServerEvent(rs_name.."_kick_player",localPlayer,player)
end

--------------------------------------------
-- set immortal players
---------------------------------------------
function set_immortal_players()
    settings.immortal = not settings.immortal 
    triggerServerEvent(rs_name.."_immortal_players",localPlayer)
end

---------------------------------------------
--Sent to Announcement
--------------------------------------------
function sent_to_announcement()
    local text = guiGetText(gui.announcement_memo)
    if text ~="" then
        triggerServerEvent(rs_name.."_sent_to_announcement",localPlayer,text)
    else
        guiAlertAnim(gui.announcement_memo,true)
    end
end

function sent_to_everyone_announcement()
    local text = guiGetText(gui.announcement_memo)
    if text ~="" then
        triggerServerEvent(rs_name.."_sent_to_everyone_announcement",localPlayer,text)
    else
        guiAlertAnim(gui.announcement_memo,true)
    end
end


-------------------------------------------
-- Announcement  Render
-------------------------------------------
local announcement_text = ""
sx, sy = guiGetScreenSize()
dev_screen = {1920,1080} 
function setScreenPosition (x, y, w, h)
    return ((x / dev_screen[1]) * sx), ((y / dev_screen[2]) * sy), ((w / dev_screen[1]) * sx), ((h / dev_screen[2]) * sy)
end
function render()
    if announcement_text =="" then
        removeEventHandler("onClientRender",root,render)
    else
        local x, y, w, h = setScreenPosition (0,240,1920,200)
        dxDrawText(announcement_text,x,y,w,h,tocolor(0,255,0),1.7,"default","center")
    end
end

local announcement_timers = false 

function set_announcement(text)
    if isTimer(announcement_timers) then 
        killTimer(announcement_timers) 
        announcement_timers = false
    else
        addEventHandler("onClientRender",root,render)
    end
    announcement_text = text
    announcement_timers = setTimer(function()
        announcement_text = ""
        announcement_timers = false
    end,time_announcement,1)
end
addEvent(rs_name.."_sent_announcement",true)
addEventHandler(rs_name.."_sent_announcement",localPlayer,set_announcement)

------------
--Block fire
---------------
function blocked_fire()
    settings.fire = not settings.fire
    triggerServerEvent(rs_name.."_blocked_fire",localPlayer)
end

----------------------
--Ghost Players
----------------------

function ghost_players()
    settings.ghost_players = not settings.ghost_players
    triggerServerEvent(rs_name.."_ghost_players",localPlayer)
end


function on_off_ghost_mode(state) 
    for i,v in pairs (getElementsByType("player")) do 
        setElementCollidableWith(v, localPlayer,state) 
    end
end
addEvent(rs_name.."_ghost_players_state",true)
addEventHandler(rs_name.."_ghost_players_state",localPlayer,on_off_ghost_mode)



-------------------------------------
--sent to countdown
-------------------------------------
function sent_countdown()
    local countdown = guiGetText(gui.countdown_edit)
    if countdown ~= "" then 
        countdown = tonumber(countdown)
        triggerServerEvent(rs_name.."_sent_to_countdown",localPlayer,countdown)
    else
        guiAlertAnim(gui.countdown_edit,true)
    end
end

local countdown_timers = false 
local countdown_count = 0

function render_count_down()
    if countdown_count <= 0 then
        removeEventHandler("onClientRender",root,render_count_down)
        countdown_timers = false
    else
        local x, y, w, h = setScreenPosition (0,240,1920,400)
        dxDrawText(tostring(countdown_count),x,y,w,h,tocolor(0,255,0),2.7,"default","center")
    end
end


function type_to_countdown(countdown)
    countdown_count = countdown
    if isTimer(countdown_timers) then 
        killTimer(countdown_timers) 
        countdown_timers = false
    else
        addEventHandler("onClientRender",root,render_count_down)
    end
    countdown_timers = setTimer(function()
        countdown_count =  countdown_count  - 1
    end,1000,countdown)
end
addEvent(rs_name.."_sent_countdown_client",true)
addEventHandler(rs_name.."_sent_countdown_client",localPlayer,type_to_countdown)


------------------------------------------------------------
-- Set Activity Player Limit
----------------------------------------------------------
function set_activity_player_limit()
    local limit = guiGetText(gui.player_limit_edit)
    if limit ~= "" then 
        limit = tonumber(limit)
        triggerServerEvent(rs_name.."_set_to_activity_player_limit",localPlayer,limit)
        settings.players_limit = limit
    else
        guiAlertAnim(gui.player_limit_edit,true)
    end
end



-------------------------------------------------------------
--Give Vehicle to players 
-------------------------------------------------------------
function give_vehicle_to_players()
    local id = guiGetText(gui.vehicle_id_edit)
    if id ~= "" then 
        id = tonumber(id)
        triggerServerEvent(rs_name.."_give_vehicle_to_players",localPlayer,id)
    else
        guiAlertAnim(gui.vehicle_id_edit,true)
    end
end


-----------------------------------
---Fix Vehicle
-------------------------------------
function fix_vehicle()
    triggerServerEvent(rs_name.."_fix_vehicles",localPlayer)
end

--------------------------------
-- Ghost Vehicles
--------------------------------
function ghost_vehicles()
    settings.ghost_vehicles = not settings.ghost_vehicles
    triggerServerEvent(rs_name.."_ghost_vehicles",localPlayer)
end


function on_off_ghost_mode_vehicles(state,vehicles) 
    local vehicles = getElementsByType('vehicle' , getResourceRootElement(getThisResource()), true)
    for i,v in ipairs (vehicles) do 
        for l,a in ipairs (vehicles) do
            if v ~= a then
                setElementCollidableWith(a, v,state) 
            end
        end
        setElementCollidableWith(v,localPlayer,state)
    end
end
addEvent(rs_name.."_ghost_vehicles_state",true)
addEventHandler(rs_name.."_ghost_vehicles_state",localPlayer,on_off_ghost_mode_vehicles)

----------------------------------------------------
--No exit Vehicle
----------------------------------------------------
function no_exit_vehicle()
    settings.no_exit_vehicles = not settings.no_exit_vehicles
    triggerServerEvent(rs_name.."_no_exit_vehicles",localPlayer)
end

-------------------------------------------------------------
--Remove All Vehicles
--------------------------------------------------------------
function remove_vehicles()
    triggerServerEvent(rs_name.."_remove_vehicles",localPlayer)
end

------------------------------------------------------------
--remove player vehicle
-----------------------------------------------------------
function remove_player_vehicle()
    local player = get_selected_player()
    if not player then outputChatBox(language[language_section].error_player,255,0,0) guiAlertAnim(player_list,true)  return end
    triggerServerEvent(rs_name.."_remove_player_vehicle",localPlayer,player)
end


------------------------------------------------------------
--give player vehicle
-----------------------------------------------------------
function give_player_vehicle()
    local player = get_selected_player()
    if not player then outputChatBox(language[language_section].error_player,255,0,0) guiAlertAnim(player_list,true)  return end
    local id = guiGetText(gui.vehicle_id_edit)
    if id ~= "" then 
        id = tonumber(id)
        triggerServerEvent(rs_name.."_give_player_vehicle",localPlayer,player,id)
    else
        guiAlertAnim(gui.vehicle_id_edit,true)
    end
end

-------------------------------------------------------
--create map vehicle
-------------------------------------------------------
function create_map_vehicle()
    local select_map = guiComboBoxGetItemText(gui.map_cars_combobox,guiComboBoxGetSelected(gui.map_cars_combobox))
    if select_map =="" or select_map == "Harita Seç" then 
        guiAlertAnim(gui.map_cars_combobox,true)
    else
        triggerServerEvent(rs_name.."_create_map_vehicle",localPlayer,select_map)
    end

end

---------------------------------------------
--Teleport players created vehicles
---------------------------------------------
function teleport_players_created_vehicles()
    triggerServerEvent(rs_name.."_teleport_players_created_vehicles",localPlayer)  
end
--------------------------------------------------------------
-- Player Join Or Leave Activity
--------------------------------------------------------------
function cancel_key(button,press)
    for i,v in pairs(keys) do 
        local veri, tus = unpack(v) 
        if tus[button]  then 
           cancelEvent() 
        end
     end 
end
function player_status(state)
    if state then 
        addEventHandler("onClientKey", root, cancel_key)
    else
        removeEventHandler("onClientKey", root, cancel_key)
    end 
end
addEvent(rs_name.."_join_or_leave_activity",true)
addEventHandler(rs_name.."_join_or_leave_activity",localPlayer,player_status)




-----------------------
--sonradan silin
-----------------------
addCommandHandler("konumal",function(cmd,id)
    if not id then outputChatBox("id yazın") return end
    local text = "{%s,%s,%s,%s,%s},"
    local x,y,z = getElementPosition(localPlayer)
    local _,_,rz = getElementRotation(localPlayer)
    text  = text:format(id,x,y,z,rz)
    setClipboard(text)
    outputChatBox("kopyalama başarılı")
end)



