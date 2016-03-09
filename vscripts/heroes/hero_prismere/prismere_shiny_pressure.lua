

function CooldownStart(keys)


	local caster = keys.caster
	local ability = keys.ability
	local full_cooldown = ability:GetLevelSpecialValueFor("cooldown", (ability:GetLevel() - 1))

	ability:StartCooldown(full_cooldown)

	caster:RemoveModifierByName("modifier_shiny_pressure")

	Timers:CreateTimer(full_cooldown, function()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_shiny_pressure", {})
		end)

	ability:ApplyDataDrivenModifier(caster, caster, "modifier__shiny_pressure_knockback", {})
end



function Knockback(caster, ability)

	local caster_loc = caster:GetAbsOrigin() 
	local radius = ability:GetLevelSpecialValueFor("push_range", (ability:GetLevel() - 1))
	local speed_per_stack = ability:GetLevelSpecialValueFor("push_per_stack", (ability:GetLevel() - 1))

	local target_teams = ability:GetAbilityTargetTeam()
	local target_types = ability:GetAbilityTargetType()
	local target_flags = ability:GetAbilityTargetFlags()

	--Find all enemies in range
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, target_teams, target_types,  target_flags, FIND_ANY_ORDER, false) 

	--Do for all enemies in range
	for _,target in pairs(targets) do

		--Find all enemies with stacks
		if target:HasModifier("modifier__shiny_pressure_debuff") then
			local current_stack = target:GetModifierStackCount("modifier_shiny__pressure_debuff", ability)
			if current_stack > 0 then

				--Define other variables for the target
				local target_loc = target:GetAbsOrigin() 
				local speed = current_stack * speed_per_stack
				local direction = (target_loc - caster_loc)Normalized() 

				--Move the target
				local new_loc = target_loc + direction * speed
				target:SetAbsOrigin(GetGroundPosition(new_loc, target))
			end
		end
	end
end



function StackIncrease(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = "modifier__shiny_pressure_debuff"


	local current_stack = target:GetModifierStackCount( modifier, ability )
	if current_stack > 0 then
		ability:ApplyDataDrivenModifier( caster, target, modifier, {})
		target:SetModifierStackCount( modifier, ability , current_stack + 1)
	else
		ability:ApplyDataDrivenModifier( caster, target, modifier, {})
		target:SetModifierStackCount( modifier, ability, 1)
	end
end