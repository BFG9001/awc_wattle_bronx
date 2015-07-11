AddCSLuaFile( "shared.lua" )

SWEP.Wattle 					= true
---------
SWEP.PrintName 					= "Wattle Base Bronx Edition"
SWEP.Category 					= "Wattle Bronx"
SWEP.Base 						= "weapon_wattlebase"
SWEP.Spawnable 					= false
SWEP.AdminOnly 					= false
SWEP.m_WeaponDeploySpeed 		= 1

SWEP.Author 					= "BFG"
SWEP.Contact 					= ""
SWEP.Purpose 					= ""
SWEP.Instructions 				= ""

SWEP.ViewModel 					= "models/weapons/v_pistol.mdl" 
SWEP.WorldModel 				= "models/weapons/w_pistol.mdl" 
SWEP.ViewModelFlip 				= false
SWEP.ViewModelFOV 				= 57

SWEP.Weight 					= 5
SWEP.AutoSwitchFrom 			= false
SWEP.AutoSwitchTo 				= false

SWEP.BobScale 					= 0
SWEP.SwayScale 					= 0
SWEP.BounceWeaponIcon 			= true
SWEP.DrawWeaponInfoBox 			= true
SWEP.DrawAmmo 					= true
SWEP.DrawCrosshair 				= false
SWEP.Slot 						= 0
SWEP.SlotPos 					= 10
//SWEP.WepSelection 				= 
SWEP.CSMuzzleFlashes 			= true
SWEP.CSMuzzleX 					= false

SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip 		= -1
SWEP.Primary.Ammo 				= "none"
SWEP.Primary.Automatic 			= false

SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= -1
SWEP.Secondary.Ammo 			= "none"
SWEP.Secondary.Automatic 		= false

SWEP.UseHands 					= true
SWEP.AccurateCrosshair 			= true
---------
SWEP.HoldType 					= "ar2"

SWEP.Primary.Damage				= 42
SWEP.Primary.DamageFalloff		= 0.02
SWEP.Primary.Sound				= ""
SWEP.Primary.NumShots			= 1
SWEP.Primary.Delay				= 1
SWEP.Primary.Cone				= 0.01
SWEP.Primary.ClumpCone			= 0
SWEP.Primary.Tracer				= 0
SWEP.Primary.TracerName			= "Tracer"
SWEP.Primary.MuzzleEffects		= { "effect_bronx_muzzleflash", "effect_wat_muzzle_smoke", "effect_wat_muzzle_sparks" }

--Melee stuff
SWEP.Secondary.Damage = 20
SWEP.Secondary.Delay = .75
SWEP.Secondary.Sound = Sound("weapons/knife/knife_swing_miss1.wav")

SWEP.RecoilPitchAdd 			= 1.2
SWEP.RecoilPitchMul 			= 0.2
SWEP.RecoilYawAdd 				= 0.5
SWEP.RecoilYawMul 				= 0.05

SWEP.SpreadConeAdd 				= 0.0025
SWEP.SpreadRecoveryTime 		= 0.3
SWEP.SpreadConeAddCrouch 		= 0.0015
SWEP.SpreadRecoveryTimeCrouch 	= 0.2

SWEP.SpreadModVel 				= 0.0002
SWEP.SpreadModVelMax 			= 0.0002
SWEP.SpreadModInAir				= 0.03
SWEP.SpreadModCrouch 			= 0.0002

SWEP.ReloadClipInTime			= 0

SWEP.VMPosOffset 				= Vector(0,0,0)
SWEP.VMAngOffset				= Angle(0,0,0)
SWEP.SprintPos	 				= { Vector(5,0,0), Vector(4,1.5,1), Vector(1,3,-2) }
SWEP.SprintAng					= { Angle(-8,15,10), Angle(-3,20,-20), Angle(-8,25,5) }
SWEP.WalkPos 					= { Vector(-1,0,0), Vector(0,0,1), Vector(1,0,0) }
SWEP.WalkAng					= { Angle(-1,-1,-2), Angle(1,0,0), Angle(-1,1,1) }
SWEP.InspectPos 				= { Vector(-5.503, 0.18, -2.201), Vector(5.627, 0.495, 2.073) }
SWEP.InspectAng 				= { Angle(14.199, -39.6, -10), Angle(0.001, 0.001, 39.21) }
SWEP.IronSightsPos 				= Vector(-6.24, -1.5, -0.08)
SWEP.IronSightsAng 				= Angle(0, 0, 0)
SWEP.SwayPosDiv					= 45
SWEP.SwayAngDiv					= 10

SWEP.UseIrons					= false
SWEP.UseScope					= false
SWEP.Zoom 						= 50
SWEP.SetFATOnShoot 				= false
SWEP.CVFireAnimIroned			= false

SWEP.DTFloats = {}
SWEP.DTBools = {}
SWEP.DTInts = {}

SWEP.ViewModelBoneMods = {}
SWEP.VElements = {}
SWEP.WElements = {}


function SWEP:SecondaryAttack() --Melee attack
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay * (2/3))
	self:EmitSound(self.Secondary.Sound)
	--print("rip")
	self:MeleeAttack()
end

function SWEP:MeleeAttack()
	self:GetOwner():ViewPunch( Angle( 3, 3, 15) )
	self:SetHoldType("melee2")
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	timer.Simple( 0, function() if not IsValid(self) then return end self:SetHoldType(self.HoldType) end)

	if SERVER then
		local radius = 32
		local origin = self:GetOwner():GetShootPos() + (self:GetOwner():EyeAngles():Forward() * (radius - 2))
		local targets = ents.FindInSphere( origin, radius )
		table.RemoveByValue( targets, self:GetOwner() )

		local tr = self:GetOwner():GetEyeTrace()
			if tr.HitPos:Distance(self:GetOwner():GetShootPos()) < 64 then
				if tr.Entity == game.GetWorld() then self:GetOwner():EmitSound("physics/body/body_medium_impact_hard" .. math.random(1,6) .. ".wav") end
			end

		local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self:GetOwner())
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(self.Secondary.Damage)
			dmginfo:SetDamageType(DMG_CLUB)
			dmginfo:SetDamageForce( self:GetOwner():GetAimVector() * 125 )

		for k, v in pairs( targets ) do
			if v:IsWeapon() then continue end
			if IsValid(v) and v.IsBronxCitizen then
				v:BronxMeleeStun()
			end
			if IsValid(v) then v:EmitSound("physics/body/body_medium_impact_hard" .. math.random(1,6) .. ".wav") end
			v:TakeDamageInfo(dmginfo)
		end
	end
end
