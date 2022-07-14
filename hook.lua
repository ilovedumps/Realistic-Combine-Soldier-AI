if not ConVarExists("kn_realistic_combine") then
	CreateConVar("kn_realistic_combine", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)--only checks if this convar exists because we only need to know if this does exist, that way we dont need to check for the other convars.
	CreateConVar("kn_realistic_combine_promixity_grenade", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_ai", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_npc_ar2_value", 1.061818195, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_npc_smg1_value", 0.6174814892, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_npc_shotgun_value", 1.838950423, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_player_ar2_value", 1.061818195, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_player_smg1_value", 0.6174814892, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_player_shotgun_value", 1.838950423, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_npc", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_jump", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_damage_player", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_health_normal_soldiers_value", 30, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_health_elite_and_shotgunners_soldiers_value", 50, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_health", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_flinch", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_elite", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_better_flank_behavior", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_accuracy", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_long_visibility", 0, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_frequent_grenades", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_no_delay_gunshots", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_make_them_talk_more", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_avoid_player_crosshair", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_improved_grenade_behavior", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_soldiers_shoot_more_than_two", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_soldiers_soldiers_reload_low", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_soldiers_alone_soldier_instinct", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_soldiers_soldiers_move_away_whentooclose_from_enemy", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_soldiers_soldier_stealth", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_run_from_dead", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_run_from_damage", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_injured_soldier", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_patrol", 0, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_hide_on_spawn", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_smg_grenades", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_elite_quick_fires", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_elite_aim_for_head", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_fov", 1, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_fov_value", 0.5, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_dont_shoot_when_moving", 0, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_shooting_becomes_inaccurate_when_moving", 0, FCVAR_NOTIFY + FCVAR_ARCHIVE)
	CreateConVar("kn_realistic_combine_shooting_and_moving_values", 0, FCVAR_NOTIFY + FCVAR_ARCHIVE)
end
--GO TO CODE function CombineAI for full explanation
function CombineAI_Grenade(npc)
	for _, grenadefrag in ipairs(ents.FindByClass("npc_grenade_frag")) do
		if GetConVarNumber("kn_realistic_combine_improved_grenade_behavior")==1 then
			if IsValid(grenadefrag) and (grenadefrag:GetPos()-npc:GetPos()):Length() <=250 then
				local get = npc:GetCurrentSchedule()<=LAST_SHARED_SCHEDULE
				if get and not npc:IsCurrentSchedule(SCHED_COWER) or npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_BEST_SOUND) then
					npc:SetSchedule(SCHED_FLEE_FROM_BEST_SOUND)
				end
			end
		end
		if GetConVar("kn_realistic_combine_promixity_grenade"):GetFloat()==1 then
			if IsValid(grenadefrag) and IsValid(grenadefrag:GetOwner()) and grenadefrag:GetOwner():GetClass()=="npc_combine_s" then
				if IsValid(enemy) then
					if (grenadefrag:GetPos()-enemy:GetPos()):Length()<=100 and grenadefrag:Visible(enemy) then
					grenadefrag:SetSaveValue("m_flDetonateTime", grenadefrag:GetInternalVariable("m_flDetonateTime")-math.random(0.002, 0.01))
					end
				end
			end
		end
	end
end

function CombineAI_ShootMoreThanTwo(npc)
	if GetConVarNumber("kn_realistic_combine_soldiers_shoot_more_than_two")==1 then
		if npc:GetInternalVariable("m_iMySquadSlot")==-1 then 
		npc:SetSaveValue("m_iMySquadSlot", 1) 
		end
	end

	if enemy:IsNPC() or enemy:IsPlayer() then
		if npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_ENEMY)then
		npc:SetSchedule(SCHED_RANGE_ATTACK1)
		end
	end
end

function CombineAI_ReloadLow(npc)
	if GetConVarNumber("kn_realistic_combine_soldiers_soldiers_reload_low")==1 then
		if npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) and IsValid(enemy) and !npc:Visible(enemy) then 
			npc:SetSchedule(SCHED_RELOAD)
		end
		if npc:IsCurrentSchedule(SCHED_RELOAD) then
			if npc:GetMovementActivity(ACT_RELOAD) then
				npc:SetActivity(ACT_RELOAD_LOW)
				npc.SoldierReloading=true
			end
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
	if npc:GetGroundSpeedVelocity()==Vector(0,0,0) then
		if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==1 then
			if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
				npc:SetSaveValue("m_CurrentWeaponProficiency", 10)
		else	
				npc:SetSaveValue("m_CurrentWeaponProficiency", 4)
			end
		end

		if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==2 then
			if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
				npc:SetSaveValue("m_CurrentWeaponProficiency", 4)
		else 
				npc:SetSaveValue("m_CurrentWeaponProficiency", 3)
			end
		end

		if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==3 then
			if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
				npc:SetSaveValue("m_CurrentWeaponProficiency", 3)
		else 
				npc:SetSaveValue("m_CurrentWeaponProficiency", 2)
			end
		end

		if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==4 then
			if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
				npc:SetSaveValue("m_CurrentWeaponProficiency", 2)
		else 
				npc:SetSaveValue("m_CurrentWeaponProficiency", 1)
			end
		end

		if GetConVar("kn_realistic_combine_accuracy"):GetFloat()==5 then
			if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=1200 then 
				npc:SetSaveValue("m_CurrentWeaponProficiency", 1)
		else 
				npc:SetSaveValue("m_CurrentWeaponProficiency", 0)
			end
		end
	else
		if GetConVarNumber("kn_realistic_combine_shooting_becomes_inaccurate_when_moving")==1 then
			if GetConVarNumber("kn_realistic_combine_shooting_and_moving_values") == 1 then
				npc:SetSaveValue("m_CurrentWeaponProficiency", 10)
			elseif GetConVarNumber("kn_realistic_combine_shooting_and_moving_values") == 2 then
				npc:SetSaveValue("m_CurrentWeaponProficiency", 4)
			elseif GetConVarNumber("kn_realistic_combine_shooting_and_moving_values") == 3 then
				npc:SetSaveValue("m_CurrentWeaponProficiency", 3)
			elseif GetConVarNumber("kn_realistic_combine_shooting_and_moving_values") == 4 then
				npc:SetSaveValue("m_CurrentWeaponProficiency", 2)
			elseif GetConVarNumber("kn_realistic_combine_shooting_and_moving_values") == 5 then
				npc:SetSaveValue("m_CurrentWeaponProficiency", 1)
			end
		end
	end

	if GetConVarNumber("kn_realistic_combine_dont_shoot_when_moving")==1 then
		npc:CapabilitiesRemove(CAP_MOVE_SHOOT)
	else
		npc:CapabilitiesAdd(CAP_MOVE_SHOOT)
	end
end

function CombineAI_AloneSoldier(npc)
	if GetConVarNumber("kn_realistic_combine_soldiers_alone_soldier_instinct")==1 then
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
end

function CombineAI_MoreChatter(npc)
	if GetConVar("kn_realistic_combine_make_them_talk_more"):GetFloat()==1 then
		if npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) and IsValid(enemy) and !npc:Visible(enemy) and npc:IsSquadLeader()==true then 
		npc:PlaySentence("COMBINE_LOST_SHORT", 0, 1) 
		elseif npc:IsCurrentSchedule(SCHED_HIDE_AND_RELOAD) and IsValid(enemy) and !npc:Visible(enemy) and npc:IsSquadLeader()==false then
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
	if GetConVarNumber("kn_realistic_combine_avoid_player_crosshair")==1 then
		if enemy:IsPlayer() then
			local tr = enemy:GetEyeTrace() 
			local ent = tr.Entity 
				if ( !IsValid( ent ) ) then return end 
			if ent:GetClass()=="npc_combine_s" then
			ent.IamBeingSeen=true
			end
		end

		if IsValid(enemy) and enemy:GetClass()=="player" and IsValid(enemy:GetActiveWeapon()) and npc.IamBeingSeen==true and IsValid(npc:GetNearestSquadMember()) then 
			npc.IamBeingSeen=false 
			if npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE then 
				npc:SetSchedule(SCHED_RUN_RANDOM)
				npc:GetNearestSquadMember():SetSchedule(SCHED_RUN_RANDOM)
			end
		end
	end
end

function CombineAI_FlankRevisedBehavior(npc)
	if GetConVar("kn_realistic_combine_better_flank_behavior"):GetFloat()==1 then
		if npc:IsCurrentSchedule(SCHED_FORCED_GO_RUN) and IsValid(enemy) and npc:Visible(enemy) or npc:IsCurrentSchedule(SCHED_AMBUSH) and IsValid(enemy) and enemy:Visible(npc) then
			npc:SetSchedule(SCHED_RANGE_ATTACK1)
		elseif npc:IsCurrentSchedule(SCHED_AMBUSH) and IsValid(enemy) and enemy:Health()<1 then
			npc:SetSchedule(SCHED_INVESTIGATE_SOUND)
		elseif npc:IsCurrentSchedule(SCHED_AMBUSH) and npc:GetMovementActivity(ACT_IDLE) then
			npc:SetActivity(ACT_COVER_LOW)
		end

		if enemy:IsNPC() or enemy:IsPlayer() then
			if GetConVarNumber("kn_realistic_combine_injured_soldier")==1 then
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
			if npc:GetInternalVariable("skin")==0 and IsValid(npc:GetNearestSquadMember()) and IsValid(enemy) and !npc:Visible(enemy) and enemy:Health()>=enemy:GetMaxHealth()/2.5 and IsValid(enemy:GetActiveWeapon()) and !alien_zombies[enemy:GetClass()] then
				if (npc:GetPos()-enemy:GetPos()):Length()<=3000 and (npc:GetPos()-enemy:GetPos()):Length()>=500 then
					if npc:IsCurrentSchedule(SCHED_ESTABLISH_LINE_OF_FIRE) or npc:IsCurrentSchedule(118) or npc:IsCurrentSchedule(98) then
						npc:SetLastPosition( enemy:GetPos() )
						npc:SetSchedule( SCHED_FORCED_GO_RUN )
					end
				elseif (npc:GetPos()-enemy:GetPos()):Length()<=755 then
					if npc:IsCurrentSchedule(SCHED_FORCED_GO_RUN) or npc:IsCurrentSchedule(118) or npc:IsCurrentSchedule(98) then
						if not npc:IsSquadLeader() or IsValid(npc:GetActiveWeapon()) and not npc:GetActiveWeapon():GetHoldType()=="shotgun" then
							npc:SetSchedule(SCHED_RUN_RANDOM)
						elseif npc:IsSquadLeader() or IsValid(npc:GetActiveWeapon()) and npc:GetActiveWeapon():GetHoldType()=="shotgun" then
							npc:SetSchedule(SCHED_ESTABLISH_LINE_OF_FIRE)
						end
						if npc:GetCurrentSchedule()>=SCHED_RUN_RANDOM and not npc:IsSquadLeader() and IsValid(npc:GetNearestSquadMember()) and not npc.AloneSoldier_Player1==true and not npc.AloneSoldier_Player2==true and not npc.AloneSoldier_NPC1==true and not npc.AloneSoldier_NPC2==true then
							timer.Simple(3, function()
								if IsValid(npc) then
									npc:SetSchedule( SCHED_AMBUSH )
								end
							end)
						end
					end
				end
			end
		end
	end
end

function CombineAI_ProtectSquadLeaderBehavior(npc)
	if not npc:IsCurrentSchedule(SCHED_FORCED_GO_RUN) and npc:GetCurrentSchedule()<=SCHED_FORCED_GO_RUN then
		if npc:IsSquadLeader() then
			if (npc:GetPos()-npc:GetNearestSquadMember():GetPos()):Length()>=100 then
			npc:GetNearestSquadMember():SetLastPosition(npc:GetPos())
			npc:GetNearestSquadMember():SetSchedule(SCHED_FORCED_GO_RUN)
			npc.Exclude=true
			end
		end
	end
end

function CombineAI_EnemyTooClose(npc)
	if GetConVarNumber("kn_realistic_combine_soldiers_soldiers_move_away_whentooclose_from_enemy")==1 then
		if IsValid(enemy) and npc:Visible(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=200 and (enemy:GetPos()-npc:GetPos()):Length() >=30 and enemy:Health()>=enemy:GetMaxHealth()/2.5 then
			if npc:GetCurrentSchedule()>=LAST_SHARED_SCHEDULE then
			npc:SetSchedule(SCHED_MOVE_AWAY)
			end
		end
	end
end

function CombineAI_StealthMovement(npc)
	if GetConVarNumber("kn_realistic_combine_soldiers_soldier_stealth")==1 then
		if npc.SoldierCrouch==true then
			if npc:GetInternalVariable("skin")==1 and IsValid(enemy) and !npc:Visible(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=755 and (enemy:GetPos()-npc:GetPos()):Length() >=251 and !npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_BEST_SOUND) and enemy:Health()>=enemy:GetMaxHealth()/2.5 and !alien_zombies[enemy:GetClass()] then 
				if npc:GetMovementActivity(ACT_RUN_RIFLE) then 
					npc:SetMovementActivity( ACT_RUN_CROUCH ) end
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
		elseif npc.SoldierWalk==true then
			if npc:GetInternalVariable("skin")==0 and IsValid(enemy) and !alien_zombies[enemy:GetClass()] and !npc:Visible(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=755 and !npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_BEST_SOUND) and enemy:Health()>=enemy:GetMaxHealth()/2.5 then 
				if npc:GetMovementActivity(ACT_RUN_RIFLE) then 
					npc:SetMovementActivity( ACT_WALK_AIM_RIFLE ) 
				end
				elseif npc:GetInternalVariable("skin")==0 and IsValid(enemy) and !alien_zombies[enemy:GetClass()] and npc:Visible(enemy) and (enemy:GetPos()-npc:GetPos()):Length() <=755 and !npc:IsCurrentSchedule(SCHED_TAKE_COVER_FROM_BEST_SOUND) and enemy:Health()>=enemy:GetMaxHealth()/2.5 then 
				if npc:GetMovementActivity(ACT_WALK_AIM_RIFLE) then 
					npc:SetMovementActivity( ACT_RUN_AIM_RIFLE ) 
				end
			end
		end
	end
end

function CombineAI_GunsAndShit(npc)
	if IsValid(weapon) then
		if weapon:GetClass()=="weapon_ar2" then
			if GetConVarNumber("kn_realistic_combine_elite_aim_for_head")==1 then
				if IsValid(enemy) and npc:Visible(enemy) then
					if enemy:IsNPC() or enemy:IsPlayer() then
					npc:SetSaveValue("m_vecAltFireTarget", npc:GetEnemy():HeadTarget(Vector(0,0,0))) 
					end
				end
			end
			if GetConVar("kn_realistic_combine_elite"):GetFloat()==1 then 
				npc:SetSaveValue("m_fIsElite", true) 
			end
			if GetConVar("kn_realistic_combine_no_delay_gunshots"):GetFloat()==1 then
				if IsValid(enemy) then
					if npc:GetActiveWeapon():Visible(enemy) then 
					npc:SetSaveValue("m_nShots", npc:GetInternalVariable("m_nShots")+math.random(0.1, 0.23))
					end
				end
			end
			if GetConVarNumber("kn_realistic_combine_elite_quick_fires")==1 then
				if IsValid(enemy) and npc:Visible(enemy) then 
					npc:SetSaveValue("m_flNextAltFireTime", npc:GetInternalVariable("m_flNextAltFireTime")-0.05) 
				end
			end
		elseif weapon:GetClass()=="weapon_smg1" then
			if GetConVar("kn_realistic_combine_frequent_grenades"):GetFloat()==1 then 
				npc:SetSaveValue("m_flNextGrenadeCheck", npc:GetInternalVariable("m_flNextGrenadeCheck")-0.01)
				if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length() >= 250 and (enemy:GetPos()-npc:GetPos()):Length() <= 1300 then 
					npc:SetSaveValue("m_hForcedGrenadeTarget", enemy) 
				end 
			end
			if GetConVarNumber("kn_realistic_combine_smg_grenades")==1 then
				if npc:GetGroundSpeedVelocity()==Vector(0,0,0) then
					if not npc:GetInternalVariable("m_fIsElite") then
						if IsValid(enemy) and (enemy:GetPos()-npc:GetPos()):Length()>=250 and (enemy:GetPos()-npc:GetPos()):Length() <=1300 then
							if math.random(1,5)==3 then
								timer.Simple(0.5, function()
									if IsValid(npc) then
										npc:SetSaveValue("m_fIsElite",true)
										if npc:GetInternalVariable("m_fIsElite") and GetConVarNumber("kn_realistic_combine_frequent_grenades")==0 then
										npc:SetSaveValue("m_hForcedGrenadeTarget", enemy)
										end
									end
								end)
							end
						end
					else
					timer.Simple(1, function()
						if IsValid(npc) then
							npc:SetSaveValue("m_fIsElite",false)
						end
					end)
					end
				end
			end
			if GetConVar("kn_realistic_combine_no_delay_gunshots"):GetFloat()==1 then
				if IsValid(enemy) then
					if npc:GetActiveWeapon():Visible(enemy) then 
					npc:SetSaveValue("m_nShots", npc:GetInternalVariable("m_nShots")+math.random(0.1, 0.23))
					end
				end
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
				if IsValid(enemy) then
					if npc:GetActiveWeapon():Visible(enemy) then 
					npc:SetSaveValue("m_nShots", npc:GetInternalVariable("m_nShots")+1)
					end
				end
			end
		end
	end	
end

function CombineAI_Patrol(npc)
	if GetConVarNumber("kn_realistic_combine_patrol")==1 then
		if not npc:GetInternalVariable("m_bShouldPatrol") then
			npc:SetSaveValue("m_bShouldPatrol", true)
		end
	end
end

function CombineAI_NerfedFOV(npc)
	if GetConVarNumber("kn_realistic_combine_fov")==1 then
		npc:SetSaveValue("m_flFieldOfView",GetConVarNumber("kn_realistic_combine_fov_value"))
		else
		npc:SetSaveValue("m_flFieldOfView",-0.20000000298023)
	end
end

function CombineAI_RememberEnemy(npc)--modified code of unli vision from inpc
	if GetConVar("kn_realistic_combine_long_visibility"):GetFloat()==1 then 
		for k, v in pairs(ents.FindByClass("npc_*")) do
			if IsValid(v) and npc:IsLineOfSightClear(v) and v:Health() > 0 and npc:Disposition(v) == D_HT then
				npc:SetSaveValue("m_hEnemy",v)
			end
		end

		if GetConVarNumber("ai_ignoreplayers") == 0 then
			for k, v in pairs(player.GetAll()) do
				if IsValid(v) and npc:IsLineOfSightClear(v) and v:Alive() and npc:Disposition(v) == D_HT then
					npc:SetSaveValue("m_hEnemy",v)
				end
			end
		end
		if IsValid(enemy) and npc:IsLineOfSightClear(enemy) then
			npc:UpdateEnemyMemory(enemy, enemy:GetPos())
		end
	end
end

function CombineAI_SquadMemberTooClose(npc)
	if not npc:IsCurrentSchedule(SCHED_MOVE_AWAY) then
		if IsValid(npc:GetNearestSquadMember()) and (npc:GetNearestSquadMember():GetPos()-npc:GetPos()):Length()<=35 and not Exclude then
			npc:SetSchedule(SCHED_MOVE_AWAY)
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

	npc:SetMoveVelocity(npc:GetMoveVelocity()*10)
	
		if npc:GetNPCState()==NPC_STATE_COMBAT then--only apply the following ai behaviors if they are in combat, this has the advantage of reducing lag.
			CombineAI_ShootMoreThanTwo(npc)--makes more than 2 soldiers shoot, in hl2 and gmod they are dumb asf. spawn like 100 of them and only 2 of them shoot.
			CombineAI_ReloadLow(npc)--makes soldiers crouch reload
			CombineAI_SquadMemberTooClose(npc)--make soldiers move away if they are too close
			CombineAI_GunAccuracy(npc)--modified gun accuracy of soldiers
			CombineAI_AloneSoldier(npc)--ai behavior if soldiers are alone. makes them run away from enemies that has a weapon because thats realistic.
			CombineAI_MoreChatter(npc)--makes them chat more. poorly coded idk.
			CombineAI_AvoidPlayerCrosshair(npc)--makes soldier run in random directions just to avoid player crosshair. 
			CombineAI_FlankRevisedBehavior(npc)--'better' flank behavior
			CombineAI_EnemyTooClose(npc)--makes soldiers move away from enemies unless they are too closed. they can still do melee attacks.
			CombineAI_StealthMovement(npc)--makes soldiers not make any footstep sound and generally slow walk
			CombineAI_GunsAndShit(npc)--edited weapon properties such as making them elite, auto gunshots, frequent grenade throwings, etc...
			CombineAI_NoFlinch(npc)--makes them not flinch. not realistic tho. but this is number one reason why these guys are sooo dumb and weak and die fast from my testing. i have to do this.
		else
			CombineAI_Patrol(npc)--make them patrol if not in their combat state
			CombineAI_RememberEnemy(npc)
		end
		CombineAI_NerfedFOV(npc)
		CombineAI_Grenade(npc)--makes soldier run away from grenades and makes their grenade explode fast when near an enemy
		--MORE AI BEHAVIORS DOWN BELOW WITH EXPLANATION
	end
end

function Think()
	for k, v in pairs(ents.FindByClass("npc_combine_s")) do
		if IsValid(v) then
		CombineAI(v)
		end
	end
end

function kn_addon_ConvarChange()
	if GetConVarNumber("kn_realistic_combine_ai")==0 then
		GetConVar("kn_realistic_combine_promixity_grenade"):SetFloat(0)
		GetConVar("kn_realistic_combine_flinch"):SetFloat(0)
		GetConVar("kn_realistic_combine_better_flank_behavior"):SetFloat(0)
		GetConVar("kn_realistic_combine_frequent_grenades"):SetFloat(0)
		GetConVar("kn_realistic_combine_no_delay_gunshots"):SetFloat(0)
		GetConVar("kn_realistic_combine_make_them_talk_more"):SetFloat(0)
		GetConVar("kn_realistic_combine_avoid_player_crosshair"):SetFloat(0)
		GetConVar("kn_realistic_combine_improved_grenade_behavior"):SetFloat(0)
		GetConVar("kn_realistic_combine_soldiers_shoot_more_than_two"):SetFloat(0)
		GetConVar("kn_realistic_combine_soldiers_soldiers_reload_low"):SetFloat(0)
		GetConVar("kn_realistic_combine_soldiers_alone_soldier_instinct"):SetFloat(0)
		GetConVar("kn_realistic_combine_soldiers_soldiers_move_away_whentooclose_from_enemy"):SetFloat(0)
		GetConVar("kn_realistic_combine_soldiers_soldier_stealth"):SetFloat(0)
		GetConVar("kn_realistic_combine_elite"):SetFloat(0)
		GetConVar("kn_realistic_combine_run_from_dead"):SetFloat(0)
		GetConVar("kn_realistic_combine_run_from_damage"):SetFloat(0)
		GetConVar("kn_realistic_combine_injured_soldier"):SetFloat(0)
		GetConVar("kn_realistic_combine_patrol"):SetFloat(0)
		GetConVar("kn_realistic_combine_hide_on_spawn"):SetFloat(0)
		GetConVar("kn_realistic_combine_smg_grenades"):SetFloat(0)
		GetConVar("kn_realistic_combine_elite_aim_for_head"):SetFloat(0)
		GetConVar("kn_realistic_combine_fov"):SetFloat(0)
		GetConVar("kn_realistic_combine_long_visibility"):SetFloat(0)
		GetConVar("kn_realistic_combine_shooting_becomes_inaccurate_when_moving"):SetFloat(0)
		GetConVar("kn_realistic_combine_dont_shoot_when_moving"):SetFloat(0)
	end

	if GetConVarNumber("kn_realistic_combine_long_visibility")==1 and GetConVarNumber("kn_realistic_combine_fov")==1 then
		timer.Simple(0.1, function()
		GetConVar("kn_realistic_combine_long_visibility"):SetFloat(0)
		GetConVar("kn_realistic_combine_fov"):SetFloat(0)
		end)
	end

	if GetConVarNumber("kn_realistic_combine_dont_shoot_when_moving")==1 and GetConVarNumber("kn_realistic_combine_shooting_becomes_inaccurate_when_moving")==1 then
		timer.Simple(0.1, function()
		GetConVar("kn_realistic_combine_shooting_becomes_inaccurate_when_moving"):SetFloat(0)
		GetConVar("kn_realistic_combine_dont_shoot_when_moving"):SetFloat(0)
		end)
	end

end

function CombineAI_Died(npc, attacker, inflictor)--AI behavior that makes other soldiers run away if a soldier dies
	if GetConVar("kn_realistic_combine"):GetFloat()==1 then
		if GetConVar("kn_realistic_combine_ai"):GetFloat()==1 then
			if GetConVarNumber("kn_realistic_combine_run_from_dead")==1 then
				if npc:GetClass()=="npc_combine_s" then
					if IsValid(npc:GetNearestSquadMember()) then
						if (npc:GetPos()-npc:GetNearestSquadMember():GetPos()):Length()<=3000 then
							npc:SetSchedule(SCHED_RUN_FROM_ENEMY)
							npc.SoldierDied=true
						end
					end
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
	kn_addon_ConvarChange()
		if GetConVar("kn_realistic_combine_ai"):GetFloat()==1 then
		Think()
		end
	end
end)

function CombineAI_Spawned(ent)--Called as soon as the soldier is spawned. Basically gives them more health, makes them jump, long visibility,
	if GetConVar("kn_realistic_combine"):GetFloat()==1 then
		if ( ent:GetClass() == "npc_combine_s" ) then
			if GetConVar("kn_realistic_combine_health"):GetFloat()==1 then
				timer.Simple(0,function() 
					if IsValid(ent) then 
					local weapon = ent:GetInternalVariable("m_hActiveWeapon")
						if IsValid(weapon) and weapon:GetClass()=="weapon_ar2" or IsValid(weapon) and weapon:GetHoldType()=="shotgun" then 
							ent:SetHealth(ent:Health()+GetConVarNumber("kn_realistic_combine_health_elite_and_shotgunners_soldiers_value"))
							ent:SetMaxHealth(ent:GetMaxHealth()+GetConVarNumber("kn_realistic_combine_health_elite_and_shotgunners_soldiers_value"))
						else ent:SetHealth(ent:Health()+GetConVarNumber("kn_realistic_combine_health_normal_soldiers_value"))
							 ent:SetMaxHealth(ent:GetMaxHealth()+GetConVarNumber("kn_realistic_combine_health_normal_soldiers_value"))
						end
					end 
				end)
			end
			ent:CapabilitiesAdd( CAP_NO_HIT_SQUADMATES + CAP_USE + CAP_AUTO_DOORS + CAP_OPEN_DOORS + CAP_FRIENDLY_DMG_IMMUNE)
			if GetConVar("kn_realistic_combine_long_visibility"):GetFloat()==1 then 
				ent:SetKeyValue( "spawnflags", "256" ) 
			end
			if (GetConVarNumber("kn_realistic_combine_jump")==1) then
				ent:CapabilitiesAdd( CAP_MOVE_JUMP )
			end
			if math.random(1,2)==1 then
				ent.SoldierWalk=true
			elseif math.random(1,2)==2 then
				ent.SoldierCrouch=true
			end
			--[[timer.Simple(0, function()
				if IsValid(ent) then
					Weap1 = "simple_css_ak47"
					Weap2 = "simple_css_famas"
					Weap3 = "simple_css_galil"
					Weap4 = "simple_css_m249"
					Weap5 = "simple_css_m4a1"
					Weap6 = "simple_css_mp5"
					Weap7 = "simple_css_p90"
					Weap8 = "simple_css_ump"
					Weap9 = "simple_css_m3"
					Weap10 = "simple_css_xm1014"
					local Weapon = {}
						Weapon[1] = (Weap1)
						Weapon[2] = (Weap2)
						Weapon[3] = (Weap3)
						Weapon[4] = (Weap4)
						Weapon[5] = (Weap5)
						Weapon[6] = (Weap6)
						Weapon[7] = (Weap7)
						Weapon[8] = (Weap8)
						Weapon[9] = (Weap9)
						Weapon[10] = (Weap10)
					if ent:GetSkin()==1 then
					ent:Give(Weapon[math.random(9,10)])
					else
					ent:Give( Weapon[math.random(1,8)] )
					end
				end
			end)]]--
		end
	end
end

function CombineAI_PlayerSpawned(ply,ent)
	if IsValid(ply) and IsValid(ent) then
		if GetConVarNumber("kn_realistic_combine")==1 then
			if GetConVarNumber("kn_realistic_combine_ai")==1 then
				if GetConVarNumber("kn_realistic_combine_hide_on_spawn")==1 then
					if (ent:GetClass()=="npc_combine_s") then
						timer.Simple(1, function()
							if IsValid(ent) and IsValid(ent:GetNearestSquadMember()) and not IsValid(enemy) and not ent:GetNearestSquadMember():IsCurrentSchedule(SCHED_TAKE_COVER_FROM_ENEMY) then
								ent:GetNearestSquadMember():SetSchedule(SCHED_TAKE_COVER_FROM_ENEMY)
							end
						end)
					end
				end
			end
		end
	end
end

hook.Add( "OnEntityCreated", "InitCombine)kenni", function( ent ) 
	CombineAI_Spawned(ent)
end )

hook.Add( "PlayerSpawnedNPC", "InitCombine)kenni", function(ply, ent)
	CombineAI_PlayerSpawned(ply,ent)
end)

function CombineAI_RunAwayFromDamage(npc,h,d)
	local npc_member = npc:GetNearestSquadMember()
	if not npc:IsCurrentSchedule(SCHED_RUN_FROM_ENEMY) and not npc:IsCurrentSchedule(SCHED_FLEE_FROM_BEST_SOUND) and not npc:IsCurrentSchedule(SCHED_RELOAD) then
		npc:SetSchedule(SCHED_RUN_FROM_ENEMY)
		if IsValid(npc:GetNearestSquadMember()) and (npc:GetPos()-npc:GetNearestSquadMember():GetPos()):Length()<=700 and npc:GetNearestSquadMember():Visible(npc) and not npc:GetNearestSquadMember():IsCurrentSchedule(SCHED_RUN_FROM_ENEMY) and not npc:GetNearestSquadMember():IsCurrentSchedule(SCHED_FLEE_FROM_BEST_SOUND) and not npc:GetNearestSquadMember():IsCurrentSchedule(SCHED_RELOAD) then
			npc:GetNearestSquadMember():SetSchedule(SCHED_RUN_FROM_ENEMY)
		end
	end
end

function CombineAI_TakingDamage(npc, hitgroup, dmginfo)
--AI Behavior and hl2 boosted weapon damages. 
--If a soldier takes damage then it will take cover and other soldiers as well. 
--Also boosts bullet damage for their hl2 weapons against npcs, we dont want to do this to sweps.
	if GetConVar("kn_realistic_combine"):GetFloat()==1 then
		if GetConVar("kn_realistic_combine_ai"):GetFloat()==1 then
			if GetConVarNumber("kn_realistic_combine_run_from_damage")==1 then
				if IsValid(npc) and npc:GetClass()=="npc_combine_s" then 
					if dmginfo:GetAttacker():GetClass()=="npc_combine_s" then
						CombineAI_RunAwayFromDamage(npc, hitgroup, dmginfo)
					else
						CombineAI_RunAwayFromDamage(npc, hitgroup, dmginfo)
					end
				end
			end
		end

		if GetConVar("kn_realistic_combine_damage_npc"):GetFloat()==1 then
			local attacker = dmginfo:GetAttacker()
			local com = dmginfo:GetAttacker():GetClass()=="npc_combine_s"
			local comwep = dmginfo:GetAttacker():GetInternalVariable("m_hActiveWeapon")

			if IsValid(attacker) and ( com ) then
				if IsValid(comwep) and ( comwep:GetClass()=="weapon_shotgun" ) and dmginfo:IsBulletDamage()==true then
					dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*GetConVarNumber("kn_realistic_combine_damage_npc_shotgun_value"))
				elseif IsValid(comwep) and (comwep:GetClass()=="weapon_smg1") and dmginfo:IsBulletDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*GetConVarNumber("kn_realistic_combine_damage_npc_smg1_value"))
				elseif IsValid(comwep) and (comwep:GetClass()=="weapon_ar2") and dmginfo:IsBulletDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*GetConVarNumber("kn_realistic_combine_damage_npc_ar2_value"))
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
					dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*GetConVarNumber("kn_realistic_combine_damage_player_shotgun_value"))
				elseif IsValid(comwep) and (comwep:GetClass()=="weapon_smg1") and dmginfo:IsBulletDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*GetConVarNumber("kn_realistic_combine_damage_player_smg1_value"))
				elseif IsValid(comwep) and (comwep:GetClass()=="weapon_ar2") and dmginfo:IsBulletDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*GetConVarNumber("kn_realistic_combine_damage_player_ar2_value"))
				elseif dmginfo:IsExplosionDamage()==true then dmginfo:ScaleDamage(dmginfo:GetBaseDamage()*0.044)
				else return NULL 
				end
			end
		end
	end
end

hook.Add("ScalePlayerDamage","kenni_damage_combine", playerdamage_maggle)

function CombineAI_SMGGRENADE(data)
	if GetConVarNumber("kn_realistic_combine")==1 then 
		if GetConVarNumber("kn_realistic_combine_ai")==1 then
			if GetConVarNumber("kn_realistic_combine_smg_grenades")==1 then
				timer.Simple(0.5, function()
					if IsValid(data.Entity) and IsValid(data.Entity:GetEnemy()) then
						data.Entity:EmitSound("Weapon_SMG1.Double")--The smg grenade fire sound
						local grenade = ents.Create("grenade_ar2")-- the smg grenade entity
						grenade:SetAngles(data.Entity:GetAngles())
						grenade:SetVelocity((data.Entity:GetEnemy():GetPos()-data.Entity:GetPos()):Length() * 1.5 * data.Entity:GetAimVector() + data.Entity:GetEnemy():GetUp() * 50  )
						grenade:SetPos(data.Entity:GetShootPos() + data.Entity:GetUp()*-8.9 + data.Entity:GetForward()*8 + data.Entity:GetAimVector() * 10)
						grenade:Spawn()
						grenade:SetOwner(data.Entity)
					end
				end)
				return true
			end
		end
	end
end

hook.Add( "EntityEmitSound", "kenni_sound_maggle",function(data)--we use sound manipulation to make people think soldiers can actually use smg grenades
	local ar2_ball = {
	[Sound("Weapon_CombineGuard.Special1")] = true,-- the sound when you are about to fire an ar2 ball. We need to not call back this sound.
	}
	if ar2_ball[data.OriginalSoundName] == true and
	IsValid(data.Entity) and IsValid(data.Entity:GetActiveWeapon()) and 
	data.Entity:GetClass()=="npc_combine_s" and data.Entity:GetActiveWeapon():GetClass()=="weapon_smg1" then
		CombineAI_SMGGRENADE(data)
		return false
	end
end)
