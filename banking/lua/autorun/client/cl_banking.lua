local colors = {
	head = Color(192, 57, 43, 255),
	back = Color(236, 240, 241, 255),
	text = Color(255, 255, 255, 255),
	btn = Color(52, 73, 94, 255),
	btn_hover = Color(44, 62, 80, 255),
	deposit = Color(46, 204, 113, 255),
	deposit_hover = Color(39, 174, 96, 255),
	withdraw = Color(231, 76, 60, 255),
	withdraw_hover = Color(192, 57, 43, 255),
	bar = Color(189, 195, 199, 255),
	barup = Color(127, 140, 141, 255),
	transfer = Color(230, 126, 34, 255),
	transfer_hover = Color(211, 84, 0, 255),
	transfer_disabled = Color(230, 126, 34, 150),
	deposit_disabled = Color(46, 204, 113, 150),
	withdraw_disabled = Color(231, 76, 60, 150),
}

surface.CreateFont("bankHead", {font = "coolvetica", size = 60, weight = 500})
surface.CreateFont("bankBtn", {font = "coolvetica", size = 30, weight = 500})
surface.CreateFont("bankBtnSmall", {font = "coolvetica", size = 15, weight = 500})

function CreateBankMenu()
	local tPlayer = "Choose a Player";
	local amt = 0;
	
	local f = vgui.Create("DFrame");
	f:SetPos(300, 300);
	f:SetSize(ScrW() - 700, ScrH() - 200);
	f:SetTitle(" ");
	f:SetVisible(true);
	f:MakePopup();
	f:Center();
	f:ShowCloseButton(false);
	f.Paint = function()
		draw.RoundedBox(0, 0, 0, f:GetWide(), f:GetTall(), colors.back);
		draw.RoundedBox(0, 0, 0, f:GetWide(), 100, colors.head);
		draw.SimpleText("Bank", "bankHead", f:GetWide() / 2, 25, colors.text, TEXT_ALIGN_CENTER)
	end
	
	local acc = vgui.Create("DPanel", f);
	acc:SetSize(f:GetWide() - 20, 50);
	acc:SetPos(10, 110);
	acc.Paint = function()
		draw.RoundedBox(0, 0, 0, acc:GetWide(), acc:GetTall(), colors.btn);
		draw.SimpleText("Account: $"..string.Comma(LocalPlayer():GetNWInt("bankAcc")), "bankBtn", acc:GetWide() / 2, 12, colors.text, TEXT_ALIGN_CENTER);
	end
	
	local te = vgui.Create("DTextEntry", f);
	te:SetSize(f:GetWide() - 20, 50);
	te:SetPos(10, 170);
	te:SetText("Amount");
	te:SetNumeric(true);
	
	local d = vgui.Create("DButton", f);
	d:SetText(" ");
	d:SetPos(10, 230);
	d:SetSize(f:GetWide() - 20, 50);
	d:SetDisabled(true);
	local dA = false
	function d:OnCursorEntered()
		dA = true;
	end
	function d:OnCursorExited()
		dA = false;
	end
	d.Paint = function()
		if (d:GetDisabled()) then
			draw.RoundedBox(0, 0, 0, d:GetWide(), d:GetTall(), colors.deposit_disabled);
		else
			if (dA) then
				draw.RoundedBox(0, 0, 0, d:GetWide(), d:GetTall(), colors.deposit_hover);
			else
				draw.RoundedBox(0, 0, 0, d:GetWide(), d:GetTall(), colors.deposit);
			end
		end
		draw.SimpleText("Deposit Funds", "bankBtn", d:GetWide() / 2, 10, colors.text, TEXT_ALIGN_CENTER);
	end
	d.DoClick = function()
		net.Start("banking_commands");
			net.WriteString("deposit");
			net.WriteString(amt);
		net.SendToServer();
	end
	
	local w = vgui.Create("DButton", f);
	w:SetText(" ");
	w:SetPos(10, 290);
	w:SetSize(f:GetWide() - 20, 50);
	w:SetDisabled(true);
	local wA = false;
	function w:OnCursorEntered()
		wA = true;
	end
	function w:OnCursorExited()
		wA = false;
	end
	w.Paint = function()
		if (w:GetDisabled()) then
			draw.RoundedBox(0, 0, 0, w:GetWide(), w:GetTall(), colors.withdraw_disabled);
		else
			if (wA) then
				draw.RoundedBox(0, 0, 0, w:GetWide(), w:GetTall(), colors.withdraw_hover);
			else
				draw.RoundedBox(0, 0, 0, w:GetWide(), w:GetTall(), colors.withdraw);
			end
		end
		draw.SimpleText("Withdraw Funds", "bankBtn", w:GetWide() / 2, 10, colors.text, TEXT_ALIGN_CENTER);
	end
	w.DoClick = function()
		net.Start("banking_commands");
			net.WriteString("withdraw");
			net.WriteString(amt);
		net.SendToServer();
	end
	
	function CreatePlayerChooseMenu()
		local targ = "None";
	
		local f = vgui.Create("DFrame");
		f:SetPos(300, 300);
		f:SetSize(ScrW() - 700, ScrH() - 200);
		f:SetTitle(" ");
		f:SetVisible(true);
		f:MakePopup();
		f:Center();
		f:ShowCloseButton(true);
		f.Paint = function()
			draw.RoundedBox(0, 0, 0, f:GetWide(), f:GetTall(), colors.back);
			draw.RoundedBox(0, 0, 0, f:GetWide(), 100, colors.head);
			draw.SimpleText("Choose Player", "bankHead", f:GetWide() / 2, 25, colors.text, TEXT_ALIGN_CENTER)
		end

		local ds = vgui.Create("DScrollPanel", f);
		ds:SetSize(f:GetWide() - 20, 285);
		ds:SetPos(10, 105);
		ds:GetVBar().Paint = function() draw.RoundedBox(0, 0, 0, ds:GetVBar():GetWide(), ds:GetVBar():GetTall(), Color(255, 255, 255, 0)) end
		ds:GetVBar().btnUp.Paint = function() draw.RoundedBox(0, 0, 0, ds:GetVBar().btnUp:GetWide(), ds:GetVBar().btnUp:GetTall(), colors.barup) end
		ds:GetVBar().btnDown.Paint = function() draw.RoundedBox(0, 0, 0, ds:GetVBar().btnDown:GetWide(), ds:GetVBar().btnDown:GetTall(), colors.barup) end
		ds:GetVBar().btnGrip.Paint = function(w, h) draw.RoundedBox(0, 0, 0, ds:GetVBar().btnGrip:GetWide(), ds:GetVBar().btnGrip:GetTall(), colors.bar) end
	
		local w = vgui.Create("DButton", f);
		w:SetText(" ");
		w:SetPos(10, f:GetTall() - 120);
		w:SetSize(f:GetWide() - 20, 50);
		w:SetDisabled(true);
		local wA = false;
		function w:OnCursorEntered()
			wA = true;
		end
		function w:OnCursorExited()
			wA = false;
		end
		w.Paint = function()
			if (w:GetDisabled()) then
				draw.RoundedBox(0, 0, 0, w:GetWide(), w:GetTall(), colors.deposit_disabled);
			else
				if (wA) then
					draw.RoundedBox(0, 0, 0, w:GetWide(), w:GetTall(), colors.deposit_hover);
				else
					draw.RoundedBox(0, 0, 0, w:GetWide(), w:GetTall(), colors.deposit);
				end
			end
			draw.SimpleText("Transfer", "bankBtn", w:GetWide() / 2, 10, colors.text, TEXT_ALIGN_CENTER);
		end
		w.DoClick = function()
			net.Start("banking_commands");
				net.WriteString("transfer");
				net.WriteString(amt);
				net.WriteString(targ);
			net.SendToServer();
		end
	
		count = 0;
		for k,v in pairs(player.GetAll()) do
			local b = vgui.Create("DButton", ds);
			b:SetText(" ");
			b:SetPos(0, count * 55);
			b:SetSize(f:GetWide() - 30, 50);
			b.steamid = v:SteamID();
			
			count = count + 1;
			
			local e = false;
			function b:OnCursorEntered()
				e = true;
			end
			function b:OnCursorExited()
				e = false;
			end
			b.Paint = function()
				if (b:GetDisabled()) then
					draw.RoundedBox(0, 0, 0, t:GetWide(), t:GetTall(), colors.transfer_disabled);
				else
					if (e) then
						draw.RoundedBox(0, 0, 0, b:GetWide(), b:GetTall(), colors.btn_hover);
					else
						draw.RoundedBox(0, 0, 0, b:GetWide(), b:GetTall(), colors.btn);
					end
				end
				draw.SimpleText(v:Nick(), "carsBtn", b:GetWide() / 2, 10, colors.text, TEXT_ALIGN_CENTER);
			end
			b.DoClick = function()
				targ = v:Nick();
				w:SetDisabled(false);
			end
		end
		
		local close = vgui.Create("DButton", f);
		close:SetText(" ");
		close:SetPos(10, f:GetTall() - 60);
		close:SetSize(f:GetWide() - 20, 50);
		local ca = false;
		function close:OnCursorEntered()
			ca = true;
		end
		function close:OnCursorExited()
			ca = false;
		end
		close.Paint = function()
			if (close:GetDisabled()) then
				draw.RoundedBox(0, 0, 0, close:GetWide(), close:GetTall(), colors.withdraw_disabled);
			else
				if (ca) then
					draw.RoundedBox(0, 0, 0, close:GetWide(), close:GetTall(), colors.withdraw_hover);
				else
					draw.RoundedBox(0, 0, 0, close:GetWide(), close:GetTall(), colors.withdraw);
				end
			end
			draw.SimpleText("Close", "bankBtn", close:GetWide() / 2, 10, colors.text, TEXT_ALIGN_CENTER);
		end
		close.DoClick = function()
			f:Close();
			net.Start("banking_commands");
				net.WriteString("None");
			net.SendToServer();
		end
		
		
	end
	
	local t = vgui.Create("DButton", f);
	t:SetText(" ");
	t:SetPos(10, 350);
	t:SetSize(f:GetWide() - 20, 50);
	t:SetDisabled(true);
	local tA = false;
	function t:OnCursorEntered()
		tA = true;
	end
	function t:OnCursorExited()
		tA = false;
	end
	t.Paint = function()
		if (t:GetDisabled()) then
			draw.RoundedBox(0, 0, 0, t:GetWide(), t:GetTall(), colors.transfer_disabled);
		else
			if (tA) then
				draw.RoundedBox(0, 0, 0, t:GetWide(), t:GetTall(), colors.transfer_hover);
			else
				draw.RoundedBox(0, 0, 0, t:GetWide(), t:GetTall(), colors.transfer);
			end
		end
		draw.SimpleText("Transfer Funds", "bankBtn", t:GetWide() / 2, 10, colors.text, TEXT_ALIGN_CENTER);
	end
	
	t.DoClick = function()
		f:Close();
		CreatePlayerChooseMenu();
	end
	
	local close = vgui.Create("DButton", f);
	close:SetText(" ");
	close:SetPos(10, f:GetTall() - 60);
	close:SetSize(f:GetWide() - 20, 50);
	local ca = false;
	function close:OnCursorEntered()
		ca = true;
	end
	function close:OnCursorExited()
		ca = false;
	end
	close.Paint = function()
		if (close:GetDisabled()) then
			draw.RoundedBox(0, 0, 0, close:GetWide(), close:GetTall(), colors.withdraw_disabled);
		else
			if (ca) then
				draw.RoundedBox(0, 0, 0, close:GetWide(), close:GetTall(), colors.withdraw_hover);
			else
				draw.RoundedBox(0, 0, 0, close:GetWide(), close:GetTall(), colors.withdraw);
			end
		end
		draw.SimpleText("Close", "bankBtn", close:GetWide() / 2, 10, colors.text, TEXT_ALIGN_CENTER);
	end
	close.DoClick = function()
		net.Start("banking_commands");
			net.WriteString("None");
		net.SendToServer();
		f:Close();
	end
	
	function te:OnTextChanged()
		if (string.len(te:GetValue()) > 1) then
			d:SetDisabled(false);
			w:SetDisabled(false);
			t:SetDisabled(false);
			amt = te:GetValue();
		else
			d:SetDisabled(true);
			w:SetDisabled(true);
			t:SetDisabled(true);
		end
	end

end
net.Receive("OpenBankMenu", CreateBankMenu);