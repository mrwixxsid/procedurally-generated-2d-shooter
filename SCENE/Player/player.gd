extends CharacterBody2D

var current_state = player_state.MOVE
enum player_state {MOVE, DEAD}
var is_dead = false


@onready var bullet_scene = preload("res://SCENE/Player/Bullet/bullet_1.tscn")
@onready var scent_trail = preload("res://SCENE/Player/scent_trail/scent_trail.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: Area2D = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var SPEED = 150.0

@onready var gun_handler: Node2D = $gun_handler
@onready var gun_sprite: Sprite2D = $gun_handler/gun_sprite
@onready var bullet_point: Marker2D = $gun_handler/bullet_point



var pos           #position 
var rot           #Rotation


var input_movement = Vector2.ZERO


func _physics_process(delta: float) -> void:
	
	if Player_Data.health <= 0:
		current_state = player_state.DEAD
	target_mouse()
	match current_state:
		player_state.MOVE:
			player_movement(delta)
		player_state.DEAD:
			dead()
	
	

func player_movement(delta):
	play_animation()
	
	input_movement = Input.get_vector("left","right","up","down")
	
	if Input.is_action_just_pressed("shoot") && Player_Data.ammo > 0:
		Player_Data.ammo -= 1
		instantiate_bullet()
	if input_movement != Vector2.ZERO:
		velocity = input_movement * SPEED
		
	elif input_movement == Vector2.ZERO:
		velocity = Vector2.ZERO
		
	move_and_slide()


#func play_animation():
	#if input_movement != Vector2.ZERO:
		#if input_movement.x > 0:
			#animation_player.play("move")
			##sprite.flip_h = false
		#if input_movement.x < 0:
			##sprite.flip_h = true
			#animation_player.play("move")
		#if input_movement.y < 0:
			#animation_player.play("move")
		#if input_movement.y < 0:
			#animation_player.play("move")
	#elif input_movement == Vector2.ZERO:
		#animation_player.play("idle")

func play_animation():
	# If we are moving Left OR Right OR Up OR Down...
	if input_movement.x != 0 or input_movement.y != 0:
		animation_player.play("move")
		
		# Handle the "Looking Left/Right" part
		#if input_movement.x < 0:
			#sprite.flip_dd  h = true
		#elif input_movement.x > 0:
			#sprite.flip_h = false
	else:
		# If none of the above are true, we must be standing still
		animation_player.play("idle")

func dead():
	is_dead = true
	velocity = Vector2.ZERO
	gun_handler.visible = false
	animation_player.play("dead")
	await get_tree().create_timer(2).timeout
	if get_tree():
		get_tree().reload_current_scene()
		Player_Data.health += 4
		is_dead = false



func target_mouse():
	var mouse_movement = get_global_mouse_position()
	pos = global_position
	gun_handler.look_at(mouse_movement)
	rot = rad_to_deg((mouse_movement - pos).angle())
	
	if  rot >= -90 and rot <= 90:
		gun_sprite.flip_v = false
		$Sprite2D.flip_h = false
	else:
		gun_sprite.flip_v = true
		$Sprite2D.flip_h = true


#func instantiate_bullet():
	#var bullet = bullet_scene.instantiate()
	#bullet.direction = bullet_point.global_position - global_position
	#bullet.global_position = bullet_point.global_position
	#get_tree().root.add_child(bullet)
	
	
# By Gemini
func instantiate_bullet():
	
	# Remove bullets from player inventory
	var bullet = bullet_scene.instantiate()
	# In 2D, the 'X' axis (right) is usually 'forward'
	bullet.direction = Vector2.RIGHT.rotated(bullet_point.global_rotation)
	bullet.global_position = bullet_point.global_position
	get_tree().root.add_child(bullet)
	
	
#func instantiate_bullet():
	#var bullet = bullet_scene.instantiate()
	#
	## Calculate the normalized direction (length of 1)
	#var dir = bullet_point.global_position - global_position
	#bullet.direction = dir.normalized()
	#
	#bullet.global_position = bullet_point.global_position
	#get_tree().root.add_child(bullet)

#reset animation - dead to move
func reset_state():
	current_state = player_state.MOVE


func instance_trail_scent():
	var player_cent = scent_trail.instantiate()
	player_cent.global_position = global_position
	get_tree().root.add_child(player_cent)


func _on_timer_timeout() -> void:
	instance_trail_scent()
	$Timer.start()
