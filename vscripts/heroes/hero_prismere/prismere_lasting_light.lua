


function DoDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dmg = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
	local think = ability:GetLevelSpecialValueFor("think_interval", (ability:GetLevel() - 1))
	local max_range = ability:GetLevelSpecialValueFor("break_range", (ability:GetLevel() - 1))
	local dmg_per_second = dmg * think
	local dmg_Table = {attacker = caster, victim = target, damage = dmg_per_second, damage_type = DAMAGE_TYPE_PURE}
	ApplyDamage(dmg_Table)

	local target_point = target:GetAbsOrigin()
	local caster_location = caster:GetAbsOrigin()
	local distance = (caster_location - target_point):Length2D() 
	if distance > max_range then
		caster:RemoveModifierByName("modifier_lasting_light_self")
		target:RemoveModifierByName("modifier_lasting_light_debuff")
	elseif not caster:IsAlive() or not target:IsAlive() then
		caster:RemoveModifierByName("modifier_lasting_light_self")
		target:RemoveModifierByName("modifier_lasting_light_debuff")
	end
end