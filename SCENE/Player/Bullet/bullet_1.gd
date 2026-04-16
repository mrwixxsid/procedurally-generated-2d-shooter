extends Area2D



@export var speed: float = 600.0 # Adjust this value to your liking
var direction: Vector2 = Vector2.ZERO

#var direction = Vector2.RIGHT


func _process(delta: float) -> void:
	#translate(direction * speed * delta)
	global_position += direction * speed * delta




func _on_body_entered(body: Node2D) -> void:
	queue_free()


func _on_visible_on_screen_screen_exited() -> void:
	queue_free()
