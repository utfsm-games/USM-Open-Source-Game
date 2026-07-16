extends Node
class_name Damages

# @class Damages
# @desc This class is used to access the damage values of either the stats of a `Weapon` or the base / multiplier stats of an `Entity`, to get the *raw* damage use `Entity.get_damage()`

# @attribute base
# @key id: StringName
# @value value: float
# @desc contains the value of the damages, example: base["melee"] returns how much `melee` damage does
@export var base: Dictionary[StringName, float] = {
	"melee": 0,
	"range": 0,
	"magic": 0,
}

# @attribute multiplier
# @key id: StringName
# @value value: float
# @desc contains the value of the damages, example: multiplier["melee"] returns how much `melee` damage does
@export var multipliers: Dictionary[StringName, float] = {
	"melee": 1,
	"range": 1,
	"magic": 1,
}

# @func get_base
# @desc get the `base` damage type value
# @return 0 if `id` does not exists
func get_base(id: StringName) -> float:
	return base.get(id, 0)

# @func set_base
# @param `value` must be positive
# @desc Sets the `base` damage type to `value`
func set_base(id: StringName, value: float) -> void:
	if (value < 0): return
	return base.set(id, value)

# @func add_base
# @param `value` must be positive
# @desc adds `value` to the `base` damage type, if it doesn't exists, it sets it as `value`
func add_base(id: StringName, value: float) -> void:
	if (value < 0): return
	base.set(id, get(id) + value)

# @func remove_base
# @param `value` must be positive
# @desc removes `value` to the `base` damage type, if it doesn't exists do nothing
func remove_base(id: StringName, value: float) -> void:
	if (value < 0): return
	base.set(id, min(0, get(id) - value))

# @func get_multiplier
# @desc get the `multiplier` of a damage type
# @return 1 if `id` does not exists
func get_multiplier(id: StringName) -> float:
	return multipliers.get(id, 1)

# @func set_multiplier
# @param `value` must be positive
# @desc Sets the `multiplier` damage type to `value`
func set_multiplier(id: StringName, value: float) -> void:
	if (value < 0): return
	return multipliers.set(id, value)

# @func add_multiplier
# @param `value` must be positive
# @desc adds `value` to the `multiplier` damage type, if it doesn't exists, it sets it as `value`
func add_multiplier(id: StringName, value: float) -> void:
	if (value < 0): return
	multipliers.set(id, get(id) + value)

# @func remove_multiplier
# @param `value` must be positive
# @desc removes `value` to the `multiplier` damage type, if it doesn't exists do nothing
func remove_multiplier(id: StringName, value: float) -> void:
	if (value < 0): return
	multipliers.set(id, min(0, get(id) - value))

# @func get_raw_damage
# @param id of the damage type
func get_raw_damage(id: StringName) -> float:
	return get_base(id) * get_multiplier(id)
