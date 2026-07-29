class_name MeleeSwingBehavior extends WeaponBehavior

var _duration: float

func _on_setup() -> void:
	_duration = get_param(&"duration", 0.15)
	position = direction * get_param(&"reach", 80.0)
	rotation = direction.angle()
	print("swing spawn: global=%s dur=%.2f" % [global_position, _duration])

func _process(delta: float) -> void:
	_duration -= delta
	if _duration <= 0.0:
		queue_free()

# @func: _on_hit_box_body_entered
# @desc: Hits every entity inside the swing while it lasts.
func _on_hit_box_body_entered(body: Node2D) -> void:
	print("swing toco: %s" % body.name)
	var entity := body as Entity
	if entity == null or entity == attacker:
		return
	apply_hit(entity)
