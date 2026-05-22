#extends Area2D
#
#@export var ammo_basic = 2
#
#func _on_body_entered(body: Node2D) -> void:
	#if body.name == "Player":
		#Player_Data.ammo += ammo_basic
		#queue_free()
		#
#
#
#func _on_timer_timeout() -> void:
	#pass # Replace with function body.

extends Area2D

@export var ammo_basic = 2
@onready var timer: Timer = $Timer

func _ready():
	# Ensure timer is configured (safe even if already set in editor)
	timer.wait_time = 10.0
	timer.one_shot = true
	timer.start()

	# Connect timeout signal (in case not connected in editor)
	timer.timeout.connect(_on_timer_timeout)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Player_Data.ammo += ammo_basic
		
		# Stop timer to avoid unnecessary signal
		if not timer.is_stopped():
			timer.stop()
			
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
