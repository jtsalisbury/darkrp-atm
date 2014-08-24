if (CLIENT) then
	concommand.Add("save_banks", function()
		if (!LocalPlayer():IsSuperAdmin()) then return; end
		
		net.Start("bank_save");
		net.SendToServer();
	end)
	
else
	util.AddNetworkString("bank_save");

	local function ReloadBanks()
		local spawns = file.Read("crazy_spawns/"..game.GetMap().."_bankspawns.txt", "DATA");
		if (!spawns) then print("No spawns found for this map! How about you add some?"); return; end

		local spawns = util.JSONToTable(spawns);
		for k,v in pairs(spawns) do
			print("Spawning bank entity!");
			local n = ents.Create("bankent");
			n:SetPos(v[1]);
			n:SetAngles(v[2]);
			n:DropToFloor();
			n:Spawn();
			n:Activate();
		end
	end

	hook.Add("Initialize", "SpawnBankNPC", function()
		timer.Simple(5, function()
			ReloadBanks();
		end)
	end)

	net.Receive("bank_save", function(len, client)
		if (!client:IsSuperAdmin()) then return; end
		
		local spawns = {};

		for k,v in pairs(ents.FindByClass("bankent")) do
			table.insert(spawns, {v:GetPos(), v:GetAngles()});
		end

		local spawns = util.TableToJSON(spawns);
		file.Write("crazy_spawns/"..game.GetMap().."_bankspawns.txt", spawns);

		local fil = file.Exists("crazy_spawns/"..game.GetMap().."_bankspawns.txt", "DATA");
		if (fil) then
			client:PrintMessage(HUD_PRINTTALK, "Banks saved!");
			return;
		end
		client:PrintMessage(HUD_PRINTTALK, "Bank save failed!");
	end)
end