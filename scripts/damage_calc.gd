extends Node
class_name DamageCalculator
## Zentrale Schadensberechnung

# FINAL DAMAGE = Base × Multiplier × Crit × Resistance + Bonus

static func calculate(base_damage: float, attacker_data: Dictionary, target_data: Dictionary, element: String = "physical") -> int:
	var multiplier: float = attacker_data.get("damage_multiplier", 1.0)
	var crit_chance: float = attacker_data.get("crit_chance", 0.05)
	var crit_mult: float = attacker_data.get("crit_multiplier", 1.5)
	var bonus: float = attacker_data.get("bonus_damage", 0.0)
	
	# Crit?
	var is_crit := randf() < crit_chance
	var crit := crit_mult if is_crit else 1.0
	
	# Resistance
	var resist: float = target_data.get("resistances", {}).get(element, 0.0)
	var resist_mod := 1.0 - resist
	
	# Final Damage
	var final_damage: float = base_damage * multiplier * crit * resist_mod + bonus
	
	return max(1, int(final_damage))
