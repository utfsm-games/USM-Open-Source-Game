class_name WeaponSlot extends Node2D

# @desc: The equipped weapon with its rolled bonus. Null when unarmed
var instance: WeaponInstance = null

# @desc: The entity(player, enemy) holding the weapon. Must be a required child of an entity
@onready var holder: Entity = get_parent() as Entity

@onready var _held_sprite: Sprite2D = $HeldSprite

var _cooldown_remaining: float = 0.0

func _process(delta: float) -> void:
	_cooldown_remaining = maxf(_cooldown_remaining - delta, 0.0)

# @func: equip
# @desc: Equips aa weapon instance and applies its bonus to the holder.
func equip(new_instance: WeaponInstance) -> WeaponInstance:
	var previous: WeaponInstance = unequip()
	instance = new_instance
	if instance != null:
		instance.apply_to(holder)
		_held_sprite.texture = instance.data.sprite
	return previous

# @func: unequip
# @desc: Removes the current weapon and reverts its bonus
func unequip() -> WeaponInstance:
	var previous: WeaponInstance = instance
	if previous != null:
		previous.remove_from(holder)
	instance = null
	_held_sprite.texture = null
	return previous

# @func: can_attack
# @desc: True if a weapon is equipped, has a behavior_scene and the cooldown is over
func can_attack() -> bool:
	return instance != null and instance.data.behavior_scene != null and _cooldown_remaining == 0.0

# @func: attack
# @desc: Spawns the weapon's behavior aimed at the direction and starts the cooldown
func attack(direction: Vector2) -> void:
	if not can_attack():
		return

	var weapon: Weapon = instance.data
	_cooldown_remaining = weapon.attack_cooldown_seconds
	var behavior: WeaponBehavior = weapon.behavior_scene.instantiate()
	add_child(behavior)
	behavior._setup(holder, weapon, _calculate_damage(), direction)

func _calculate_damage() -> float:
	#Figure out entitys grabber for dealing damage
	return instance.data.damage_base
