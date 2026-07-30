# Base class for all weapon behavior scenes.
class_name WeaponBehavior extends Node2D

# The entity that performed the attack.
var attacker: Entity

# The weapon wich this attack came from.
var weapon: Weapon

# Final damage, already calculated by WeaponSlot
var damage: float

# Normalized aim direction of the attack.
var direction: Vector2

# @func: _setup
# @desc: Called by WeaponSlot right after instancing
func _setup(attacking_entity: Entity, source_weapon: Weapon, calculated_damage: float, aimed_direction: Vector2) -> void:
	attacker = attacking_entity
	weapon = source_weapon
	damage = calculated_damage
	direction = aimed_direction.normalized()
	#override set up
	_on_setup()

func _on_setup() -> void:
	pass

# @func: get_param
# @desc: Reads param key from the weapon's Weapon.behaivor_params
func get_param(key: StringName, default: Variant) -> Variant:
	return weapon.behavior_params.get(key, default)

# @func: apply_hit
# @desc: Applies damage and knockback to target. (Called by behaivor scenes on hit)
func apply_hit(target: Entity) -> void:
		
		if target == null or target.is_dead: 
			return
		
		target.take_damage(damage)  ##Integrate on entity 
		if weapon.knockback > 0.0:
			target.velocity += direction * weapon.knockback
