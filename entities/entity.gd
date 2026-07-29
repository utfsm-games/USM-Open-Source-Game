class_name Entity extends CharacterBody2D

##Esto seguramente cambiara dependiendo de las decisiones que tomemos asique no tomar muy enserio
@export var display_name: StringName = &"Entity"
@export var stat_manager: StatManager = null

#@export var weapon: Weapon = null
@onready var damages: Damages = $Damages
@onready var items: ItemManager = $ItemManager
@export var ability: Node = null

var is_dead: bool = false

var health: float = 0.0

##Signals para cuando la entidad reciba danio tentativas
signal damaged(amount:float)
signal died

func _ready() -> void:
	if stat_manager != null and stat_manager.health_max_hearts != null:
		health = stat_manager.health_max_hearts.get_raw_value()

# @func: take_damage
# @desc: Rest health, emits damaged, and kills the entity if health reaches 0
func take_damage(amount: float) -> void:
	if is_dead or amount <= 0.0:
		return
	
	health = maxf(health - amount, 0.0)
	damaged.emit(amount)
	print("recibio %.1f danio" % amount)
	
	if health <= 0.0:
		_die()

# @func: _die
# @desc: Makes the entity dead emits die and removes it from the scene
func _die() -> void:
	is_dead = true
	died.emit() #for future implementation
	print("%s murio" % display_name)
	queue_free()
