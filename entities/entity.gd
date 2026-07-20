class_name Entity extends CharacterBody2D

##Esto seguramente cambiara dependiendo de las decisiones que tomemos asique no tomar muy enserio
@export var stat_manager: StatManager = null
#@export var weapon: Weapon = null
@export var items: Node = null
@export var ability: Node = null

var is_dead: bool = false

##Signals para cuando la entidad reciba danio tentativas
##signal damaged
##signal died

##func _ready() -> void:
	
