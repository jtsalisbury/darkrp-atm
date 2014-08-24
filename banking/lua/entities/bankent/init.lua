AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
	self:SetModel( "models/props/cs_assault/TicketMachine.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )     
	self:SetMoveType( MOVETYPE_NONE )  
	self:SetSolid( SOLID_VPHYSICS )         
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(act, call)
	if (IsValid(act) && !act.bankOpen) then
		act.bankOpen = true;
		net.Start("OpenBankMenu");
		net.Send(act);
	end
end

function ENT:Think()

end