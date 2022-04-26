net.Receive("buypr_cl", function(len,pl)

    local ent_index = tonumber(net.ReadString())

    print(ent_index)

    if !LocalPlayer().printers then LocalPlayer().printers = {} end

    table.insert(LocalPlayer().printers, ent_index )

    PrintTable(LocalPlayer().printers)

end)

net.Receive("destroypr_cl", function(len,pl)

    local ent_index = tonumber(net.ReadString())

	table.remove(LocalPlayer().printers, ent_index)

end)