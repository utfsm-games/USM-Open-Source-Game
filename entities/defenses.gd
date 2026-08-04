class_name Defenses extends Node

enum Result { NONE, DODGED, PERFECT_DODGE, PARRIED }

signal parried
signal dodged(perfect: bool)

@onready var entity: Entity = get_parent() as Entity

var parry_frames_left: int = 0
var invuln_frames_left: int = 0
var perfect_frames_left: int = 0

func _physics_process(_delta: float) -> void:
	parry_frames_left = maxi(parry_frames_left - 1, 0)
	invuln_frames_left = maxi(invuln_frames_left - 1, 0)
	perfect_frames_left = maxi(perfect_frames_left - 1, 0)

# @func: start_parry
# @desc: Opens the parry window. Ignored if already parrying or dodging.
func start_parry() -> void:
	if is_defending():
		return
	parry_frames_left = _stat_frames(entity.stat_manager.parry_frames)

# @func: start_dodge
# @desc: Opens the dodge i-frames. The first dodge_perfect_frames count as perfect.
func start_dodge() -> void:
	if is_defending():
		return
	invuln_frames_left = _stat_frames(entity.stat_manager.dodge_invulnerability_frames)
	perfect_frames_left = _stat_frames(entity.stat_manager.dodge_perfect_frames)

func is_defending() -> bool:
	return parry_frames_left > 0 or invuln_frames_left > 0

# @func: intercept
# @desc: Called by Entity.take_damage before applying damage. Consumes the parry window on success and grants its i-frames.
func intercept() -> Result:
	if parry_frames_left > 0:
		parry_frames_left = 0
		invuln_frames_left = _stat_frames(entity.stat_manager.parry_invulnerability_frames)
		parried.emit()
		return Result.PARRIED
		
	if invuln_frames_left > 0:
		var perfect := perfect_frames_left > 0
		dodged.emit(perfect)
		return Result.PERFECT_DODGE if perfect else Result.DODGED
	
	return Result.NONE

func _stat_frames(stat: Stat) -> int:
	if stat == null:
		return 0
	return int(stat.get_raw_value())
