class_name ItemManager
extends Node

## @attr holder Holder of these items
@export var holder: Entity

## @attr items The `Item`s the Holder obtained though the `run`
var items: Dictionary[ItemData, ItemInstance] = {}

## @attr instances_on_process `ItemInstances` that need to execute their `on_process` method
var instances_on_process: Array[ItemInstance] = []

## @func add_item
## @param new_item Item to be `equiped`
## @desc adds an `ItemInstance` to the `items` Dictionary, creates a new instance if there is no matching data.
## @exception holder is `null`
func add_item(new_item: ItemData) -> void:
	assert(holder != null, "ItemManager needs a holder to add an item!")
	var instance: ItemInstance

	# Resolve instance
	if items.has(new_item):
		instance = items[new_item]
	else:
		instance = ItemInstance.new()
		instance.data = new_item
		items[new_item] = instance
		if instance.data.needs_process:
			instances_on_process.append(instance)
	
	instance._equip(holder)
	
## @func remove_item
## @param removed_item Item to be `unequiped`
## @desc removes count on `ItemInstance` to the `items` Dictionary
## @exception holder is `null` or `items` doesn't has an entry for `removed_item`
func remove_item(removed_item: ItemData) -> void:
	assert(holder != null, "ItemManager needs a holder to remove an item!")
	assert(items.has(removed_item), "ItemManager can't remove \"%s\" because it was never added to \"%s\"" % [removed_item.name, holder.display_name])

	var instance: ItemInstance = items[removed_item]
	instance._unequip()
	
## @func _process
## @param delta time since the last frame
## @desc executes the `on_process` of an `ItemData`
func _process(delta: float) -> void:
	for instance in instances_on_process:
		instance._process(delta)
