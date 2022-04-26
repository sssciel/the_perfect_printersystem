if SERVER then
    include("printer_system/config.lua")
    AddCSLuaFile("printer_system/config.lua")
    AddCSLuaFile("printer_system/server/net_functions.lua")
    include("printer_system/server/net_functions.lua")
    AddCSLuaFile("printer_system/client/printer_cl.lua")
    AddCSLuaFile("printer_system/client/printer_menu.lua")
else
    include("printer_system/config.lua")
    include("printer_system/client/printer_cl.lua")
    include("printer_system/client/printer_menu.lua")
end