
--set up local arrays
local combats = {}
local area = {
	--area 1
	{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0},
	{0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0},
	{0, 0, 1, 0, 1, 2, 1, 0, 1, 0, 0},
	{0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0},
	{0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0}
}

for i = 1, #area do
	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
	combat:setArea(createCombatArea(area))

	function onGetFormulaValues(player, level, magicLevel)
		local min = (level / 5) + (magicLevel * 5.5) + 25
		local max = (level / 5) + (magicLevel * 11) + 50
		return -min, -max
	end	
	combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

	table.insert(combats, combat)
--End of Loop
end

function onCastSpell(creature, variant)

	-- Execute both combat areas simultaneously
    for i = 1, #area do
        combats[i]:execute(creature, variant)
    end

    return true

end