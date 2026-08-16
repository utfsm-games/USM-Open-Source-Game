class_name PlayerController extends Node

@onready var entity: Entity = get_parent() as Entity
@onready var weapon_slot: WeaponSlot = entity.get_node_or_null("WeaponSlot")

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var to_mouse := entity.get_global_mouse_position() - entity.global_position

	_handle_defenses(dir, to_mouse)
	if entity.defenses.blocks_actions():
		return
	_handle_attack(to_mouse)
	_handle_movement(dir)

# @func: _handle_defenses 
# @desc: Handles the dodge and parry inputs
func _handle_defenses(dir: Vector2, to_mouse: Vector2) -> void:
	if Input.is_action_just_pressed("dodge") and dir != Vector2.ZERO:
		entity.defenses.start_dodge(dir)
	if Input.is_action_just_pressed("parry"):
		entity.defenses.start_parry(to_mouse)

# @func: _handle_attack
# @desc: Handles the attack and habilities inputs
func _handle_attack(to_mouse: Vector2) -> void:
	if Input.is_action_just_pressed("attack") and weapon_slot != null and weapon_slot.can_attack():
		weapon_slot.attack(to_mouse)

# @func: _handle_movement
# @desc: Handles the players movement inputs ( w = up, s = down, d = right, a = left)
func _handle_movement(dir: Vector2) -> void:
	var stat := entity.stat_manager.movement_speed
	entity.velocity = dir * (stat.get_raw_value() if stat != null else 0.0)
	entity.move_and_slide()
