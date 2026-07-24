class_name Item
extends Node

# @class abstract Item
# @desc aimed to be the base of every Item

# @attribute holder
# @desc holder of this item
@onready
var holder: Entity = null

# @attribute was_equiped
# @desc checks if the item was already picked up by any `holder`
var was_equiped: bool = false

func _equip(holder: Entity) -> void:
	if not was_equiped:
		was_equiped = true
		on_first_pickup(holder)
	on_equip(holder)
	apply_effect(holder)

func _remove(holder: Entity) -> void:
	on_unequip(holder)

# @func virtual on_first_pickup
# @desc This function triggers when picking the `Item` instance up for the first time
func on_first_pickup(holder: Entity) -> void:
	pass

# @func virtual on_equip
# @desc This function triggers every time a `Player` picks up this `Item` instance
func on_equip(holder: Entity) -> void:
	pass

# @func virtual apply_effect
# @desc This function triggers immediatly after `on_equip`
func apply_effect(holder: Entity) -> void:
	pass

# @func virtual on_unequip
# @desc This function triggers when removing this `Item` instance
func on_unequip(holder: Entity) -> void:
	pass
