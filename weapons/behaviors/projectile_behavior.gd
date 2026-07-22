class_name ProjectileBehavior extends WeaponBehavior

var _speed: float
var _lifetime: float

func _on_setup() -> void:
		_speed = get_param(&"speed", 400.0)
		_lifetime = get_param(&"lifetime", 2.0)
		top_level = true  #let the proyectile be free
		global_position = attacker.global_position
		rotation = direction.angle()

func _process(delta: float) -> void:
		position += direction * _speed * delta
		_lifetime -= delta
		if _lifetime <= 0.0:
			queue_free()

# @func: _on_hit_box_body_entered
# @desc: Hits the first entity the projectile touches, ignoring the attacker, this is a Signal!
func _on_hit_box_body_entered(body: Node2D) -> void:
		var entity := body as Entity
		if entity == null or entity == attacker:
			return
		apply_hit(entity)
		queue_free()
