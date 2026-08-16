class_name Defenses extends Node

enum Result { NONE, DODGED, PERFECT_DODGE, PARRIED }

signal parried
signal dodged(perfect: bool)

@onready var entity: Entity = get_parent() as Entity
@onready var _parry_hitbox: Area2D = entity.get_node_or_null("ParryHitbox")

const dodge_speed: float = 1500.0
const dodge_brake: float = 0.75
const dodge_stopping_frames: int = 5

var dodge_frames_left: int = 0

var parry_frames_left: int = 0
var invuln_frames_left: int = 0
var perfect_frames_left: int = 0

func _physics_process(_delta: float) -> void:
	parry_frames_left = maxi(parry_frames_left - 1, 0)
	invuln_frames_left = maxi(invuln_frames_left - 1, 0)
	perfect_frames_left = maxi(perfect_frames_left - 1, 0)

	if _parry_hitbox != null and parry_frames_left == 0 and _parry_hitbox.monitoring:
		_parry_hitbox.monitoring = false

	if dodge_frames_left > 0:
		dodge_frames_left -= 1
		entity.move_and_slide()
		if dodge_frames_left < dodge_stopping_frames:
			entity.velocity *= dodge_brake
		if dodge_frames_left == 0:
			entity.velocity = Vector2.ZERO

# @func: start_parry
# @desc: Opens the parry window and aims the ParryHitbox toward direction.
func start_parry(direction: Vector2) -> void:
	if is_defending():
		return
		
	if _parry_hitbox != null:
		_parry_hitbox.rotation = direction.angle()
		_parry_hitbox.monitoring = true
	parry_frames_left = _stat_frames(entity.stat_manager.parry_frames)

# @func: start_dodge
# @desc: Flat-speed dash that scales with the dodge stats. The first dodge_perfect_frames count as perfect.
func start_dodge(direction: Vector2) -> void:
	if is_defending():
		return

	var perfect := _stat_frames(entity.stat_manager.dodge_perfect_frames)
	var invuln := _stat_frames(entity.stat_manager.dodge_invulnerability_frames)

	if perfect + invuln <= 0:
		return

	entity.velocity = direction.normalized() * dodge_speed
	dodge_frames_left = perfect + invuln + dodge_stopping_frames
	perfect_frames_left = perfect
	invuln_frames_left = perfect + invuln

func is_defending() -> bool:
	return parry_frames_left > 0 or invuln_frames_left > 0

func is_dodging() -> bool:
	return dodge_frames_left > 0

# @func: blocks_actions
# @desc: True while the entity can't act (parry window, i-frames, or mid-dash).
func blocks_actions() -> bool:
	return is_defending() or is_dodging()

# @func: intercept
# @desc: Called by Entity.take_damage. source is the attack that hit us.
func intercept(source: WeaponBehavior = null) -> Result:
	if parry_frames_left > 0 and _parry_covers(source):
		parry_frames_left = 0
		if _parry_hitbox != null:
			_parry_hitbox.monitoring = false
		invuln_frames_left = _stat_frames(entity.stat_manager.parry_invulnerability_frames)
		parried.emit()
		return Result.PARRIED

	if invuln_frames_left > 0:
		var perfect := perfect_frames_left > 0
		dodged.emit(perfect)
		return Result.PERFECT_DODGE if perfect else Result.DODGED

	return Result.NONE

# @func: _parry_covers
# @desc: Did the attack's HitBox enter our ParryHitbox?
func _parry_covers(source: WeaponBehavior) -> bool:
	if source == null or _parry_hitbox == null:
		return true
	var attack_hitbox: Area2D = source.get_node("HitBox")
	return _parry_hitbox.overlaps_area(attack_hitbox)

# @func: _stat_frames
# @desc: Converts stats in a frame count
func _stat_frames(stat: Stat) -> int:
	if stat == null:
		return 0
	return maxi(int(stat.get_raw_value()), 0)
