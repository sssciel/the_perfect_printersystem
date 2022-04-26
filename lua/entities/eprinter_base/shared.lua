
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Printer base"
ENT.Spawnable = false
ENT.Category = 'enmanish'

ENT.PrinterModel = 'models/animeworld/feromon/printer/printer_e.mdl' -- модель принтера
ENT.MoneyAmount = 100 -- кол-во поинтов, которые он печатает
ENT.TempAdd = 0.5 -- сколько градусов прибавляется
ENT.PrinterHealth = 100 -- здоровье принтера
ENT.IsVIP = false -- Принтер для VIP
ENT.Rechargeprice = 2500
ENT.Limit = 3

function ENT:SetupDataTables()
	self:NetworkVar("Int",1,"Money")
	self:NetworkVar("Int",6,"PHealth")
	self:NetworkVar("Float",2,"Charge")
	self:NetworkVar("Entity",3,"owning_ent")
	self:NetworkVar("Float",4,"TempRate")
	self:NetworkVar("Bool",5,"toggle")
	self:NetworkVar("Float",11,"PTemp")
	self:NetworkVar("Bool",12,"Destroyed")
	self:NetworkVar("Entity",23,"Activator")
end