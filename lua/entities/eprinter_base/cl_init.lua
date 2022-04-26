include("shared.lua")
include("autorun/client/cl_derma_settings.lua")
local config = DermaConfig

surface.CreateFont("MainText", {font = "Tahoma", size = 30, weight = 1000, shadow = false, antialias = true})
surface.CreateFont("SmallText", {font = "Tahoma", size = 17, weight = 1000, shadow = false, antialias = true})
function ENT:Initialize()


--sound--
	self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
    self.sound:SetSoundLevel(52)
	self.sound:PlayEx(1, 100)
	

	
--Initail temperature display color--	
	self.TempColor = Color(255,255,255)
	
--initailizing spin vars--
	self.spin = 0
	self.spin2 = 0
	
end

function ENT:OnRemove()

	--stopping sound on remove and deleting external models--
	if self.sound then
		self.sound:Stop()
	end

end

surface.CreateFont("hud_printer_display", {size = 160, weight = 450, antialias = true, extended = true, font = "Montserrat Medium"})

function ENT:Draw()

	
	self:DrawModel()
	
	self.Angle = self:GetAngles()
	self.Pos = self:GetPos()
	
	--Cam3D2D Panal top and display--
	self.Angle:RotateAroundAxis(self.Angle:Up(), 180)
	cam.Start3D2D(self.Pos + self.Angle:Up() *8.9 , self.Angle , 0.03)

	if IsValid(self:GetNWEntity("p_owner")) then

		draw.DrawText( self:GetNWEntity("p_owner"):Nick(), "hud_printer_display", 3, -700, color_white,1)

	else

		draw.DrawText( "Неизвестно", "hud_printer_display", 3, -700, color_white,1)

	end

	cam.End3D2D() 

end
