


function Projectile(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() -1
	local range = ability:GetLevelSpecialValueFor("range", ability_level)
	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()
	targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin() , nil, range, target_teams, target_types, target_flags, FIND_ANY_ORDER, false) 
	local prj_Table = {
						Source = caster,
						Ability = ability,
						EffectName = "particles/units/heroes/hero_tinker/tinker_laser_f.vpcf",
						vSourceLoc = caster:GetAbsOrigin(),
						bDrawsOnMinimap = false,
						bDodgeable = true,
						bIsAttack = false,
						bVisibleToEnemies = true, 
						bReplaceExisting = false,
						bProvidesVision = false,
						}
	for _,hero in pairs(targets) do
		if hero:IsHero() then
			local speed = ((caster:GetAbsOrigin() - hero:GetAbsOrigin()):Length2D()) * 10
			if speed > 1000 then
				speed = 1000
			end
			prj_Table.Target = hero
			prj_Table.iMoveSpeed = speed
			ProjectileManager:CreateTrackingProjectile(prj_Table)
			ability:ApplyDataDrivenModifier(caster, hero, "modifier_multi_strike_target", {Duration = 1})
		end
	end
end


function DoDamage(keys)
	local caster = keys.caster
	local ability =keys.ability
	local dmg_Table = {attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}
	for _,hero in pairs(targets) do
		damage = (ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1))) / #targets
		dmg_Table.victim = hero
		ApplyDamage(dmg_Table)
		hero:RemoveModifierByName("modifier_multi_strike_target")
	end

end