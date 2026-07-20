class_name Item
extends Node

# @class abstract Item
# @desc aimed to be the base of every Item

# @attribute owner
# @desc owner of this item
@onready
var owner: Entity = null

# @attribute was_equiped
# @desc checks if the item was already picked up by any `owner`
var was_equiped: bool = false

func _equip(owner: Entity) -> void:
	if not was_equiped:
		was_equiped = true
		on_first_pickup(owner)
	on_equip(owner)
	apply_effect(owner)

func _remove(owner: Entity) -> void:
	on_unequip(owner)

# @func virtual on_first_pickup
# @desc This function triggers when picking the `Item` instance up for the first time
func on_first_pickup(owner: Entity) -> void:
	pass

# @func virtual on_equip
# @desc This function triggers every time a `Player` picks up this `Item` instance
func on_equip(owner: Entity) -> void:
	pass

# @func virtual apply_effect
# @desc This function triggers immediatly after `on_equip`
func apply_effect(owner: Entity) -> void:
	pass

# @func virtual on_unequip
# @desc This function triggers when removing this `Item` instance
func on_unequip(owner: Entity) -> void:
	pass
