class_name Rage extends Node

signal rage_started
signal rage_ended

@onready var entity: Entity = get_parent() as Entity
@onready var defenses: Defenses = entity.get_node_or_null("Defenses") as Defenses

const rage_meter_max: float = 100.0

var rage_meter: float = 0.0

var active: bool = false

func _ready() -> void:
	if defenses == null:
		return
	defenses.parried.connect(on_parried)
	defenses.dodged.connect(on_dodged)

func _process(delta: float) -> void:
	if not active:
		return

	rage_meter = maxf(rage_meter - _drain_per_second() * delta, 0.0)

	if rage_meter == 0.0:
		active = false
		rage_ended.emit()

# @func: add_points
# @desc: Add points to the rage "meter"
func add_points(points: float) -> void:
	if points <= 0.0 or entity.is_dead or entity.stat_manager == null:
		return

	if _stat(entity.stat_manager.rage_max_seconds) <= 0.0:
		return

	rage_meter = minf(rage_meter + points, rage_meter_max)

	if not active and rage_meter == rage_meter_max:
		active = true
		rage_started.emit()

# @func: on_kill
# @desc: called by WeaponBehavior when entity kills someone(while on rage 
func on_kill() -> void:
	if is_active():
		add_points(_stat(entity.stat_manager.rage_bonus_on_kill))
		return
		
	add_points(_stat(entity.stat_manager.rage_when_killed))

func is_active() -> bool:
	return active

# @func: get_damage_multiplier
# @desc: readed by WeaponSlot at calculating damage so if rage is active adds multiplier
func get_damage_multiplier() -> float:
	if not is_active():
		return 1.0
	return 1.0 + _stat(entity.stat_manager.rage_damage_bonus)

func _drain_per_second() -> float:
	return rage_meter_max / _stat(entity.stat_manager.rage_max_seconds)

# @func: on_parried
# @desc: 
func on_parried() -> void:
	add_points(_stat(entity.stat_manager.rage_per_parry))

func on_dodged(perfect: bool) -> void:
	if perfect:
		add_points(_stat(entity.stat_manager.rage_per_dodge))

func _stat(stat: Stat) -> float:
	if stat == null:
		return 0.0
	return maxf(stat.get_raw_value(), 0.0)
