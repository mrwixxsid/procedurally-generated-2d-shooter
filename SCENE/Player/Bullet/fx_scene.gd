extends Node2D
@onready var anim: AnimatedSprite2D = $anim


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("explode")
	await get_tree().create_timer(0.46).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
