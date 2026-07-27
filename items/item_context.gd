class_name ItemContext
extends RefCounted

# @class ItemContext
# @desc Holds the mutable data of an Item

# @attribute holder
# @desc Entity that is holding this instance
var holder: Entity = null

# @attribute count
# @desc counts of this instance
var count: int = 0

# @attribute was_equiped
# @desc checks if this instance was already picked up by any `holder`
var was_equiped: bool = false

# @attribute delta
# @desc Delta time
var delta: float = 0
