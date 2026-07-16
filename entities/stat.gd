extends Resource
class_name Stat

# @class Stat
# @desc Helper class to set base values, multipliers, and the range of such values of an `Entity`

@export_group("Base Stat")
@export
var base: int = 0

@export_range(0, 1000, 1)
var BASE_MIN: int = 0

@export_range(0, 1000, 1)
var BASE_MAX: int = 0

@export_group("Multiplier Stat")
@export
var multiplier: float = 1

@export_range(0, 10, 0.1)
var MULTIPLIER_MIN: float = 0.1

@export_range(0, 10, 0.1)
var MULTIPLIER_MAX: float = 10

# @func add_base
# @desc adds `value` to `base`, clamped to `BASE_MIN` and `BASE_MAX`
# @attr value Must be > 0
func add_base(value: int) -> void:
	if (value <= 0): return
	base = clamp(base + value, BASE_MIN, BASE_MAX)

# @func remove_base
# @desc Removes `value` to `base`, clamped to `BASE_MIN` and `BASE_MAX`
# @attr value Must be > 0
func remove_base(value: int) -> void:
	if (value <= 0): return
	base = clamp(base - value, BASE_MIN, BASE_MAX)

# @func set_base
# @desc sets `base` to `value`, clamped to `BASE_MIN` and `BASE_MAX`
# @attr value Must be >= 0
func set_base(value: int) -> void:
	if (value < 0): return
	base = clamp(base + value, BASE_MIN, BASE_MAX)

# @func add_multiplier
# @desc adds `value` to `multiplier`, clamped to `MULTIPLIER_MIN` and `MULTIPLIER_MAX`
# @attr value Must be > 0
func add_multiplier(value: float) -> void:
	if (value <= 0): return
	multiplier = clamp(multiplier + value, MULTIPLIER_MIN, MULTIPLIER_MAX)

# @func remove_multiplier
# @desc Removes `value` to `multiplier`, clamped to `MULTIPLIER_MIN` and `MULTIPLIER_MAX`
# @attr value Must be > 0
func remove_multiplier(value: int) -> void:
	if (value <= 0): return
	multiplier = clamp(multiplier + value, MULTIPLIER_MIN, MULTIPLIER_MAX)

# @func set_multiplier
# @desc sets `multiplier` to `value`, clamped to `MULTIPLIER_MIN` and `MULTIPLIER_MAX`
# @attr value Must be >= 0
func set_multiplier(value: int) -> void:
	if (value < 0): return
	multiplier = clamp(multiplier + value, MULTIPLIER_MIN, MULTIPLIER_MAX)

# @func get_raw_value
# @return base * multiplier
func get_raw_value() -> float:
	return base * multiplier
