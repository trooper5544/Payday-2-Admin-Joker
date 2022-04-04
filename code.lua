local orginalConvert = orginalConvert or CopDamage.convert_to_criminal
function CopDamage:convert_to_criminal(health_multiplier)
orginalConvert (self, health_multiplier)
self:set_immortal(true)
end

if not _upgradeValueIntimidate then _upgradeValueIntimidate = PlayerManager.upgrade_value end 
function PlayerManager:upgrade_value( category, upgrade, default ) 
	if category == "player" and upgrade == "convert_enemies" then
		return true
	elseif category == "player" and upgrade == "convert_enemies_max_minions" then
		return 2
	elseif category == "player" and upgrade == "convert_enemies_damage_multiplier" then
		return 11
	else 
		return _upgradeValueIntimidate(self, category, upgrade, default) 
	end 
end

-- Setup a proper sniper-rifle for snipers (100% accuracy, no spread)
CopBrain._logic_variants.sniper = clone( CopBrain._logic_variants.security )
CopBrain._logic_variants.sniper.attack = CopLogicSniper
if not _onSniperEnter then _onSniperEnter = CopLogicSniper.enter end
function CopLogicSniper.enter( data, new_logic_name, enter_params )
	if data.unit:brain()._logic_data and data.unit:brain()._logic_data.objective and data.unit:brain()._logic_data.objective.type == "follow" then
		data.char_tweak.weapon[ data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage ] = tweak_data.character.presets.weapon.sniper.m4
		data.char_tweak.weapon[ data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage ].spread = 0
		-- Get dat 100% accuracy
		for distance=1, 3 do
			for interpolate=1,2 do
				data.char_tweak.weapon[ data.unit:inventory():equipped_unit():base():weapon_tweak_data().usage ].FALLOFF[distance].acc[interpolate] = 1
			end
		end
	end
	_onSniperEnter(data, new_logic_name, enter_params)
end
