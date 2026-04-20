extends Area2D

@export var ammo_basic = 2

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Player_Data.ammo += ammo_basic
		queue_free()
		
