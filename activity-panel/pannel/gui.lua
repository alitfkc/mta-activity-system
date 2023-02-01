gui = {}
local properties = {}
-------------
-- Create Window Main
--------------------
properties.main_window_property  = {
    bindkey = pannel_key,    sizing = "False",
}

main = guiCreateWindow(0.21, 0.12, 0.53, 0.62, "Atatürk Gaming - Activity Pannel", true,properties.main_window_property)


player_list = guiCreateGridList(0.01, 0.14, 0.38, 0.84, true,main)
col1 = guiGridListAddColumn(player_list, "Players", 0.9)

-------------------
-- Search Player ( - Oyuncu Ara -)
-------------------
properties.search_player_property = {
    changed = search_player,
}

gui.search_player = guiCreateEdit(0.01, 0.05, 0.12, 0.08, "Oyuncu Ara", true,main,properties.search_player_property)    






---------------------
-- Activity position X
--------------------

properties.position_x_property = {
    only_number = true,
    max_length = 6,
    tooltip = "X pozisyonu",
}
gui.position_x_edit = guiCreateEdit(0.4, 0.08, 0.1, 0.065, "", true,main,properties.position_x_property )

---------------------
-- Activity position y
--------------------

properties.position_y_property = {
    only_number = true,
    max_length = 6,
    tooltip = "Y pozisyonu"

}
gui.position_y_edit = guiCreateEdit(0.52, 0.08, 0.1, 0.065,"", true,main,properties.position_y_property )

---------------------
-- Activity position Z
--------------------

properties.position_z_property = {
    only_number = true,
    max_length = 6,
    tooltip = "Z pozisyonu"

}
gui.position_z_edit = guiCreateEdit(0.64, 0.08, 0.1, 0.065, "", true,main,properties.position_z_property)

---------------------
-- Activity position Width
--------------------

properties.position_w_property = {
    only_number = true,
    max_length = 6,
    tooltip = "Genişlik"
}
gui.position_w_edit = guiCreateEdit(0.76, 0.08, 0.1, 0.065, "", true,main,properties.position_w_property)

---------------------
-- Activity Dimension
--------------------

properties.position_dim_property = {
    only_number = true,
    max_length = 12,
    tooltip = "Etkinlik Dimens"
}
gui.position_dim_edit = guiCreateEdit(0.88, 0.08, 0.1, 0.065, "", true,main,properties.position_dim_property)


----------------------
--- X Y Z Widht Text
----------------------
gui.label_pos = guiCreateLabel(0.32, 0.04, 0.6, 0.03, "       X                    Y                    Z                 Genişlik           Dimens", true,main)

---------------------
-- Activity on/off
--------------------
properties.activity_onoff_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Etkinliği Açma Kapatma",
    click = activity_onoff,
}
gui.activity_onoff_btn = guiCreateButton(0.4, 0.18, 0.12, 0.08, "Etkinliği Aç/Kapa", true,main,properties.activity_onoff_property)

---------------------------
-- Activity Status Label---
---------------------------
properties.activity_status_property = {
    horizontal_align ="left",
    font="default-bold-small",

}
gui.activity_status_label = guiCreateLabel(0.12,0.07,0.27,0.05,"Etkinliğe Katılma Deaktif",true,main,properties.activity_status_property)
guiLabelSetColor(gui.activity_status_label,255,0,0)
---------------------
-- Kick Player
--------------------
properties.kick_player_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FFFF0000",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Seçilen Oyuncuyu Atma",
    click = kick_player,
}

gui.kick_player_btn = guiCreateButton(0.87, 0.18, 0.12, 0.08, "Oyuncuyu At", true,main,properties.kick_player_property )

---------------------
-- Teleport Players
--------------------
properties.teleport_players_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF9900BB",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Oyuncuları Işınla",
    click = teleport_players,
}

gui.teleport_players_btn = guiCreateButton(0.715, 0.18, 0.12, 0.08, "Oyuncuları Işınla", true,main,properties.teleport_players_property)

---------------------
-- Activity Finish It
--------------------
properties.activity_finish_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FFFF0000",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Etkinliği Bitirme \nTüm Oyuncuları Eventten Çıkartır.\nEtkinlik Sıfırlanır.",
    click = finish_activity,
}
gui.activity_finish_btn = guiCreateButton(0.555, 0.18, 0.12, 0.08, "Etkinlik Bitir", true,main,properties.activity_finish_property )

---------------------------------------
--Give Players Weapon
----------------------------------------
properties.give_players_weapon_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FFff7f00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Etkinlikteki Oyunculara \nSilah Verme.",
    click =  give_weapon_players,
}

gui.give_players_weapon_btn = guiCreateButton(0.4, 0.3, 0.12, 0.08, "Oyunculara Silah Ver", true,main,properties.give_players_weapon_property )


---------------------
-- Activity Dimension
--------------------

properties.weapon_ammo_property = {
    only_number = true,
    max_length = 9,
    tooltip = "Silah Mermisi"
}
gui.weapon_ammo_edit = guiCreateEdit(0.715, 0.3, 0.12, 0.08, "9999", true,main,properties.weapon_ammo_property)



-------------------------------------------
---Give Player Weapon
-------------------------------------------
properties.give_player_weapon_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FFff7f00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Listeden Seçilen Oyuncuya \nSilah Verme.",
    click = give_weapon_player,
}

gui.give_player_weapon_btn = guiCreateButton(0.87, 0.3, 0.12, 0.08,"Oyuncuya Silah Ver", true,main,properties.give_player_weapon_property)


-----------------------------------
--Weapons Combo Box
-----------------------------------

gui.weapons_combobox = guiCreateComboBox(0.54, 0.325, 0.15, 0.4, "AK-47", true,main)

for i=1,46 do 
    guiComboBoxAddItem(gui.weapons_combobox,getWeaponNameFromID(i))
end

-------------------------------------------
---Set Players Health
-------------------------------------------
properties.set_players_health_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FFAA0000",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Etkinlikteki Oyuncuların\nCanlarını değiştir.",
    click = set_players_healths ,
}
gui.set_players_health_btn = guiCreateButton(0.4, 0.42, 0.12, 0.08, "Oyuncu Canlarını Ayarla", true,main,properties.set_players_health_property )

---------------------------------
--Health Edit -------------------
---------------------------------
properties.health_property = {
    only_number = true,
    max_length = 3,
    tooltip = "Can Ayarlama 0-100"
}
gui.health_edit = guiCreateEdit(0.5555, 0.42, 0.12, 0.08, "", true,main,properties.health_property)


-------------------------------------------
---Set Player Health
-------------------------------------------
properties.set_player_health_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FFAA0000",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Liseden Seçilen Oyuncunun\nCanını değiştir.",
    click = set_player_health,
}
gui.set_player_health_btn = guiCreateButton(0.715, 0.42, 0.12, 0.08, "Oyuncu Canını Ayarla", true,main,properties.set_player_health_property)


-------------------------------------------
---Set Players Armor
-------------------------------------------
properties.set_players_armor_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF808080",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Etkinlikteki Oyuncuların\nZırhlarını değiştir.",
    click = set_players_armors,
}

gui.set_players_armor_btn = guiCreateButton(0.4, 0.54, 0.12, 0.08, "Oyuncu Zırhlarını Ayarla", true,main,properties.set_players_armor_property)

---------------------------------
--Armor Edit -------------------
---------------------------------
properties.armor_property = {
    only_number = true,
    max_length = 3,
    tooltip = "Zırh Ayarlama 0-100"
}
gui.armor_edit = guiCreateEdit(0.555, 0.54, 0.12, 0.08, "", true,main,properties.armor_property)

-------------------------------------------

-------------------------------------------
---Set Player Armor
-------------------------------------------
properties.set_player_armor_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF808080",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Listeden seçilen oyuncunun\nZırhını değiştir.",
    click = set_player_armor,
}
gui.set_player_armor_btn = guiCreateButton(0.715, 0.54, 0.12, 0.08, "Oyuncu Zırhını Ayarla", true,main,properties.set_player_armor_property )


--------------
--Freeze All players
-------------------
properties.freeze_players_property = {
    click = freeze_players,
    normal_text_color = "FFadd8e6",
}

gui.freeze_players = guiCreateCheckBox(0.405, 0.64, 0.23, 0.04, "Oyuncuları Dondurma", false, true,main,properties.freeze_players_property )

----------------------------------
-- no Damage players
----------------------------------
properties.no_damage_players_property = {
    click = set_immortal_players,
}

gui.no_damage_players = guiCreateCheckBox(0.405, 0.7, 0.23, 0.05, "Oyuncu Hasar Yeme Engel", false, true,main,properties.no_damage_players_property )

----------------------------------
-- no Fire players
----------------------------------
properties.no_fire_players_property = {
    click = blocked_fire,
}

gui.no_fire_players = guiCreateCheckBox(0.405, 0.76, 0.23, 0.05, "Ateş Etme Engel", false, true,main,properties.no_fire_players_property )

----------------------------------
-- no Collision Vehicle
----------------------------------
properties.no_collision_vehicle_property = {
    click = ghost_vehicles,
}

gui.no_collision_vehicle = guiCreateCheckBox(0.405, 0.82, 0.23, 0.05, "Araç Hayalet", false, true,main,properties.no_collision_vehicle_property )


----------------------------------
-- no Collision Vehicle
----------------------------------
properties.no_collision_player_property = {
    click = ghost_players,
}

gui.no_collision_player = guiCreateCheckBox(0.405, 0.88, 0.23, 0.05, "Oyuncu Hayalet", false, true,main,properties.no_collision_player_property )


----------------------------------
-- vehicle exit blocked
----------------------------------
properties.no_exit_vehicle_property = {
    click = no_exit_vehicle,
}

gui.no_exit_vehicle = guiCreateCheckBox(0.405, 0.95, 0.23, 0.05, "Araçtan İnme Engel", false, true,main,properties.no_exit_vehicle_property )




----------------------------------
-- Activity Announcement Memo
----------------------------------
properties.announcement_memo_property  = {
    tooltip = "Herkese Duyuru Gönder.",
}
gui.announcement_memo = guiCreateMemo(0.715,0.64,0.27,0.35,"",true,main,properties.announcement_memo_property)




---Burada bunu yaptım çünkü true olarak kullanınca
guiSetSize(main,0.68,0.68,true)



----------------------------------
-- Sent Announcement Button
----------------------------------
properties.announcement_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Etkinliktekilere Duyuru Gönder.",
    click = sent_to_announcement,
}
gui.announcement_btn = guiCreateButton(0.555,0.92,0.1,0.08,"Etkinkik Oyuncularına Duyuru Gönder",true,main,properties.announcement_property)


----------------------------------
-- Sent Announcement Button
----------------------------------
properties.announcement_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Herkese Duyuru Gönder.\n Etkinliktekiler hariç.",
    click = sent_to_everyone_announcement,
}
gui.announcement_everyone_btn = guiCreateButton(0.67,0.92,0.1,0.08,"Herkese Duyuru Gönder",true,main,properties.announcement_property)



----------------------------------
-- Teleport Activity Admin
----------------------------------
properties.teleport_admin_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Etkinlik Alanına Işınlan",
    click = teleport_admin,
}
gui.teleport_admin_btn = guiCreateButton(0,0.9,0.12,0.08,"Işınlan",true,main,properties.teleport_admin_property)


--------------------------------------------
-- Take Players Weapon
--------------------------------------------

properties.take_players_weapon_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FFff7f00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "tüm oyuncuların silahlarını alır.",
    click = take_players_weapons,
}

gui.take_players_weapon_btn = guiCreateButton(0.78, 0.275, 0.1, 0.075,"Oyuncuların Silahlarını Al", true,main,properties.take_players_weapon_property)



-------------------------------------------
---Take Player Weapon
-------------------------------------------
properties.take_player_weapon_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FFff7f00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Listeden Seçilen Oyuncudab \nSilah Alma.",
    click = take_player_weapon,
}

gui.take_player_weapon_btn = guiCreateButton(0.89, 0.275, 0.1, 0.075,"Oyuncudan Silah Al", true,main,properties.take_player_weapon_property)


-------------------------------------------
---Freeze Player
-------------------------------------------
properties.freeze_player_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FFadd8e6",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Listeden Seçilen Oyuncuyu \nDondur.",
    click = freeze_player,
}

gui.freeze_player_btn = guiCreateButton(0.78, 0.16, 0.22, 0.075,"Oyuncu dondur", true,main,properties.freeze_player_property)


-------------------
-- set pos
-------------------
properties.set_pos_property = {
    click = set_text_pos,
    tooltip = "X Y Z'ye olduğun konumu ve dimensi\nyazar."
}   

gui.set_pos = guiCreateButton(0.78, 0.06, 0.22, 0.08, "Konumunu Ekle", true,main,properties.set_pos_property)    


--------------------
--Vehicle İD Edit
-------------------

properties.vehicle_id_property = {
    only_number = true,
    max_length = 6,
    tooltip = "Araç ID",
}
gui.vehicle_id_edit = guiCreateEdit(0.67, 0.38, 0.1, 0.075, "", true,main,properties.vehicle_id_property)



-------------------------------------------
---give vehicle to players
-------------------------------------------
properties.give_vehicle_players_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF7F7FFF",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Oyunculara araç verir",
    click = give_vehicle_to_players,
}

gui.give_vehicle_players_btn = guiCreateButton(0.78, 0.38, 0.1, 0.075,"Oyunculara Araç Ver", true,main,properties.give_vehicle_players_property)

-------------------------------------------
---fix vehicles
-------------------------------------------
properties.fix_vehicle_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF7F7FFF",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Tüm Araçları Tamir eder",
    click = fix_vehicle,

}

gui.fix_vehicle_btn = guiCreateButton(0.89, 0.49, 0.1, 0.075,"Araçları Tamir Et", true,main,properties.fix_vehicle_property)

-------------------------------------------
---give vehicle to player
-------------------------------------------
properties.give_vehicle_player_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF7F7FFF",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Oyunculara araç verir",
    click=give_player_vehicle,
}

gui.give_vehicle_player_btn = guiCreateButton(0.89, 0.38, 0.1, 0.075,"Oyuncuya Araç Ver", true,main,properties.give_vehicle_player_property)





-------------------------------------------
---take vehicle to players
-------------------------------------------
properties.take_vehicle_players_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF7F7FFF",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Oyunculara araç verir",
    click=remove_vehicles,
}

gui.take_vehicle_players_btn = guiCreateButton(0.67, 0.49, 0.1, 0.075,"Araçları Kaldır", true,main,properties.take_vehicle_players_property)

-------------------------------------------
---take vehicle to player
-------------------------------------------
properties.take_vehicle_player_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF7F7FFF",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Oyunculara araç verir",
    click = remove_player_vehicle,
}

gui.take_vehicle_player_btn = guiCreateButton(0.78, 0.49, 0.1, 0.075,"Oyuncudan Araç Al", true,main,properties.take_vehicle_player_property)



--------------------
--countdown
-------------------

properties.countdown_property = {
    only_number = true,
    tooltip = "Geri Sayım Süresi",
}
gui.countdown_edit = guiCreateEdit(0.78, 0.59, 0.1, 0.075, "", true,main,properties.countdown_property)

-------------------------------------------
---countdown button
-------------------------------------------
properties.countdown_btn_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Geri Sayım",
    click=sent_countdown,
}

gui.countdown_btn = guiCreateButton(0.89, 0.59, 0.1, 0.075,"Gerisayım", true,main,properties.countdown_btn_property)


--------------------
--Player Limit
-------------------

properties.player_limit_property = {
    only_number = true,
    tooltip = "Oyuncu Sayısı",
}
gui.player_limit_edit = guiCreateEdit(0.78, 0.69, 0.1, 0.075, "61", true,main,properties.player_limit_property)

-------------------------------------------
---countdown button
-------------------------------------------
properties.player_limit_btn_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Oyuncu Sayısı Ayarla",
    click = set_activity_player_limit,
}

gui.player_limit_btn = guiCreateButton(0.89, 0.69, 0.1, 0.075,"Oyuncu Sayısı Ayarla", true,main,properties.player_limit_btn_property)

---------------------------
-- Activity Status Label---
---------------------------
properties.players_count_property = {
    horizontal_align ="left",
    font="default-bold-small",
}
gui.players_count_label = guiCreateLabel(0.17,0.93,0.27,0.05,"Oyuncu Sayısı : 0",true,main,properties.players_count_property)


-----------------------------------
--Maps Cars Combo Box
-----------------------------------
properties.map_cars_property = {
    tooltip = "Haritaya koyulacak araçlar",
}

gui.map_cars_combobox = guiCreateComboBox(0.78, 0.8, 0.1, 0.4, "Harita Seç", true,main,properties.map_cars_property)

for k,v in pairs(maps) do 
    guiComboBoxAddItem(gui.map_cars_combobox,k)
end

-------------------------------------------
---Create Map vehicles
-------------------------------------------
properties.create_map_vehicles_btn_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF7F7FFF",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Haritada araç oluştur",
    click = create_map_vehicle,
}

gui.create_map_vehicles_btn = guiCreateButton(0.89, 0.78, 0.1, 0.075,"Haritada Araç oluştur", true,main,properties.create_map_vehicles_btn_property)

-------------------------------------------
---Teleport players to vehicle
-------------------------------------------
properties.teleport_players_to_vehicle_btn_property = {
    hover_text_color = "FF00AA00",
    normal_text_color = "FF7F7FFF",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    tooltip = "Oyuncuları Araçlara Işınlar",
    click = teleport_players_created_vehicles,
}

gui.teleport_players_to_vehicle_btn = guiCreateButton(0.78, 0.88, 0.22, 0.125,"Oyuncuları Araçlara Işınla", true,main,properties.teleport_players_to_vehicle_btn_property)








properties = nil
guiSetVisible(main,false)