## Pure data of a Weapon
extends Resource 
class_name Weapon

# @desc: Unique identifier
# @example: "long_sword"
@export var id: StringName

# @desc: Name showed to the player
@export var display_name: String = ""

# @desc: Sprite shown in the entity's hands while equipped
# this might need a refactor if we want animated weapon sprites but for now this will do i guess
@export var sprite: Texture2D

# @desc: Witch damage stat this weapon scales with 
# Must be one of the [Damages] keys: "melee" , "range" , "magic"
@export var damage_type: StringName = &"melee"

# @desc: Base weapon damage before applying Entity's damage modifiers 
@export var damage_base: float = 1.0

# @desc: Knockback applied to Entity's when damaged
@export var knockback: float = 1.0

# @desc: Minimum time betwen attacks, in seconds
@export var attack_cooldown_seconds: float = 0.5

# @desc: Instanced on each attack (swing, projectile, spell , etc)
@export var behavior_scene: PackedScene

# @desc: Each behaivor document its accepted keys and provides defaults for missing ones.
# @example: proyectile{ "speed": 400.0, "lifetime": 2.0 }
@export var behavior_params: Dictionary[StringName, Variant] = {}
