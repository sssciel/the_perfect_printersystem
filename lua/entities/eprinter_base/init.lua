
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("ActiveP")
util.AddNetworkString("withdrawp")
util.AddNetworkString("RechargeP")
util.AddNetworkString("Togglep")

function ENT:Initialize()
	self:SetModel(self.PrinterModel) 

	self:SetActivator(nil)
	
	self:SetTempRate(self.TempAdd)
	self:SetDestroyed(false)
	self:SetPTemp(printerss.InitHeat)
	self:Settoggle(true)
	self:SetCharge(180)
	self:SetNWInt('Health',self.PrinterHealth)
	
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	
	self.PrinterHealthh = self.PrinterHealth 
	self.timer = CurTime()
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmg)
	self:TakePhysicsDamage(dmg)
	if(self.PrinterHealthh <= 0) then return end
 
	self.PrinterHealthh = self.PrinterHealthh - dmg:GetDamage(); 
	self:SetNWInt('Health',self.PrinterHealthh)
 
	if(self.PrinterHealthh <= 0) then 
		self:SetDestroyed(true)
		self:Destruct()
		self:Remove() 
	end
end

function ENT:Destruct()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetStart(vPoint)
    effectdata:SetOrigin(vPoint)
    effectdata:SetScale(1)
    util.Effect("Explosion", effectdata)
	if IsValid(self:Getowning_ent()) then DarkRP.notify(self:Getowning_ent(), 1, 4, "Ваш принтер уничтожен") end
	if #self:Getowning_ent().printers == 0 then return end
	for i = 1, #self:Getowning_ent().printers do
		if tonumber(self:Getowning_ent().printers[i]) == self:EntIndex() then 
			table.remove(self:Getowning_ent().printers, i)
			self:Getowning_ent():SetNWInt('prints_amount',self:Getowning_ent():GetNWInt('prints_amount')-1)
			net.Start("destroypr_cl")
			net.WriteString(i)
			net.Send(self:Getowning_ent())
		end
	end
	self:Getowning_ent():SetNWInt("pr_amo"..self:GetClass(),self:Getowning_ent():GetNWInt("pr_amo_"..self:GetClass())-1)
end

function ENT:Think()
	if CurTime() > self.timer + 2 then
		self.timer = CurTime()
		if self:Gettoggle() == true then
			if  self:GetCharge() > 0 then

				self:SetPTemp(self:GetPTemp() + self.TempAdd)
				self:SetMoney(self:GetMoney() + self.MoneyAmount)
				self:SetCharge(self:GetCharge() - 0.3)

				if self:GetPTemp() > printerss.ThrdTemp then
					--self:SetDestroyed(true)
					--self:Ignite( 30 )
					if !self.notified then
						DarkRP.notify(self:Getowning_ent(), 0, 15, "Ваш принтер скоро перегреется")
						self.notified = true
					end

				end
				
				if self:GetPTemp() > printerss.MaxTemp then
					self:Destruct()	
					self:Remove()
				end
				
			else

				self:Settoggle(false)
				
			end
		else

			if self:GetPTemp() > (printerss.InitHeat + 1) then
				self:SetPTemp(self:GetPTemp() - 1)
			end

			self.notified = false
			
		end
	end
	
	
end

net.Receive("RechargeP", function(len, ply)
	local pri = ents.GetByIndex(tonumber(net.ReadString()))
	if ply:canAfford(pri.Rechargeprice) == true then
		ply:addMoney(-pri.Rechargeprice)
		pri:SetCharge(180)
		DarkRP.notify(ply, 0, 4, "Вы зарядили принтер!")
	else
		DarkRP.notify(ply, 0, 4, "У вас недостаточно денег!")
	end
end)

net.Receive("Togglep", function(len, ply)
	pri = ents.GetByIndex(tonumber(net.ReadString()))
	if pri:Gettoggle() then
		pri:Settoggle(false)
	else
		pri:Settoggle(true)
	end
end)