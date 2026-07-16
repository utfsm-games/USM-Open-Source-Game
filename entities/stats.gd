extends Resource
class_name Stats

# @class Stats
# @desc contains the general stats of an `Entity`, the current values are stored on the `Entity` itself

@export_group("Health & Movement")
@export
var health_max_hearts: Stat

@export
var movement_speed: Stat

@export_group("Parry")
@export
var parry_frames: Stat

@export
var parry_invulnerability_frames: Stat

@export_group("Dodge")
@export
var dodge_perfect_frames: Stat

@export
var dodge_invulnerability_frames: Stat

@export_group("Rage")
@export
var rage_max_seconds: Stat

@export
var rage_when_killed: Stat

@export
var rage_bonus_on_kill: Stat

@export
var rage_per_dodge: Stat

@export
var rage_per_parry: Stat
