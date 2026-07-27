class_name ItemInstance
extends RefCounted

## @class ItemInstance
## @desc Keeps the count of an Item of a holder, with the help of an ItemManager

## @attribute data
## @desc Item data
@export
var data: ItemData = null

var context: ItemContext = ItemContext.new()

## @func _equip
## @desc equips this item to `holder`
func _equip(holder: Entity) -> void:
	context.holder = holder
	if not context.was_equiped:
		context.was_equiped = true
		data.on_first_pickup(context)
	data.on_equip(context)

## @func _unequip
## @desc removes this item from `holder`
func _unequip() -> void:
	data.on_unequip(context)

## TODO: Should decide if we're gonna keep it
## @func _connect
## @desc removes this item from `holder`
func _connect() -> void:
	pass

func _needs_process() -> bool:
	return data.has_method("on_process")
