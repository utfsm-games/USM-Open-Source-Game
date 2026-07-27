class_name Entity extends CharacterBody2D

##Esto seguramente cambiara dependiendo de las decisiones que tomemos asique no tomar muy enserio
@export var display_name: StringName = &"Entity"
@export var stat_manager: StatManager = null
#@export var weapon: Weapon = null
@onready var items: ItemManager = $ItemManager
@export var ability: Node = null

var is_dead: bool = false

##Signals para cuando la entidad reciba danio tentativas
##signal damaged
##signal died

##func _ready() -> void:
	

# @func: take_damage
# @desc: this is now for testing and well need a refactor soon
func take_damage(amount: float) -> void:
	if is_dead:
		return
	print("recibio %.1f danio" % amount)
