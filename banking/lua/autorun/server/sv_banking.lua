util.AddNetworkString("banking_commands");
util.AddNetworkString("OpenBankMenu");

local Player = FindMetaTable("Player");

local function bankMsg(ply, text)
	ply:Chat(Color(0, 0, 0, 255), "[", Color(255, 25, 25, 255), "Bank", Color(0, 0, 0, 255), "] ", Color(255, 255, 255, 255), text)
end

function Player:LoadBank()
	local path = "bank/"..self:UniqueID()..".txt";
	local acc = file.Read(path, "DATA") or 0;
	
	if (!acc) then return; end
	
	self:SetNWInt("bankAcc", acc);
	self.AccountMoney = acc;
	bankMsg(self, "Bank account loaded!");
	timer.Create(self:UniqueID().."_interestTimer", 900, 0, function()
		local cash = self.AccountMoney;
		local int  = cash * .04;

		local new_cash = cash + int;
		self.AccountMoney = new_cash;
		self:SetNWInt("bankAcc", new_cash);
		bankMsg(self, "Thanks for using GBank. You have gained "..int.." from interest!");
	end)
end

function Player:SaveBank()
	local acc = self.AccountMoney or 0;
	if (!acc) then return; end
	
	if (!file.Exists("bank", "DATA")) then
		file.CreateDir("bank");
	end
	file.Write("bank/"..self:UniqueID()..".txt", acc);
end

function Player:Deposit(amt)
	if (!amt) then return; end
	
	if (self:canAfford(amt)) then
		self:addMoney(amt * -1);
		self.AccountMoney = self.AccountMoney + amt;
		self:SetNWInt("bankAcc", self.AccountMoney);
		self:SaveBank();
		return;
	end
	bankMsg(self, "You don't have enough money to do this!");
end

function Player:Withdraw(amt)
	if (!amt) then return; end
	
	if (self.AccountMoney - amt > 0) then
		self:addMoney(amt);
		self.AccountMoney = self.AccountMoney - amt;
		self:SetNWInt("bankAcc", self.AccountMoney);
		self:SaveBank();
		return;
	end
	bankMsg(self, "You don't have enough money to do this!");
end

function Player:TransferFunds(target, amt)
	if (!IsValid(target) or !amt or !target:IsPlayer()) then return; end
	
	if (self.AccountMoney - amt > 0) then
		self.AccountMoney = self.AccountMoney - amt;
		self:SetNWInt("bankAcc", self.AccountMoney);
		
		target.AccountMoney = target.AccountMoney + amt;
		target:SetNWInt("bankAcc", target.AccountMoney);
		return;
	end
	bankMsg(self, "You don't have enough money to do this!");
end

net.Receive("banking_commands", function(len, client)
	local cmd = net.ReadString();
	if (cmd == "deposit") then
		local amt = net.ReadString();
		
		if (tonumber(amt) == nil) then
			bankMsg(client, "Please only use numbers when specifying amounts!");
			return;
		end
		
		if (string.find(amt, "-")) then 
			bankMsg(client, "No negatives please!");
			return;
		end
		
		client:Deposit(tonumber(amt));
		client.bankOpen = false;
		
	elseif (cmd == "withdraw") then
		local amt = net.ReadString();
		
		if (tonumber(amt) == nil) then
			bankMsg(client, "Please only use numbers when specifying amounts!");
			return;
		end
		
		if (string.find(amt, "-")) then 
			bankMsg(client, "No negatives please!");
			return;
		end
		
		client:Withdraw(tonumber(amt));
		client.bankOpen = false;
		
	elseif (cmd == "transfer") then
		local amt = net.ReadString();
		local target = net.ReadString();
		
		if (tonumber(amt) == nil) then
			bankMsg(client, "Please only use numbers when specifying amounts!");
			return;
		end
		
		if (string.find(amt, "-")) then 
			bankMsg(client, "No negatives please!");
			return;
		end
		
		for k,v in pairs(player.GetAll()) do
			if (v:Nick() == target) then
				client:TransferFunds(v, tonumber(amt));
				client.bankOpen = false;
				return;
			end
		end
		bankMsg(client, "No player found! Try again, please!");
	end
	client.bankOpen = false;
end)

hook.Add("PlayerInitialSpawn", "LoadBankAcc", function(ply)
	ply:LoadBank();
end)

hook.Add("PlayerDisconnect", "SaveBankAcc", function(ply)
	ply:SaveBank();
	if (timer.Exists(ply:UniqueID().."_interestTimer")) then timer.Destroy(ply:UniqueID().."_interestTimer") end
end)