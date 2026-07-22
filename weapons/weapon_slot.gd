class_name WeaponSlot extends Node2D

# @desc: The pure data of the equipped weapon
@export var weapon: Weapon = null: set = _set_weapon

# @desc: The entity(player, enemy) holding the weapon. Must be a required child of an entity
@onready var holder: Entity = get_parent() as Entity

@onready var _held_sprite: Sprite2D = $HeldSprite

var _cooldown_remaining: float = 0.0

func _ready() -> void:
	_set_weapon(weapon)

func _process(delta: float) -> void:
	_cooldown_remaining = maxf(_cooldown_remaining - delta, 0.0)

# @func: can_attack
# @desc: True if a weapon has a behavior_scene and cooldown is over
func can_attack() -> bool:
	if weapon != null and weapon.behavior_scene != null and _cooldown_remaining == 0:
		return true
	return false

# @func: attack
# @desc Spawns the weapon's behavior aimed at the direccion and starts the cooldown
func attack(direction: Vector2) -> void:
	if not can_attack(): 
		return
	
	_cooldown_remaining = weapon.attack_cooldown_seconds
	var  behavior: WeaponBehavior = weapon.behavior_scene.instantiate()
	add_child(behavior)
	behavior._setup(holder, weapon, _calculate_damage(), direction)
	
func _calculate_damage() -> float:
	#Figure out entitys grabber for dealing damage
	return weapon.damage_base

# @func: _set_weapon
# @desc: Swaps the equipped weapon and updates the sprites
func _set_weapon(value: Weapon) -> void:
	weapon = value
	if is_node_ready() and weapon != null:
		_held_sprite.texture = weapon.sprite 
