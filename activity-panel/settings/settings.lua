------------------------
-- Panel Open command  and ACL
panel_command = "activity"
panel_acl = "Admin"


--------------------------
--immortal data ölümsüzlük datası 
--------------------------------
immortal_data = "ölümsüz"
------------------------
--Activity Join Command
------------------------
activity_cmd = "katil"
activity_leave_cmd = "ayril"
---------------------------
--resource_name 
----------------------------
rs_name = getResourceName(getThisResource())

--------------------------------
--Announcement timer
-------------------------------
time_announcement = 5000

-------------------------
-- Language
-------------------------
language = {}
language_section = "tr"
language["tr"] = {
    activity_joined =  "Zaten katılmışsın",

    activity_started = "Etkinliğe Katılma Kapalı",

    activity_join = "Etkinliğe Katıldın",

    activity_leaved = "Etkinlikten Ayrıldın",

    activity_finished ="Etkinlik Bitti.",

    error_type = "X Y Z W H VE DİMENS'i kontrol ediniz.",

    error_player = "Oyuncu Seçiniz.",

    give_health_players = "Oyunculara %s can verdin.",

    give_health_player = "%s Adlı oyuncuya %s can verdin",

    give_armor_player = "Oyunculara %s zırh verdin.",

    give_armor_player = "%s Adlı oyuncuya %s zırh verdin",

    freeze_players = "Tüm oyuncular dondu",

    freeze_player = "%s Adlı oyuncuyu dondurdun.",

    kick_player = "%s Adlı oyuncuyu attın.",

    give_weapons_players = "%s Silahını tüm oyunculara verdin.",

    give_weapon_player = " %s Silahını %s adlı oyuncuya verdin.",

    take_weapons_players = "%s Adlı silahı tüm oyunculardan aldın",

    take_weapon_player = " %s Adlı silahı ",

    ghost_vehicle = "Araç hayalet modunu açtın.",

    ghost_player_on = "Oyuncu hayalet modunu açtın.",
    
    ghost_player_off = "Oyuncu hayalet modunu kapattın.",

    blocke_exit_vehicle = "Oyuncunun araçtan inmesini engelleme açtın.",

    god_mode_player_on = "Oyuncu hasar yeme engelleme açtın",

    god_mode_player_off = "Oyuncu hasar yeme engelleme kapadın.",

    send_announcement_activity_player = "Etkinlik oyuncularına duyuru gönderdin.",
    
    send_announcement_all_player = "Tüm oyunculara duyuru gönderdin",

    give_vehicle_players = "%s adlı aracı tüm oyunculara verdin",

    give_vehicle_player = "%s adlı aracı %s adlı oyuncuya verdin.",

    take_vehicles = "Tüm araçları kaldırdın.",

    take_player_vehicle = "%s adlı oyuncudan aracı aldın.",

    teleports_players = "Tüm oyuncular ışınlandı.",

    blocke_fire_on = "Ateş Etme Aktif.",

    blocke_fire_off = "Ateş etme deaktif",

    countdown_sent = "%s geri sayım süresi aktif edildi.",

    limit_players = "Etkinlikte yer kalmadı!",

    no_player = "Böyle bir oyuncu mevcut değil!",

    no_id = "%s böyle bir araç bulunamadı!",

    finish_countdown = "%s geri sayım süresi bitmiştir."

}


---------------------------------------
--Banned Keys
---------------------------------------
keys = {   
    {"", -- görevin datası
       {
       ["F1"] = true, -- iptal edilcek tuş
      ["B"] = true,
       }  
    },   
 }


 -----------------------
 -- notification  bildirim
 -------------------------
 notification = false



----Teleport Selected Player Coommand
tp_player_cmd = "cek"

----remove vehicle command
remove_veh_cmd = "kaldir"

--------------
--Blocked controls
controls = {"fire","next_weapon","aim_weapon","previous_weapon","action",}

--------------------------------
--Maps Vehicle
--------------------------------
maps = {}
--example 


-- maps["Harita 1"] = {
--     {id,x,y,z,rz},
--     {411,1,2,3,0},
--     {411,2,4,3,0},
-- }

maps["Harita 1"] = {
    {411,1,2,3,0},
    {411,2,4,3,0},
}

maps["Harita 2"] = {
    {411,1,2,3,0},
    {411,2,4,3,0},
}

