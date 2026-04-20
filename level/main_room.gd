extends Node

@onready var playe_scene = preload("res://SCENE/Player/player.tscn")
@onready var exit_scene = preload("res://SCENE/Interactable/exit.tscn")
@onready var slime = preload("res://Enemy/Slime/slime_enemy.tscn")

@onready var tilemap: TileMapLayer = $TileMap_WALL

@export var borders = Rect2(1,1,100,100)


var walker
var map

var ground_layer = 0


func _ready() -> void:
	randomize()
	generate_level()
	
	
func generate_level():
	
	walker = Walker_room.new(Vector2(13,8), borders)
	map = walker.walk(300)
	
	var using_cells: Array[Vector2i] = []
	print(using_cells.size())
	var all_cells: Array = tilemap.get_used_cells()
	
	tilemap.clear()
	walker.queue_free()
	
	for tile in all_cells:
		if !map.has(Vector2(tile.x, tile.y)):
			using_cells.append(tile)
			
	tilemap.set_cells_terrain_connect(using_cells,0,0)
	#tilemap.set_cells_terrain_path(using_cells,0,0)
	instance_player()
	instance_exit()
	instance_slime()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("action"):
		get_tree().reload_current_scene()


func instance_player():
	var player = playe_scene.instantiate()
	add_child(player)
	player.position = map.pop_front() * 16

func instance_exit():
	var exit = exit_scene.instantiate()
	add_child(exit)
	
	exit.position = walker.get_end_room().position * 16

func instance_slime():
	for i in range(12):
		var slime_enemy = slime.instantiate()
		add_child(slime_enemy)
		slime_enemy.position = (map.pick_random() * borders.position) * 16
