extends CharacterBody2D

@onready var fx_scene = preload("res://SCENE/Player/Bullet/fx_scene.tscn")
@onready var ammo_basic = preload("res://SCENE/Interactable/DROP_OFF/ammo_basic.tscn")
@onready var timer: Timer = $Timer
@onready var anim: AnimatedSprite2D = $AnimatedSprite
@export var speed = 20

enum  enemy_direction { RIGHT, LEFT, UP, DOWN}

var new_direction = enemy_direction.RIGHT
var change_direction

func _ready() -> void:
	choose_direction()


func _process(delta: float) -> void:
	match new_direction:
		enemy_direction.RIGHT:
			move_right()
		enemy_direction.LEFT:
			move_left()
		enemy_direction.UP:
			move_up()
		enemy_direction.DOWN:
			move_down()

func move_right():
	velocity = Vector2.RIGHT * speed
	anim.flip_h = true
	anim.play("run")
	move_and_slide()
	
func move_left():
	velocity = Vector2.LEFT * speed
	anim.flip_h = false
	anim.play("run")
	move_and_slide()
	
func move_up():
	velocity = Vector2.UP * speed
	anim.flip_h = false
	anim.play("run_up")
	move_and_slide()
	
func move_down():
	velocity = Vector2.DOWN * speed
	anim.flip_h = true
	anim.play("run_down")
	move_and_slide()


func choose_direction():
	change_direction = randi() % 4
	random_direction()
	
func random_direction():
	match change_direction:
		0:
			new_direction = enemy_direction.RIGHT
		1:
			new_direction = enemy_direction.LEFT
		2:
			new_direction = enemy_direction.UP
		3:
			new_direction = enemy_direction.DOWN

func _on_timer_timeout() -> void:
	choose_direction()
	timer.start()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("BULLET"):
		#instance_fx_scene()
		queue_free()
		drop_off_ammo()

func instance_fx_scene():
	var fx = fx_scene.instantiate()
	fx.global_position = global_position
	get_tree().root.add_child(fx)

func drop_off_ammo():
	var ammo = ammo_basic.instantiate()
	ammo.global_position = global_position
	get_tree().root.add_child(ammo)
