@abstract
class_name ItemData
extends Resource

## @class abstract ItemData
## @desc Contains the immutable data of an object and it's effects

## @attribute name
## @desc The name of the item to display in-game
var name: StringName = &"Item"

## @attribute texture
## @desc texture to display in-game
var texture: Texture2D

## @func abstract on_first_pickup
## @desc This function triggers when picking the `Item` instance up for the first time
@abstract
func on_first_pickup(context: ItemContext) -> void

## @func abstract on_equip
## @param holder Entity that holds this item
## @param current_count `Item's current count of this item
## @desc This function triggers every time a `Player` picks up this `Item`
@abstract
func on_equip(context: ItemContext) -> void

## @func abstract on_unequip
## @desc This function triggers when removing this `Item` instance
@abstract
func on_unequip(context: ItemContext) -> void

## @func abstract on_unequip
## @desc This function triggers on the `holder`'s `_process`
@abstract
func on_process(context: ItemContext) -> void
