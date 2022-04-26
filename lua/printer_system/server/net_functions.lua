util.AddNetworkString( 'send_time_inprinter_' )
util.AddNetworkString( 'buyprinter_bm' )
util.AddNetworkString( 'buypr_cl' )
util.AddNetworkString( 'destroypr_cl' )
util.AddNetworkString( 'open_pr_menu' )
util.AddNetworkString( 'change_bpoints_' )

local function updateprice()
    local hournow = GetGlobalInt('printer_hournow') or 0
    if hournow == 24 then return end
    hournow = hournow +1
    local namehour = tostring('printer_pricehour'..hournow)
    math.randomseed(os.clock()^5)
    local priceforhour = math.random(printerss.MinPrice, printerss.MaxPrice)
    SetGlobalInt( 'printer_hournow', hournow )
    SetGlobalInt( namehour, priceforhour )
end

if not file.Exists("blackmarket_", "DATA") then
    file.CreateDir("blackmarket_")
end

local function printer_updateglobalprice()
    updateprice()
	timer.Create( 'printer_updateprice', 3600, 0, updateprice )
end

hook.Add( "Initialize", "printer_updateglobalprice", printer_updateglobalprice )

local function placeEnt(ent, tr, ply)
    if IsValid(ply) then
        local ang = ply:EyeAngles()
        ang.pitch = 0
        ang.yaw = ang.yaw + 180
        ang.roll = 0
        ent:SetAngles(ang)
    end

    local vFlushPoint = tr.HitPos - (tr.HitNormal * 512)
    vFlushPoint = ent:NearestPoint(vFlushPoint)
    vFlushPoint = ent:GetPos() - vFlushPoint
    vFlushPoint = tr.HitPos + vFlushPoint
    ent:SetPos(vFlushPoint)
end

local function buypr_cl(player,index)

    net.Start("buypr_cl")
    net.WriteString(index)
    net.Send(player)

end

net.Receive('change_bpoints_', function(len,ply)

    local points = math.abs(tonumber(net.ReadString()))
    local price_hour = GetGlobalInt('printer_pricehour'..GetGlobalInt('printer_hournow'))
    local amount = math.Round(points/price_hour)

    if ply:GetNWInt('blackpoints',0) < points then 
        ply:ChatPrint("У вас недостаточно поинтов") 
        return 
    end
    if points < 0 then 
        ply:ChatPrint("У вас недостаточно поинтов") 
        return 
    end

    local new_points = ply:GetNWInt('blackpoints')-points

    ply:SetNWInt('blackpoints',new_points)

    if file.Exists("blackmarket_/"..ply:SteamID64()..".txt", "DATA") then
        local points_ = tonumber(file.Read("blackmarket_/"..ply:SteamID64()..".txt"))
        file.Write("blackmarket_/"..ply:SteamID64()..".txt",new_points)
    else
        file.Write("blackmarket_/"..ply:SteamID64()..".txt",new_points)
    end

    ply:addMoney(amount)

 
end)

net.Receive('buyprinter_bm', function(len,ply)

    local enti = net.ReadString()
    local price = net.ReadString()

    if !ply:canAfford(price) then DarkRP.notify(ply,1,4,'Вы не можете себе это позволить') return end

    if (ply:GetNWInt('prints_amount',0) == printerss.LimitForU) and !table.HasValue(printerss.UltJobs,team.GetName( ply:Team() )) then DarkRP.notify(ply,1,4,'У вас лимит принтеров') return end
    if (ply:GetNWInt('prints_amount',0) == printerss.LimitForJob) and table.HasValue(printerss.UltJobs,team.GetName( ply:Team() )) then DarkRP.notify(ply,1,4,'У вас лимит принтеров') return end

    local trace = {}
    trace.start = ply:EyePos()
    trace.endpos = trace.start + ply:GetAimVector() * 85
    trace.filter = ply

    local tr = util.TraceLine(trace)

    local crate = ents.Create(enti)

    crate:SetPos(Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z))
    crate:Spawn()
    crate:SetNWEntity('owner',ply)
    crate:Setowning_ent(ply)
    crate:SetNWEntity("p_owner",ply)

    if crate.IsVIP and !printerss.VipRanks[ply:GetUserGroup()] then 
        DarkRP.notify(ply,1,4,'У вас недостаточно прав') 
        crate:Remove() 
        return
    end

    local printer_am = ply:GetNWInt("pr_amo_"..enti,0)

    if printer_am == crate.Limit then DarkRP.notify(ply,1,4,'У вас лимит принтеров') crate:Remove() return end

    ply:SetNWInt("pr_amo_"..enti,printer_am+1)

    placeEnt(crate, tr, ply)

    ply:addMoney(-price)

    if !ply.printers then ply.printers = {} end

    table.insert(ply.printers, crate:EntIndex() )

    buypr_cl(ply,crate:EntIndex())

    ply:SetNWInt('prints_amount',ply:GetNWInt('prints_amount',0)+1)

    DarkRP.notify(ply,1,4,'Благодарим за покупку')

end)

hook.Add("PlayerInitialSpawn","setup_blackpoints",function(ply)

    if file.Exists("blackmarket_/"..ply:SteamID64()..".txt", "DATA") then
        local points = tonumber(file.Read("blackmarket_/"..ply:SteamID64()..".txt"))
        ply:SetNWInt('blackpoints',points)
    else
        ply:SetNWInt('blackpoints',0)
    end

end)

net.Receive("withdrawp", function(len, ply)
    local pri = ents.GetByIndex(tonumber(net.ReadString()))
    local amount = pri:GetMoney()
    ply:SetNWInt('blackpoints',ply:GetNWInt('blackpoints',0)+amount)
    DarkRP.notify(ply, 0, 5, "Вы забрали "..amount.."BP с этого принтера!")
    pri:SetMoney(0)
    if file.Exists("blackmarket_/"..ply:SteamID64()..".txt", "DATA") then
        local points = tonumber(file.Read("blackmarket_/"..ply:SteamID64()..".txt"))
        file.Write("blackmarket_/"..ply:SteamID64()..".txt",points+amount)
    else
        file.Write("blackmarket_/"..ply:SteamID64()..".txt",amount)
    end
end)

local function blackmarket_remove( ply, text, public )
    if (string.sub(text, 1, 14) == "/removebpdata") then
        if ply:IsSuperAdmin() then
            for k,v in pairs( file.Find("blackmarket_/*.txt","DATA") ) do
                file.Delete("blackmarket_/"..v)
            end
        end
        return ""
    end
end
hook.Add( "PlayerSay", "blackmarket_remove", blackmarket_remove )

hook.Add("PlayerDisconnected","eprinters_remove", function(ply) 

    if ply:GetNWInt('prints_amount') > 0 then
        for i = 1, #ply.printers do
            local cur = ents.GetByIndex(tonumber(ply.printers[i]))
            cur:Remove()
            print("Удален принтер "..ply:Name())
        end
    end

end)
