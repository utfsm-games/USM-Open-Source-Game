class_name WeaponInstance extends RefCounted

var data: Weapon = null

var bonus_index: int = -1

var bonus_value: float = 0.0

func _init(weapon_data: Weapon) -> void:
	data = weapon_data
	_roll_bonus()

# @func: _roll_bonus
# @desc: Picks a random stat index and a value inside the weapon's range
# TODO: use the run's seeded RandomNumberGenerator once runs are reproducible
func _roll_bonus() -> void:
	if data == null or data.stat_bonus_max <= 0.0:
		return
			
	bonus_index = randi() % StatManager.new().get_as_array().size()
	bonus_value = randf_range(data.stat_bonus_min, data.stat_bonus_max)

# @func: apply_to
# @desc: Adds the rolled bonus to the holder's stat, when Equiped
func apply_to(holder: Entity) -> void:
	var stat: Stat = _get_stat(holder)
	if stat == null:
		return
	stat.add_multiplier(bonus_value)

# @func: remove_from
# @desc: Reverts the rolled bonus. Called by WeaponSlot on unequip
func remove_from(holder: Entity) -> void:
	var stat: Stat = _get_stat(holder)
	if stat == null:
		return
	stat.remove_multiplier(bonus_value)

# @func _get_stat
# @desc Resolves the rolled index to the holder's actual Stat
func _get_stat(holder: Entity) -> Stat:
	if bonus_index < 0 or holder == null or holder.stat_manager == null:
		return null
	return holder.stat_manager.get_as_array()[bonus_index]

# @func get_bonus_text
# @desc Text to show in-game
func get_bonus_text() -> String:
	if bonus_index < 0:
		return ""
	return "+%d%%" % roundi(bonus_value * 100.0)
