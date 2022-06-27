if not ConVarExists("kn_realistic_combine") then --check if this convar does not exist, that way we only have to call it once and potentially reduce lag.
	CreateConVar("kn_realistic_combine", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)--only checks if this convar exists because we only need to know if this does exist, that way we dont need to check for the other convars.
	--the rest of these convars will follow
	CreateConVar("kn_realistic_combine_promixity_grenade", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_ai", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_npc", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_player", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_health", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_flinch", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_elite", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_better_flank_behavior", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_accuracy", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_long_visibility", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_frequent_grenades", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_no_delay_gunshots", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_make_them_talk_more", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
end
--GO TO CODE 416 or function CombineAI for full explanation
function CombineAI_CrosshairMain(ply) 
	local tr = ply:GetEyeTrace() 
	local ent = tr.Entity 
	if ( !IsValid( ent ) ) then return end 
	if ent:GetClass()=="npc_combine_s" then
		ent.IamBeingSeen=true
	end
end

function CombineAI_PropsAndExplosives(npc)
	for _, grenadefrag in ipairs(ents.FindByClass("npc_grenade_frag")) do
		if IsValid(grenadefrag) and (grenadefrag:GetPos()-npc:GetPos()):Length() <=250 then
			local get = npc:GetCurrentSchedule()<=LAST_SHARED_SCHEDULE
				if get and not npc:IsCurrentSchedule(SCHED_COWER) then
				npc:SetSchedule(SCHED_FLEE_FROM_BEST_SOUND)
				end
		end
	end

	for _, explosives in ipairs(ents.FindByClass("prop_physics")) do
		if IsValid(explosives) and (explosives:GetPos()-npc:GetPos()):Length() <=250 and explosives:GetMaxHealth()>0 and explosives:IsOnFire() and (explosives:GetModel()=="models/props_c17/oildrum001_explosive.mdl") then
		local get = npc:GetCurrentSchedule()<=LAST_SHARED_SCHEDULE
			if get and not npc:IsCurrentSchedule(SCHED_COWER) then
			npc:SetSchedule(SCHED_FLEE_FROM_BEST_SOUND)
			end
		end

		if IsValid(enemy) then
			if (enemy:GetPos()-explosives:GetPos()):Length()<=90 and explosives:GetMaxHealth()>0 and explosives:Visible(npc) and not npc:Visible(enemy) then
				if npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE and !npc:IsCurrentSchedule(SCHED_FORCED_GO_RUN) or npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE and !npc:IsCurrentSchedule(SCHED_RUN_RANDOM) or npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE and !npc:IsCurrentSchedule(SCHED_RANGE_ATTACK2) or npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE and !npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD)  or npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE and !npc:IsCurrentSchedule(SCHED_RELOAD) then
				npc:SetSchedule(SCHED_SHOOT_ENEMY_COVER)
				end
			end
		end
	end
end

function CombineAI_ShootMoreThanTwo(npc)
	if npc:GetInternalVariable("m_iMySquadSlot")==-1 then 
	npc:SetSaveValue("m_iMySquadSlot", 1) 
	end

	if IsValid(enemy) and npc:Visible(enemy) then
		if npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_ENEMY) or npc:IsCurrentSchedule(SCHED_FAIL) then
		npc:SetSchedule(SCHED_RANGE_ATTACK1)
		end
	end
end

function CombineAI_ReloadLow(npc)
	if npc:IsCurrentSchedule(SCHED_RELOAD) then
		if npc:GetMovementActivity(ACT_RELOAD) then
		npc:SetActivity(ACT_RELOAD_LOW)
		npc.SoldierReloading=true
		end
	end
end

function CombineAI_NoFlinch(npc)
	if GetConVar("kn_realistic_combine_flinch"):GetFloat()==1 then
		npc:ClearCondition(18)
		npc:ClearCondition(17)
		npc:ClearCondition(39)
		npc:ClearCondition(11)
		npc:ClearCondition(11)
	end
end

function CombineAI_GunAccuracy(npc)
	if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==1 then
	if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
		npc:SetSaveValue("m_CurrentWeaponProficiency", 10)
	else npc:SetSaveValue("m_CurrentWeaponProficiency", 4)
	end
	end

	if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==2 then
	if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
		npc:SetSaveValue("m_CurrentWeaponProficiency", 4)
	else npc:SetSaveValue("m_CurrentWeaponProficiency", 3)
	end
	end

	if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==3 then
	if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
		npc:SetSaveValue("m_CurrentWeaponProficiency", 3)
	else npc:SetSaveValue("m_CurrentWeaponProficiency", 2)
	end
	end

	if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==4 then
	if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
		npc:SetSaveValue("m_CurrentWeaponProficiency", 2)
	else npc:SetSaveValue("m_CurrentWeaponProficiency", 1)
	end
	end

	if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==5 then
	if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
		npc:SetSaveValue("m_CurrentWeaponProficiency", 1)
	else npc:SetSaveValue("m_CurrentWeaponProficiency", 0)
	end
	end
end

function CombineAI_AloneSoldier(npc)
	if enemy:IsNPC() or enemy:IsPlayer() then
	if IsValid(enemy) and npc:GetNearestSquadMember()==NULL and npc:Visible(enemy) and enemy:GetClass()=="player" and IsValid(enemy:GetActiveWeapon()) then
		if npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE and !npc:IsCurrentSchedule(SCHED_RELOAD) and !npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) and npc:IsCurrentSchedule(SCHED_RANGE_ATTACK1) and !npc:IsCurrentSchedule(SCHED_COWER) and !npc:IsCurrentSchedule(118) and !npc:IsCurrentSchedule(98) then
			npc:SetSchedule(SCHED_RUN_FROM_ENEMY)
			npc.AloneSoldier_Player1=true
		end
	elseif IsValid(enemy) and npc:GetNearestSquadMember()==NULL and !npc:Visible(enemy) and enemy:GetClass()=="player" and IsValid(enemy:GetActiveWeapon()) then
		if npc:IsCurrentSchedule(SCHED_ESTABLISH_LINE_OF_FIRE) then
			npc:SetSchedule(SCHED_RUN_RANDOM)
			npc.AloneSoldier_Player2=true
		end
	elseif IsValid(enemy) and npc:GetNearestSquadMember()==NULL and npc:Visible(enemy) and IsValid(enemy:GetActiveWeapon()) then
		if npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE and !npc:IsCurrentSchedule(SCHED_RELOAD) and !npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) and npc:IsCurrentSchedule(SCHED_RANGE_ATTACK1) and !npc:IsCurrentSchedule(SCHED_COWER) and !npc:IsCurrentSchedule(118) and !npc:IsCurrentSchedule(98) then
			npc:SetSchedule(SCHED_RUN_FROM_ENEMY)
			npc.AloneSoldier_NPC2=true
		end
	elseif IsValid(enemy) and npc:GetNearestSquadMember()==NULL and !npc:Visible(enemy) and IsValid(enemy:GetActiveWeapon()) then
			if npc:IsCurrentSchedule(SCHED_ESTABLISH_LINE_OF_FIRE) then
			npc:SetSchedule(SCHED_BACK_AWAY_FROM_SAVE_POSITION)
			npc.AloneSoldier_NPC2=true
		end
	end
	end
end

function CombineAI_MoreChatter(npc)
	if GetConVar("kn_realistic_combine_make_them_talk_more"):GetFloat()==1 then
		if npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) and IsValid(enemy) and !npc:Visible(enemy) and npc:IsSquadLeader()==true and !alien_zombies[enemy:GetClass()] then 
		npc:SetSchedule(SCHED_RELOAD)
		npc:PlaySentence("COMBINE_LOST_SHORT", 0, 1) 
		elseif npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) and IsValid(enemy) and !npc:Visible(enemy) and npc:IsSquadLeader()==false and !alien_zombies[enemy:GetClass()] then
				npc:SetSchedule(SCHED_RELOAD)
		npc:PlaySentence("COMBINE_REFIND_ENEMY", 0, 1) 
		end

	if IsValid(enemy) and !npc:Visible(enemy) and IsValid(npc:GetNearestSquadMember()) and npc:IsSquadLeader()==false and !alien_zombies[enemy:GetClass()] then
		if math.random(0,200)==32 then 
		npc.CombatChatter=true
		if npc.CombatChatter==true then
		
		timer.Simple(2, function() 
		if IsValid(npc) and npc.CombatChatter==true then 
		npc.CombatChatter=false 
		if npc:GetCurrentSchedule()>=SCHED_RANGE_ATTACK1 then 
							timer.Simple(3, function() 
		if IsValid(npc) and npc.CombatChatter==false then 
		npc.CombatChatter=true
		npc:PlaySentence("COMBINE_CLEAR", 0, 1)
		end end)end end end)

		end
		end

	elseif IsValid(enemy) and npc:Visible(enemy) and IsValid(npc:GetNearestSquadMember()) and npc:IsSquadLeader()==false and !alien_zombies[enemy:GetClass()] then
		if math.random(0,200)==32 then 
		npc.CombatChatter=true
		if npc.CombatChatter==true then
		
		timer.Simple(2, function() 
		if IsValid(npc) and npc.CombatChatter==true then 
		npc.CombatChatter=false 
		if npc:GetCurrentSchedule()>=SCHED_RANGE_ATTACK1 then 
							timer.Simple(3, function() 
		if IsValid(npc) and npc.CombatChatter==false then 
		npc.CombatChatter=true
		npc:PlaySentence("COMBINE_FLANK", 0, 1)
		end end)end end end)

		end
		end

		elseif IsValid(enemy) and IsValid(npc:GetNearestSquadMember()) and npc:IsSquadLeader()==true and !alien_zombies[enemy:GetClass()] then
		if math.random(0,200)==32 then 
		npc.CombatChatter=true
		if npc.CombatChatter==true then
		
		timer.Simple(2, function() 
		if IsValid(npc) and npc.CombatChatter==true then 
		npc.CombatChatter=false 
		if npc:GetCurrentSchedule()>=SCHED_RANGE_ATTACK1 then 
			timer.Simple(3, function() 
		if IsValid(npc) and npc.CombatChatter==false then 
		npc.CombatChatter=true
		npc:PlaySentence("COMBINE_ASSAULT", 0, 1)
		end end)end end end)

		end
		end

	elseif IsValid(enemy) and npc:GetNearestSquadMember()==NULL then
		if math.random(0,200)==32 then 
		npc.CombatChatter=true
		if npc.CombatChatter==true then
		
		timer.Simple(1, function() 
		if IsValid(npc) and npc.CombatChatter==true then 
		npc.CombatChatter=false 
		if npc:GetCurrentSchedule()>=SCHED_RANGE_ATTACK1 then 
			timer.Simple(2, function() 
		if IsValid(npc) and npc.CombatChatter==false then 
		npc.CombatChatter=true
		npc:PlaySentence("COMBINE_LAST_OF_SQUAD", 0, 1)
		end end)end end end)

		end
		end
	end
	end
end

function CombineAI_AvoidPlayerCrosshair(npc)
	for k,v in pairs(ents.FindByClass("player")) do 
		if IsValid(v) then 
			CombineAI_CrosshairMain(v)
		end
	end

	if IsValid(enemy) and enemy:GetClass()=="player" and IsValid(enemy:GetActiveWeapon()) and npc.IamBeingSeen==true and IsValid(npc:GetNearestSquadMember()) then
		timer.Simple(0, function() 
			if IsValid(npc) and npc.IamBeingSeen==true then npc.IamBeingSeen=false 
				if npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE then 
					npc:SetSchedule(SCHED_RUN_RANDOM)
					npc:GetNearestSquadMember():SetSchedule(SCHED_TAKE_COVER_FROM_ORIGIN)
				end 
			end
		end)
	end
end

function CombineAI_FlankRevisedBehavior(npc)
	if GetConVar("kn_realistic_combine_better_flank_behavior"):GetFloat()==1 then
		if npc:IsCurrentSchedule(SCHED_FORCED_GO_RUN) and IsValid(enemy) and npc:Visible(enemy) or npc:IsCurrentSchedule(SCHED_AMBUSH) and IsValid(enemy) and enemy:Visible(npc) then
		npc:SetSchedule(SCHED_RANGE_ATTACK1)
		elseif npc:IsCurrentSchedule(SCHED_AMBUSH) and IsValid(enemy) and enemy:Health()<1 then
		npc:SetSchedule(SCHED_INVESTIGATE_SOUND)
		end

		if enemy:IsNPC() or enemy:IsPlayer() then
		if IsValid(enemy) and IsValid(npc:GetNearestSquadMember()) and npc:Visible(enemy) and IsValid(enemy:GetActiveWeapon()) and npc:Health()<=npc:GetMaxHealth()/2.5 then
			if npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE and not npc:IsCurrentSchedule(SCHED_RELOAD) or npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE and not npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) then
				npc:SetSchedule(SCHED_RUN_FROM_ENEMY)
			end
		elseif IsValid(enemy) and IsValid(npc:GetNearestSquadMember()) and !npc:Visible(enemy) and IsValid(enemy:GetActiveWeapon()) and npc:Health()<=npc:GetMaxHealth()/2.5 then
			if npc:IsCurrentSchedule(SCHED_ESTABLISH_LINE_OF_FIRE) or npc:IsCurrentSchedule(118) or npc:IsCurrentSchedule(98) or npc:IsCurrentSchedule(SCHED_AMBUSH) then
				npc:SetSchedule(SCHED_BACK_AWAY_FROM_SAVE_POSITION)
			end
		end
		end

		if enemy:IsNPC() or enemy:IsPlayer() then
		if npc:GetInternalVariable("skin")==0 and IsValid(npc:GetNearestSquadMember()) and IsValid(enemy) and !npc:Visible(enemy) and enemy:Health()>=enemy:GetMaxHealth()/2.5 and IsValid(enemy:GetActiveWeapon()) and !alien_zombies[enemy:GetClass()] then
			if (npc:GetPos()-enemy:GetPos()):Length()<=3000 and (npc:GetPos()-enemy:GetPos()):Length()>=900 then
				if npc:IsCurrentSchedule(SCHED_ESTABLISH_LINE_OF_FIRE) or npc:IsCurrentSchedule(118) or npc:IsCurrentSchedule(98) then
				--thanks for the website maurits.tv for this code(edited it ofc)
			npc:SetLastPosition( util.QuickTrace( enemy:GetShootPos(), enemy:GetAimVector()*1000 ).HitPos + Vector( 0, 0, 40 ) )
			npc:SetSchedule( SCHED_FORCED_GO_RUN )
				end
				elseif (npc:GetPos()-enemy:GetPos()):Length()<=900 then
				if npc:IsCurrentSchedule(SCHED_FORCED_GO_RUN) or npc:IsCurrentSchedule(118) or npc:IsCurrentSchedule(98) then
					timer.Simple(math.Rand(1,2), function()
						if IsValid(npc) then
							if npc:IsCurrentSchedule(SCHED_FORCED_GO_RUN) or npc:IsCurrentSchedule(118) or npc:IsCurrentSchedule(98) then
								if not npc:IsSquadLeader() then
							npc:SetSchedule(SCHED_RUN_RANDOM)
								end
							end
						end
					end)
			timer.Simple(math.Rand(5, 7), function()
				if IsValid(npc) then
					if npc:IsCurrentSchedule(SCHED_RUN_RANDOM) and IsValid(npc:GetNearestSquadMember()) and not npc.AloneSoldier_Player1==true and not npc.AloneSoldier_Player2==true and not npc.AloneSoldier_NPC1==true and not npc.AloneSoldier_NPC2==true then
						if npc:IsSquadLeader() then
							npc:SetSchedule(SCHED_ESTABLISH_LINE_OF_FIRE)
						else
							npc:SetSchedule( SCHED_AMBUSH )
							npc:GetNearestSquadMember():SetSchedule(SCHED_ESTABLISH_LINE_OF_FIRE)
						end
					end
				end
			end)
				end
			end
		end
		end
	end
end

function CombineAI_EnemyTooClose(npc)
	if IsValid(enemy) and npc:Visible(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=200 and (enemy:GetPos()-npc:GetPos()):Length() >=30 and enemy:Health()>=enemy:GetMaxHealth()/2.5 then
		if npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE then
		npc:SetSchedule(SCHED_MOVE_AWAY)
	end
	end
end

function CombineAI_StealthMovement(npc)
	if npc:GetInternalVariable("skin")==1 and IsValid(enemy) and !npc:Visible(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=755 and (enemy:GetPos()-npc:GetPos()):Length() >=251 and !npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_BEST_SOUND) and enemy:Health()>=enemy:GetMaxHealth()/2.5 and !alien_zombies[enemy:GetClass()] then 
		if npc:GetMovementActivity(ACT_RUN_RIFLE) then 
			npc:SetMovementActivity( ACT_RUN_CROUCH ) end
		elseif npc:GetInternalVariable("skin")==1 and IsValid(enemy) and !npc:Visible(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=251 and !npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_BEST_SOUND) and enemy:Health()>=enemy:GetMaxHealth()/2.5 and !alien_zombies[enemy:GetClass()] then
			if npc:GetMovementActivity(ACT_RUN_CROUCH) then 
				npc:SetMovementActivity( ACT_WALK_AIM_SHOTGUN )
			end	
		elseif npc:GetInternalVariable("skin")==1 and IsValid(enemy) and npc:Visible(enemy) and !npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_BEST_SOUND) and enemy:Health()>=enemy:GetMaxHealth()/2.5 and !alien_zombies[enemy:GetClass()] then
		if npc:GetMovementActivity(ACT_RUN_CROUCH) or npc:GetMovementActivity(ACT_RUN_RIFLE) or npc:GetMovementActivity(ACT_RUN_CROUCH_RIFLE) or npc:SetMovementActivity( ACT_WALK_AIM_SHOTGUN ) then 
			npc:SetMovementActivity( ACT_RUN_AIM_SHOTGUN ) 
		end	
	end

	if npc:GetInternalVariable("skin")==0 and IsValid(enemy) and !alien_zombies[enemy:GetClass()] and !npc:Visible(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=755 and !npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_BEST_SOUND) and enemy:Health()>=enemy:GetMaxHealth()/2.5 then 
		if npc:GetMovementActivity(ACT_RUN_RIFLE) then 
			npc:SetMovementActivity( ACT_WALK_CROUCH ) 
		end
		elseif npc:GetInternalVariable("skin")==0 and IsValid(enemy) and !alien_zombies[enemy:GetClass()] and npc:Visible(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=755 and !npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_BEST_SOUND) and enemy:Health()>=enemy:GetMaxHealth()/2.5 then 
		if npc:GetMovementActivity(ACT_WALK_CROUCH) then 
				npc:SetMovementActivity( ACT_RUN_AIM_RIFLE ) 
		end
	end
end

function CombineAI_GunsAndShit(npc)
	if IsValid(weapon) then
		if weapon:GetClass()=="weapon_ar2" then
			if IsValid(enemy) and npc:Visible(enemy) then
				if enemy:IsNPC() or enemy:IsPlayer() then
				npc:SetSaveValue("m_vecAltFireTarget", npc:GetEnemy():HeadTarget(Vector(0,0,0))) 
				end
			end
			if GetConVar("kn_realistic_combine_elite"):GetFloat()==1 then 
			npc:SetSaveValue("m_fIsElite", true) 
			end
			if GetConVar("kn_realistic_combine_no_delay_gunshots"):GetFloat()==1 then
			npc:SetSaveValue("m_nShots", npc:GetInternalVariable("m_nShots")+math.random(0.1, 0.23))
			end
			if IsValid(enemy) and npc:Visible(enemy) then 
			npc:SetSaveValue("m_flNextAltFireTime", npc:GetInternalVariable("m_flNextAltFireTime")-0.05) 
			end
		else
			if GetConVar("kn_realistic_combine_frequent_grenades"):GetFloat()==1 then 
				npc:SetSaveValue("m_flNextGrenadeCheck", npc:GetInternalVariable("m_flNextGrenadeCheck")-0.01)
				if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() >= 256 and (enemy:GetPos()-npc:GetPos()):Length() <= 1024 then 
					npc:SetSaveValue("m_hForcedGrenadeTarget", enemy) 
				end 
			end
			npc:SetSaveValue("m_fIsElite", false)
			if GetConVar("kn_realistic_combine_no_delay_gunshots"):GetFloat()==1 then 
			npc:SetSaveValue("m_nShots", npc:GetInternalVariable("m_nShots")+1)
			end
		end
	end	
end

function CombineAI_FastGrenade(npc)
	for k, v in pairs(ents.FindByClass("npc_grenade_frag")) do
		if IsValid(v) and IsValid(v:GetOwner()) and v:GetOwner():GetClass()=="npc_combine_s" then
			if GetConVar("kn_realistic_combine_promixity_grenade"):GetFloat()==1 then
				if IsValid(enemy) then
					if (v:GetPos()-enemy:GetPos()):Length()<=100 and v:Visible(enemy) then
					v:SetSaveValue("m_flDetonateTime", v:GetInternalVariable("m_flDetonateTime")-math.random(0.002, 0.01))
					end
				end
			end
		end
	end
end

function CombineAI_RememberEnemy(npc)
	if enemy:IsNPC() then
		for k,v in ipairs(ents.FindByClass("npc_*")) do 
			if IsValid(v) then
				if enemy==v then
				npc:UpdateEnemyMemory(v, v:GetPos())
				npc:SetEnemy(v)
				end
			end
		end
	elseif enemy:IsPlayer() then
		for k,v in ipairs(player.GetAll()) do 
			if IsValid(v) then
				if enemy==v then
				npc:UpdateEnemyMemory(v, v:GetPos())
				npc:SetEnemy(v)
				end
			end
		end
	end
end

function CombineAI_MakeEnemyInFarDistance(npc)
	if not npc:GetNPCState()==NPC_STATE_COMBAT then
		for k,v in ipairs(ents.FindByClass("npc_*")) do 
			if v:GetSquad()==npc:GetSquad() then
				if IsValid(v:GetEnemy()) then
					npc:SetEnemy(v:GetEnemy())
				end
			end
		end
	end
end

function CombineAI(npc)
	if IsValid(npc) then
		weapon = npc:GetInternalVariable("m_hActiveWeapon")
		enemy = npc:GetInternalVariable("m_hEnemy")
		alien_zombies = {
			["npc_antlion"]=true,
			["npc_antlion_grub"]=true,
			["npc_antlionguard"]=true,
			["npc_antlionguardian"]=true,
			["npc_antlion_worker"]=true,
			["npc_headcrab_fast"]=true,
			["npc_fastzombie"]=true,
			["npc_fastzombie_torso"]=true,
			["npc_headcrab"]=true,
			["npc_headcrab_black"]=true,
			["npc_poisonzombie"]=true,
			["npc_zombie"]=true,
			["npc_zombie_torso"]=true,
			["npc_zombine"]=true,
			["npc_barnacle"]=true,
		}
		
		if npc:GetNPCState()==NPC_STATE_COMBAT then--only apply the following ai behaviors if they are in combat, this has the advantage of reducing lag.
			CombineAI_RememberEnemy(npc)--makes them not forget the enemy
			CombineAI_ShootMoreThanTwo(npc)--makes more than 2 soldiers shoot, in hl2 and gmod they are dumb asf. spawn like 100 of them and only 2 of them shoot.
			CombineAI_ReloadLow(npc)--makes soldiers crouch reload
			CombineAI_GunAccuracy(npc)--modified gun accuracy of soldiers
			CombineAI_AloneSoldier(npc)--ai behavior if soldiers are alone. makes them run away from enemies that has a weapon because thats realistic.
			CombineAI_MoreChatter(npc)--makes them chat more. poorly coded.
			CombineAI_AvoidPlayerCrosshair(npc)--makes soldier run in random directions just to avoid player crosshair. 
			CombineAI_FlankRevisedBehavior(npc)--'better' flank behavior
			CombineAI_EnemyTooClose(npc)--makes soldiers move away from enemies unless they are too closed. they can still do melee attacks.
			CombineAI_StealthMovement(npc)--makes soldiers not make any footstep sound and generally slow walk
			CombineAI_GunsAndShit(npc)--edited weapon properties such as making them elite, auto gunshots, frequent grenade throwings, etc...
			CombineAI_FastGrenade(npc)--makes grenades that are owned by soldiers to explode fast in enemy proximity
			CombineAI_NoFlinch(npc)--makes them not flinch. not realistic tho. but this is number one reason why these guys are sooo dumb and weak and die fast from my testing. i have to do this.
		end
		--MORE AI BEHAVIORS DOWN BELOW WITH EXPLANATION
		CombineAI_MakeEnemyInFarDistance(npc)
		CombineAI_PropsAndExplosives(npc)--this ai behavior makes them run from burning barrels and hl2 grenades.
	end
end

function Think()
	for k, v in pairs(ents.FindByClass("npc_combine_s")) do
		if IsValid(v) then
		CombineAI(v)
		end
	end
end

function CombineAI_Died(npc, attacker, inflictor)--AI behavior that makes other soldiers run away if a soldier dies
	if npc:GetClass()=="npc_combine_s" then
		for k, v in pairs(ents.FindByClass("npc_combine_s")) do
			if IsValid(v:GetNearestSquadMember()) then
				if (v:GetPos()-v:GetNearestSquadMember():GetPos()):Length()<=3000 then
				v:GetNearestSquadMember():SetSchedule(SCHED_RUN_FROM_ENEMY)
				end
			end
		end
	end
end

hook.Add( "OnNPCKilled", "CombineDiedMaggle", function( npc, attacker, inflictor )
	CombineAI_Died(npc,attacker,inflictor)
end)

hook.Add("Tick", "Combine_kenni_maggle", function()
	if GetConVar("kn_realistic_combine"):GetFloat()==1 then
		if GetConVar("kn_realistic_combine_ai"):GetFloat()==1 then
		Think()
		end
	end
end)

function CombineAI_Spawned(ent)--Called as soon as the soldier is spawned. Basically gives them more health, makes them jump, long visibility,
	if GetConVar("kn_realistic_combine"):GetFloat()==1 then
		if GetConVar("kn_realistic_combine_health"):GetFloat()==1 then
			if ( ent:GetClass() == "npc_combine_s" ) then
				timer.Simple(0,function() 
					if IsValid(ent) then 
					local weapon = ent:GetInternalVariable("m_hActiveWeapon")
						if IsValid(weapon) and weapon:GetClass()=="weapon_ar2" or IsValid(weapon) and weapon:GetHoldType()=="shotgun" then 
							ent:SetHealth(ent:Health()+50)
							ent:SetMaxHealth(ent:GetMaxHealth()+50)
						else ent:SetHealth(ent:Health()+30)
							 ent:SetMaxHealth(ent:GetMaxHealth()+30)
						end
					end 
				end)
			end
		end

		--[[if GetConVar("kn_realistic_combine_ai"):GetFloat()==1 then
			if (ent:GetClass()=="prop_physics") then
			ent.Prop=true
			elseif (ent:GetClass()=="npc_grenade_frag") then
			ent.Grenade=true
			end]]--
		if ( ent:GetClass() == "npc_combine_s" ) then
			ent:CapabilitiesAdd( CAP_NO_HIT_SQUADMATES + CAP_MOVE_JUMP + CAP_USE + CAP_AUTO_DOORS + CAP_OPEN_DOORS + CAP_FRIENDLY_DMG_IMMUNE)
			if GetConVar("kn_realistic_combine_long_visibility"):GetFloat()==1 then 
				ent:SetKeyValue( "spawnflags", "256" ) 
			end
		end
	end
end

hook.Add( "OnEntityCreated", "InitCombine)kenni", function( ent ) 
	CombineAI_Spawned(ent)
end )

function CombineAI_TakingDamage(npc, hitgroup, dmginfo)
--AI Behavior and hl2 boosted weapon damages. 
--If a soldier takes damage then it will take cover and other soldiers as well. 
--Also boosts bullet damage for their hl2 weapons against npcs, we dont want to do this to sweps.
	if GetConVar("kn_realistic_combine"):GetFloat()==1 then
		if npc:GetClass()=="npc_combine_s" then 
			if dmginfo:GetAttacker():GetClass()=="npc_combine_s" then
		else npc.Combinehide=true 
				if npc.Combinehide==true then 
					timer.Simple(1.5, function() 
						if IsValid(npc) and IsValid(npc:GetNearestSquadMember()) and npc.Combinehide==true and not npc.SoldierReloading==true and not npc:IsCurrentSchedule(SCHED_RUN_FROM_ENEMY) then
						npc.Combinehide=false
						npc:SetSchedule(SCHED_RUN_FROM_ENEMY)
						if (npc:GetPos()-npc:GetNearestSquadMember():GetPos()):Length()<=700 and npc:Visible(npc:GetNearestSquadMember()) then
						npc:GetNearestSquadMember():SetSchedule(SCHED_RUN_FROM_ENEMY)
						end
						end
					end)
				end
			end
		end

		if GetConVar("kn_realistic_combine_damage_npc"):GetFloat()==1 then
			local attacker = dmginfo:GetAttacker()
			local com = dmginfo:GetAttacker():GetClass()=="npc_combine_s"
			local comwep = dmginfo:GetAttacker():GetInternalVariable("m_hActiveWeapon")

			if IsValid(attacker) and ( com ) then
				if IsValid(comwep) and ( comwep:GetClass()=="weapon_shotgun" ) and dmginfo:IsBulletDamage()==true then
					dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*1.838950423)
				elseif IsValid(comwep) and (comwep:GetClass()=="weapon_smg1") and dmginfo:IsBulletDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*0.6174814892)
				elseif IsValid(comwep) and (comwep:GetClass()=="weapon_ar2") and dmginfo:IsBulletDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*1.061818195)
				elseif dmginfo:IsExplosionDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*0.044)
				else return NULL 
				end
			end
		end
	end
end

hook.Add("ScaleNPCDamage","kenni_combine_ddddddddddddddd", function( npc, hitgroup, dmginfo )
	CombineAI_TakingDamage(npc,hitgroup,dmginfo)
end)

function playerdamage_maggle( ply, hitgroup, dmginfo )
--Same thing as above but boosts hl2 weapon damages against the player.
	if GetConVar("kn_realistic_combine"):GetFloat()==1 then
		if GetConVar("kn_realistic_combine_damage_player"):GetFloat()==1 then
			local attacker = dmginfo:GetAttacker()
			local com = dmginfo:GetAttacker():GetClass()=="npc_combine_s"
			local comwep = dmginfo:GetAttacker():GetInternalVariable("m_hActiveWeapon")

			if IsValid(attacker) and ( com ) then
				if IsValid(comwep) and ( comwep:GetClass()=="weapon_shotgun" ) and dmginfo:IsBulletDamage()==true then
					dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*1.838950423)
				elseif IsValid(comwep) and (comwep:GetClass()=="weapon_smg1") and dmginfo:IsBulletDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*0.6174814892)
				elseif IsValid(comwep) and (comwep:GetClass()=="weapon_ar2") and dmginfo:IsBulletDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*1.061818195)
				elseif dmginfo:IsExplosionDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*0.044)
				else return NULL 
				end
			end
		end
	end
end

hook.Add("ScalePlayerDamage","kenni_damage_combine", playerdamage_maggle)
