class_name ItemInstance
extends RefCounted

## @class ItemInstance
## @desc Manages the life cycle of an `Item` and has default behaviors

## @attribute data
## @desc Item data
@export
var data: ItemData = null

## @attribute context
## @desc keeps the data of the current `run`
var context: ItemContext = ItemContext.new()

## @func _equip
## @desc equips this item to `holder`
func _equip(holder: Entity) -> void:
	context.holder = holder
	context.count += 1
	if not context.was_equiped:
		context.was_equiped = true
		data.on_first_pickup(context)
	data.on_equip(context)

## @func _unequip
## @desc removes this item from `holder`
## @exception current count is <= 0
func _unequip() -> void:
	assert(context.count > 0, "ItemInstance tried to remove count from \"%s\"" % data.name)
	context.count -= 1
	data.on_unequip(context)

## TODO: Should decide if we're gonna keep it
## @func _connect
## @desc removes this item from `holder`
func _connect() -> void:
	pass

## @func _process
## @desc invokes the `ItemData`'s `on_process`. If `context.count` == 0 then it early returns
func _process(delta: float) -> void:
	if context.count == 0: return
	context.delta = delta
	data.on_process(context)
