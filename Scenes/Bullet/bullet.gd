extends Area2D

const SPEED = 750.0
var direction = Vector2.ZERO

func _process(delta):
	position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(20, direction)
		queue_free()
