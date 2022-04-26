local minprice = printerss.MinPrice
local maxprice = printerss.MaxPrice

local function createmenu()

	if !(LocalPlayer():GetActiveWeapon():GetClass() == 'printer_tablet' ) then return LocalPlayer():ChatPrint('У вас в руках должен быть планшет') end
	local price_hour = GetGlobalInt('printer_pricehour'..GetGlobalInt('printer_hournow'))
	local hournow = GetGlobalInt('printer_hournow')

	local printers_ = printerss.Printers

	local mainpanel = vgui.Create("DFrame")
	mainpanel:SetSize( 768, 610 )
	mainpanel:Center()
	mainpanel:MakePopup()
	mainpanel:SetTitle( "" )
	mainpanel:SetDraggable( false )
	mainpanel:ShowCloseButton(false)
	--mainpanel:SetDraggable( false )
	mainpanel.Paint = function( self, w, h )
        DrawBDBlur(self,2)
        draw.RoundedBox(8, 0, 0, w, h, Color(20,20,20,150))	
      	draw.RoundedBox(8,0,0,w,40,Color(137,33,107))
      	surface.DrawTexturedRect_Borders("right",8,0,0,w,40,Color(218,63,83))
      	draw.SimpleText('BlackMarket | Подпольный магазин',"hud_subs_n",10,3,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
      	draw.SimpleText('Ваш баланс: '..(LocalPlayer():GetNWInt('blackpoints') or 0).. ' BP',"hud_subs",mainpanel:GetWide()-20,53,color_white,TEXT_ALIGN_RIGHT)
    end

    local mainpanel_closee = vgui.Create( "DButton", mainpanel )
    mainpanel_closee:SetSize( 40, 40 )
    mainpanel_closee:SetPos( mainpanel:GetWide() - 40,0 )
    mainpanel_closee:SetText( "" )
    mainpanel_closee:SetTextColor( Color( 255, 255, 255 ) )
    mainpanel_closee.Paint = function(self,w,h)
      draw.RoundedBox(8,0,0,w,h,Color(220, 20, 60,230))
      surface.SetDrawColor( 255, 255, 255 )
      surface.DrawLine( 7,7,32,32)
      surface.DrawLine( 7,32,32,7)
    end
    mainpanel_closee.DoClick = function()
      mainpanel:Remove()   
	end

	
	local buttonpanel = vgui.Create('DPanel',mainpanel)
	buttonpanel:SetPos(10,50)
	buttonpanel:SetSize(mainpanel:GetWide()-20,35)
	buttonpanel.Paint = function( self, w, h )
	end

	local pages = vgui.Create('DPanel',mainpanel)
	pages:SetPos(10,90)
	pages:SetSize(mainpanel:GetWide()-20,mainpanel:GetTall()-100)
	pages.Paint = function( self, w, h )
	end

	local function addButton(parent, text, action)
		surface.SetFont('XeninUI.GradientButton.Default')
		local btn = vgui.Create('XeninUI.ButtonV2', parent)
		btn:SetSize(select(1, surface.GetTextSize(text))+25, parent:GetTall()-10)
		btn:SetRoundness( 2 )
		btn:SetText(text)
		btn:SetYOffset( -2 )
		btn:SetGradient( true )
		btn:DockMargin(10,0,0,0)
		btn:Dock(LEFT)
		btn.DoClick = action
		return btn
	end
	
	local pricepanel = vgui.Create('DPanel',pages)
	pricepanel:SetPos(0,0)
	pricepanel:SetSize(pages:GetWide(),pages:GetTall())
	pricepanel.Paint = function( self, w, h )
		draw.SimpleText('Валютные операции','hud_subs_big',10,0,color_white)
	end

	local tradepanel = vgui.Create('DPanel',pricepanel)
	tradepanel:SetPos(10,40)
	tradepanel:SetSize(pricepanel:GetWide()-20,120)
	tradepanel.Paint = function( self, w, h )
		draw.RoundedBox(8,0,0,w,h,Color(0,0,0,150))
		draw.SimpleText('Обменный курс:','hud_subs',10,20,color_white)
		draw.SimpleText('=','hud_subs_big',w/2,30,color_white,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText('1¥','hud_subs_big',w/2+20,30,color_white,TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(price_hour..' BP','hud_subs_big',w/2-20,30,color_white,TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText('Обмен валюты:','hud_subs',10,70,color_white)
		draw.SimpleText('BP','hud_subs_big',330,62,color_white,TEXT_ALIGN_LEFT)
		draw.SimpleText('=','hud_subs_big',385,62,color_white,TEXT_ALIGN_CENTER)
	end

	local trademoney = vgui.Create('DLabel',pricepanel)
	trademoney:SetPos(420,102)
	trademoney:SetFont('hud_subs_big')
	trademoney:SetText('0¥')
	trademoney:SizeToContents()
	trademoney:SetColor(color_white)

	local changebt = vgui.Create('XeninUI.ButtonV2', pricepanel)
	changebt:SetSize(115,35)
	changebt:SetRoundness( 2 )
	changebt:SetText('Обменять')
	changebt:SetYOffset( -2 )
	changebt:SetGradient( true )
	changebt:DockMargin(10,0,0,0)
	changebt:SetPos(420+trademoney:GetWide()+10,105)

	local textentry = vgui.Create('DTextEntry',pricepanel)
	textentry:SetPos(180,102)
	textentry:SetFont("XeninUI.TextEntry")
	textentry:SetSize(150,40)
	textentry:SetNumeric(true)
	textentry:SetDrawLanguageID(false)
	textentry.OnLoseFocus = function( money )
		if string.find( textentry:GetText(), " " ) then return LocalPlayer():ChatPrint('Убери пробел') end
		if textentry:GetText() == '' then return end
		if tonumber(textentry:GetText()) < 0 then textentry:SetText("") end
		trademoney:SetText(math.Round(tonumber(textentry:GetText()/price_hour))..'¥') 
		trademoney:SizeToContents()
		changebt:SetPos(420+trademoney:GetWide()+10,105)
	end
	textentry.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(30,30,30))
		self:DrawTextEntryText(Color(255, 255, 255), Color(120, 0, 120), Color(255, 255, 255)) 
	end

	changebt.DoClick = function()
		net.Start("change_bpoints_")
		net.WriteString(textentry:GetText())
		net.SendToServer()
	end

	local graphicpanel = vgui.Create('DPanel',pricepanel)
	graphicpanel:SetSize(pricepanel:GetWide()-20,320)
	graphicpanel:SetPos(10,180)
	graphicpanel.Paint = function( self, w, h )
		draw.RoundedBox(8,0,0,w,h,Color(0,0,0,150))
	end

	surface.SetDrawColor(color_white)

	local graphicpanelin = vgui.Create('DPanel',graphicpanel)
	graphicpanelin:SetSize(graphicpanel:GetWide()-20,graphicpanel:GetTall()-20)
	graphicpanelin:SetPos(10,10)
	graphicpanelin.Paint = function( self, w, h )
		draw.SimpleText(maxprice, 'trade_inf', 0,0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(minprice, 'trade_inf', 0,h, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		surface.SetFont('trade_inf')
		local ww = surface.GetTextSize(maxprice)+10
		draw.RoundedBox(0,ww-1,0,1,h,color_white)
		draw.RoundedBox(0,ww-1,h-1,w-ww-1,1,color_white)
		if hournow == 1 then
			draw.SimpleText('Пока нечего строить', 'hud_subs_n', w/2,h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		else
			for i = 0, hournow-2 do
				local price_inhour = GetGlobalInt('printer_pricehour'..(i+1))
				local price_inhourn = GetGlobalInt('printer_pricehour'..(i+2))
				local wt = price_inhour/maxprice*h
				local wn = price_inhourn/maxprice*h
				if wt > wn then
					surface.SetDrawColor(255,0,0)
				else
					surface.SetDrawColor(0,255,0)
				end
				surface.DrawLine( ww+27*i, h-wt, ww+27*(i+1), h-wn )
				draw.SimpleText( price_inhour,'trade_inf',ww+27*i, h-wt, color_white )
				draw.SimpleText( price_inhourn,'trade_inf',ww+27*(i+1), h-wn, color_white )
				--local wt = price_hour/maxprice*h
				--draw.RoundedBox(0,ww,h-wt,1,wt,Color(255,0,0))
			end
		end
	end

	local buypanel = vgui.Create('DPanel',pages)
	buypanel:SetPos(0,0)
	buypanel:SetSize(pages:GetWide(),pages:GetTall())
	buypanel:SetVisible(false)
	buypanel.Paint = function( self, w, h )
		draw.SimpleText('Магазин','hud_subs_big',10,0,color_white)
	end

	local buypanelbg = vgui.Create('DPanel',buypanel)
	buypanelbg:SetPos(0,45)
	buypanelbg:SetSize(buypanel:GetWide(),buypanel:GetTall()-30)
	buypanelbg.Paint = function( self, w, h )
	end

    local items_scroll = vgui.Create( "DScrollPanel", buypanelbg )
	items_scroll:Dock( FILL )

	local info_weapon_block = vgui.Create( "DButton",buypanel )                 	
    info_weapon_block:SetSize(buypanel:GetWide(),buypanel:GetTall())   
    info_weapon_block:SetPos(0,0)
    info_weapon_block:SetAlpha(0)
    info_weapon_block:SetText("")
    info_weapon_block:SetVisible(false)
    info_weapon_block.Paint = function( self, w, h )
     -- draw.RoundedBox(0, 0,0,w,h,Color(0,0,0))
      DrawBDBlur(self,1)
	end
	
    local info_weapon = vgui.Create( "DPanel",buypanel )              
	info_weapon:SetSize(0,buypanel:GetTall())   
    info_weapon:SetPos(buypanel:GetWide()-240,0)
    info_weapon.Paint = function( self, w, h )
        draw.RoundedBox(8, 0,0,w,h,Color(0,0,0,230))
    end

    local weapon_model = vgui.Create( "DPanel",info_weapon )              
    weapon_model:SetSize(300,200)   
    weapon_model:SetPos(0,0)
    weapon_model.Paint = function( self, w, h )
        draw.RoundedBox(8, 0,0,w,h,Color(40,40,40))
        draw.RoundedBox(8,0,0,w,h,Color(137,33,107))
        --draw.DrawBFGrad(0,0,w,40, Color(218,63,83))
        surface.DrawTexturedRect_Borders("right",8,0,0,w,h,Color(218,63,83))
	end
	
    info_weapon_block.DoClick = function()
      info_weapon:SizeTo( 0,buypanel:GetTall(), 0.1, 0,-1)
      info_weapon:MoveTo( buypanel:GetWide()-240,0,  0.1, 0,-1 )
      info_weapon_block:AlphaTo( 0, 0.1,  0, function() info_weapon_block:SetVisible(false) end )
      previewPnl:Remove()
	  nameweapon:Remove()
	  buyitem:Remove()
      weapon_Stats:Remove()
    end 
	
	for i = 1, #printerss.Printers do
		local cur = printerss.Printers[i]
		local asdasd = items_scroll:Add( "DButton" )
		asdasd:SetText( "" )
		asdasd:Dock( TOP )
		asdasd:SetColor(color_black) 
		asdasd:SetFont("hud_subs_name")
		asdasd:SetTall(50)
		asdasd:DockMargin( 0, 0, 0, 7 )
		function asdasd:Paint(w,h)
			draw.RoundedBox(8,0,0,w,h,Color(220,220,220))
			if cur.name == "Радужный принтер" then
				draw.SimpleText(cur.name,"hud_subs_name",15,h/2,HSVToColor(  ( CurTime() * 10 ) % 360, 1, 1 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(cur.name,"hud_subs_name",15,h/2,color_black,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
			draw.SimpleText("Подробнее","hud_subs_name",w-10,h/2,color_black,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		end
		asdasd.DoClick = function()	
            info_weapon:SizeTo( 300,buypanel:GetTall(), 0.1, 0,-1)
            info_weapon:MoveTo( buypanel:GetWide()-300, 0,  0.1, 0,-1 )
            info_weapon_block:SetVisible(true)
			info_weapon_block:AlphaTo( 200, 0.1,  0 )
            previewPnl = CreateWeaponModelPnl(0,0,weapon_model:GetWide(),'',true,weapon_model,true,true)
            previewPnl:UpdateModel(cur.model or "models/props_c17/chair_kleiner03a.mdl") 
			previewPnl:SetPos(0,-50)
            CenterInElement(previewPnl, weapon_model)
            surface.SetFont("hud_subs_n")
            nameweapon = vgui.Create( "DLabel", info_weapon )
            nameweapon:SetFont("hud_subs_n")
            nameweapon:SetColor(color_white)
			nameweapon:SetText( cur.name )
			nameweapon:SizeToContents()
			nameweapon:SetPos( weapon_model:GetWide()/2-nameweapon:GetWide()/2, 210 )
            weapon_Stats = vgui.Create( "DPanel",info_weapon )              
            weapon_Stats:SetSize(400,250)   
            weapon_Stats:SetPos(0,260)
            weapon_Stats.Paint = function( self, w, h )
                draw.SimpleText("Мощность: "..cur.MoneyAmount.."BP","hud_subs_name",20,10,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText("Нагрев: "..cur.TempAdd.."°C","hud_subs_name",20,70,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText("Здоровье: "..cur.PrinterHealth,"hud_subs_name",20,40,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText("VIP: "..(cur.IsVIP and "Да" or "Нет"),"hud_subs_name",20,100,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText("Цена за перезарядку: "..DarkRP.formatMoney(cur.Rechargeprice),"hud_subs_name",20,130,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText("Цена: "..DarkRP.formatMoney(tonumber(cur.price)),"hud_subs_name",20,160,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
            buyitem = vgui.Create( "XeninUI.ButtonV2", info_weapon )
            buyitem:SetRoundness( 2 )
            buyitem:SetText("Приобрести")
            buyitem:SetGradient( true )
            buyitem:SetSize(180,40)
            buyitem:SetPos(300/2-90,info_weapon:GetTall()-60)
            buyitem:SetFont("hud_subs_b")
            buyitem:SetYOffset( -2 )
            buyitem.DoClick = function()
              net.Start("buyprinter_bm")	
              	net.WriteString(cur.ent)
              	net.WriteString(cur.price)
              net.SendToServer()
              items_scroll:Clear()

              mainpanel:Remove()
            end
		end
    end

	local upgradepanel = vgui.Create('DPanel',pages)
	upgradepanel:SetPos(0,0)
	upgradepanel:SetSize(pages:GetWide(),pages:GetTall())
	upgradepanel:SetVisible(false)
	upgradepanel.Paint = function( self, w, h )
		draw.SimpleText('Инвентарь','hud_subs_big',10,0,color_white)
		draw.SimpleText('Принтеры отсортированы по времени покупки','hud_subs_name',w-10,8,color_white,TEXT_ALIGN_RIGHT)
	end

	local upgradepanellbg = vgui.Create('DPanel',upgradepanel)
	upgradepanellbg:SetPos(0,45)
	upgradepanellbg:SetSize(upgradepanel:GetWide(),upgradepanel:GetTall()-30)
	upgradepanellbg.Paint = function( self, w, h )
	end

    local upitems_scroll = vgui.Create( "DScrollPanel", upgradepanellbg )
	upitems_scroll:Dock( FILL )

    local upinfo_weapon_block = vgui.Create( "DButton",upgradepanel )                 	
    upinfo_weapon_block:SetSize(upgradepanel:GetWide(),upgradepanel:GetTall())   
    upinfo_weapon_block:SetPos(0,0)
    upinfo_weapon_block:SetAlpha(0)
    upinfo_weapon_block:SetText("")
    upinfo_weapon_block:SetVisible(false)
    upinfo_weapon_block.Paint = function( self, w, h )
      --draw.RoundedBox(0, 0,0,w,h,Color(0,0,0))
      DrawBDBlur(self,1)
    end

    local upinfo_weapon = vgui.Create( "DPanel",upgradepanel )              
	upinfo_weapon:SetSize(0,upgradepanel:GetTall())   
    upinfo_weapon:SetPos(upgradepanel:GetWide()-240,0)
    upinfo_weapon.Paint = function( self, w, h )
        draw.RoundedBox(8, 0,0,w,h,Color(0,0,0,230))
    end

    local upweapon_model = vgui.Create( "DPanel",upinfo_weapon )              
    upweapon_model:SetSize(300,200)   
    upweapon_model:SetPos(0,0)
    upweapon_model.Paint = function( self, w, h )
        draw.RoundedBox(8, 0,0,w,h,Color(40,40,40))
        draw.RoundedBox(8,0,0,w,h,Color(137,33,107))
        --draw.DrawBFGrad(0,0,w,40, Color(218,63,83))
        surface.DrawTexturedRect_Borders("right",8,0,0,w,h,Color(218,63,83))
    end

    upinfo_weapon_block.DoClick = function()
      upinfo_weapon:SizeTo( 0,upgradepanel:GetTall(), 0.1, 0,-1)
      upinfo_weapon:MoveTo( upgradepanel:GetWide()-240,0,  0.1, 0,-1 )
      upinfo_weapon_block:AlphaTo( 0, 0.1,  0, function() upinfo_weapon_block:SetVisible(false) end )
      uppreviewPnl:Remove()
	  upnameweapon:Remove()
	  upbuyitem:Remove()
	  uponoff:Remove()
	  uprechar:Remove()
      weapon_Stats:Remove()
	end 
	
	if LocalPlayer().printers then
	
	for kk = 1, #LocalPlayer().printers do
		--print(tonumber(LocalPlayer().printers[kk]))
		local cur = ents.GetByIndex(LocalPlayer().printers[kk])
		local upasdasd = upitems_scroll:Add( "DButton" )
		upasdasd:SetText( "" )
		upasdasd:Dock( TOP )
		upasdasd:SetColor(color_black) 
		upasdasd:SetFont("hud_subs_name")
		upasdasd:SetTall(50)
		upasdasd:DockMargin( 0, 0, 0, 7 )
		function upasdasd:Paint(w,h)
			if !IsValid(cur) then
			draw.RoundedBox(8,0,0,w,h,Color(220,220,220))
				draw.SimpleText("Принтер взорван","hud_subs_name",w/2,h/2,color_black,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				return
			end
			draw.RoundedBox(8,0,0,w,h,Color(220,220,220))

			if cur.PrintName == "Радужный принтер" then
				draw.SimpleText(cur.PrintName,"hud_subs_name",15,h/2,HSVToColor(  ( CurTime() * 10 ) % 360, 1, 1 ),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(cur.PrintName,"hud_subs_name",15,h/2,color_black,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			end
			draw.SimpleText(cur:GetMoney().."BP","hud_subs_name",w/2,h/2,color_black,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(cur:Gettoggle() and (math.floor(cur:GetPTemp()).."°C") or "Выключен","hud_subs_name",w-10,h/2,color_black,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		end
		upasdasd.DoClick = function()
			if (LocalPlayer():GetPos():DistToSqr(cur:GetPos()) > 30000) and !table.HasValue(printerss.UltJobs,team.GetName( LocalPlayer():Team() ) ) then return LocalPlayer():ChatPrint("Вы слишком далеко от принтера") end	
            upinfo_weapon:SizeTo( 300,upgradepanel:GetTall(), 0.1, 0,-1)
            upinfo_weapon:MoveTo( upgradepanel:GetWide()-300, 0,  0.1, 0,-1 )
            upinfo_weapon_block:SetVisible(true)
			upinfo_weapon_block:AlphaTo( 200, 0.1,  0 )
            uppreviewPnl = CreateWeaponModelPnl(0,0,upweapon_model:GetWide(),'',true,upweapon_model,true,true)
            uppreviewPnl:UpdateModel(cur.PrinterModel or "models/props_c17/chair_kleiner03a.mdl") 
			uppreviewPnl:SetPos(0,-50)
            CenterInElement(uppreviewPnl, upweapon_model)
            surface.SetFont("hud_subs_n")
            upnameweapon = vgui.Create( "DLabel", upinfo_weapon )
            upnameweapon:SetFont("hud_subs_n")
            upnameweapon:SetColor(color_white)
			upnameweapon:SetText( cur.PrintName )
			upnameweapon:SizeToContents()
			upnameweapon:SetPos( upweapon_model:GetWide()/2-upnameweapon:GetWide()/2, 210 )
            weapon_Stats = vgui.Create( "DPanel",upinfo_weapon )              
            weapon_Stats:SetSize(400,250)   
            weapon_Stats:SetPos(0,250)
            weapon_Stats.Paint = function( self, w, h )
            	if !IsValid(cur) then
            		draw.SimpleText("Принтер взорван","hud_subs_name",20,10,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            		return
            	end
                draw.SimpleText("Напечатано: "..(cur:GetMoney() or "Взорван").."BP","hud_subs",20,10,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText("Нагрев: "..(math.floor(cur:GetPTemp()) or "Взорван").."°C","hud_subs",20,70,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText("Здоровье: "..(cur:GetNWInt('Health') or "Взорван"),"hud_subs",20,40,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
                draw.SimpleText("Цена за перезарядку: "..(DarkRP.formatMoney(cur.Rechargeprice) or "Взорван"),"hud_subs",20,100,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				--draw.RoundedBox(8,20,130,40,115,Color(120,120,120))                 
				--draw.RoundedBox(8,20,285,cur:GetCharge(),40,Color(20,240,20))
            end
            upchagepanel = vgui.Create( "DPanel", upinfo_weapon )
            upchagepanel:SetSize(180,20)
            upchagepanel:SetPos(60,170)
            upchagepanel.Paint = function( self,w,h )
            	draw.RoundedBox(8,0,0,w,h,Color(30,30,30))
            	draw.RoundedBox(8,0,0,cur:GetCharge(),h,Color(40,230,40))
        	end

            upbuyitem = vgui.Create( "XeninUI.ButtonV2", upinfo_weapon )
            upbuyitem:SetRoundness( 2 )
            upbuyitem:SetText("Снять поинты")
            upbuyitem:SetGradient( true )
            upbuyitem:SetSize(160,35)
            upbuyitem:SetPos(300/2-80,upinfo_weapon:GetTall()-50)
            --upbuyitem:SetFont("hud_subs_b")
            upbuyitem:SetYOffset( -2 )
            upbuyitem.DoClick = function()
              net.Start("withdrawp")	
				net.WriteString(LocalPlayer().printers[kk])
              net.SendToServer()
            end
            uponoff = vgui.Create( "XeninUI.ButtonV2", upinfo_weapon )
            uponoff:SetRoundness( 2 )
            uponoff:SetText(cur:Gettoggle() and "Выключить" or "Включить")
            uponoff:SetGradient( true )
            uponoff:SetSize(160,35)
            uponoff:SetPos(300/2-80,upinfo_weapon:GetTall()-90)
            --onoffem:SetFont("hud_subs_b")
            uponoff:SetYOffset( -2 )
            uponoff.DoClick = function()
              net.Start("Togglep")	
              	net.WriteString(LocalPlayer().printers[kk])
              net.SendToServer()
              --mainpanel:Remove()
              uponoff:SetText(cur:Gettoggle() and "Включить" or "Выключить")
              if !cur:Gettoggle() then
              	cur.sound:Play()
              else
              	cur.sound:Stop()
              end
            end
            uprechar = vgui.Create( "XeninUI.ButtonV2", upinfo_weapon )
            uprechar:SetRoundness( 2 )
            uprechar:SetText("Перезарядить")
            uprechar:SetGradient( true )
            uprechar:SetSize(160,35)
            uprechar:SetPos(300/2-80,upinfo_weapon:GetTall()-130)
            --recharem:SetFont("hud_subs_b")
            uprechar:SetYOffset( -2 )
            uprechar.DoClick = function()
              net.Start("RechargeP")	
              	net.WriteString(LocalPlayer().printers[kk])
              net.SendToServer()
              --mainpanel:Remove()
            end
		end
	end
	
	end

	addButton(buttonpanel, 'Обменник', function()
		for i, v in ipairs(pages:GetChildren()) do
    		if !(v==pricepanel) then
    			v:SetVisible(false)
    		else
    			v:SetVisible(true)
    		end
		end
		surface.PlaySound('ambient/water/rain_drip2.wav')
	end)

	addButton(buttonpanel, 'Покупка', function()
		for i, v in ipairs(pages:GetChildren()) do
    		if !(v==buypanel) then
    			v:SetVisible(false)
    		else
    			v:SetVisible(true)
    		end
		end
		surface.PlaySound('ambient/water/rain_drip2.wav')
	end)

	addButton(buttonpanel, 'Инвентарь', function()
		for i, v in ipairs(pages:GetChildren()) do
    		if !(v==upgradepanel) then
    			v:SetVisible(false)
    		else
    			v:SetVisible(true)
    		end
		end
		surface.PlaySound('ambient/water/rain_drip2.wav')
	end)
end

concommand.Add('printer_panel',createmenu)

--LocalPlayer().printers = {} 

--LocalPlayer().printers[1] = "asd"

--print(LocalPlayer().printers[1])