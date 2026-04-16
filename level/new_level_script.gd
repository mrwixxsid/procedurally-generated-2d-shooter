#extends Node
#
#class_name Walker_room
#
#const DIRECTION = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
#var position = Vector2.ZERO
#var direction = Vector2.RIGHT
#
#var borders = Rect2()
#var step_history = []
#
#var step_since_turn = 0
#var rooms = []
#
#
#func _init(starting_position, new_borders) -> void:
	#assert(new_borders.has_point(starting_position)) 
	#position = starting_position
	#step_history.append(position)
	#borders = new_borders
	#
#
#func walk(steps):
	#
	#place_room(position )
	#
	#for step in steps:
		#if step_since_turn >= 7.5:
			#change_direction()
		#if step():
			#step_history.append(position)
		#else:
			#change_direction()
	#return step_history
	#
#func step():
	#var target_position = position + direction
	#if borders.has_point(target_position):
		#step_since_turn += 1
		#position = target_position
		#return true
	#else:
		#return false
	#
#func change_direction():
	#place_room(position)
	#step_since_turn = 0
	#var directions = DIRECTION.duplicate()
	#
	#directions.erase(direction)
	#directions.shuffle()
	#
	#direction = directions.pop_front()
	#
	#while not borders.has_point(position + direction):
		#direction = directions.pop_front()
		#
		#
#func create_room(position, size):
	#return {position = position, size = size}
	#
#func place_room(position):
	#var size = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	#var top_left_corner = (position - size / 2).floor()
	#
	#rooms.append(create_room(position, size))
	#
	#for y in size.y:
		#for x in size.x:
			#var new_step = top_left_corner + Vector2(x,y)
			#
			#if borders.has_point(new_step):
				#step_history.append(new_step)
#
#
#
#
#func get_end_room():
	#var end_room = rooms.pop_back()
	#var starting_position = step_history.front()
	#
	#for room in rooms:
		#if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
			#end_room = room
	#return end_room




extends Node
class_name Walker_room

const DIRECTION = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
var position = Vector2.ZERO
var direction = Vector2.RIGHT

var borders = Rect2()

# OPTIMIZATION: We use a Dictionary as a "Set" to prevent duplicate tiles.
# Arrays get very slow when appending thousands of overlapping tiles.
var _step_history_set = {} 
var step_history = [] 

var step_since_turn = 0
var rooms = []
var start_pos = Vector2.ZERO

# --- TWEAKABLE PARAMETERS ---
var min_room_size = 4
var max_room_size = 10
var turn_chance = 0.2 # 20% chance to turn early
var max_steps_before_turn = 8
var room_complexity_chance = 0.6 # 60% chance to generate complex/L-shaped rooms

func _init(starting_position, new_borders) -> void:
	assert(new_borders.has_point(starting_position)) 
	position = starting_position
	start_pos = starting_position
	_step_history_set[position] = true
	borders = new_borders

func walk(steps_count):
	place_room(position)
	
	# BUG FIX: Changed variable from 'step' to 'i'. 
	# Having a variable named 'step' and a function named 'step()' causes severe collisions.
	for i in steps_count:
		# Added a random turn chance to make hallways less strictly straight
		if step_since_turn >= max_steps_before_turn or randf() < turn_chance:
			change_direction()
			
		if take_step():
			_step_history_set[position] = true
		else:
			change_direction()
			
	# Convert our optimized Dictionary back into the Array your other scripts expect
	step_history = _step_history_set.keys()
	return step_history
	
# Renamed from step() to avoid variable name collision
func take_step():
	var target_position = position + direction
	if borders.has_point(target_position):
		step_since_turn += 1
		position = target_position
		return true
	else:
		return false
	
func change_direction():
	place_room(position)
	step_since_turn = 0
	var directions = DIRECTION.duplicate()
	
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	
	while not borders.has_point(position + direction):
		direction = directions.pop_front()
		
func create_room(pos, size):
	return {"position": pos, "size": size}
	
func place_room(pos):
	# Base room generation
	var size = Vector2(randi() % (max_room_size - min_room_size) + min_room_size, randi() % (max_room_size - min_room_size) + min_room_size)
	_carve_rect(pos, size)
	
	# COMPLEXITY UPGRADE: Chance to combine a second rectangle to make L-shapes, T-shapes, or irregular rooms
	if randf() < room_complexity_chance:
		var secondary_size = Vector2(randi() % (max_room_size - min_room_size) + min_room_size, randi() % (max_room_size - min_room_size) + min_room_size)
		# Shift the second rectangle slightly off-center
		var offset = Vector2(randi() % 5 - 2, randi() % 5 - 2) 
		_carve_rect(pos + offset, secondary_size)

	rooms.append(create_room(pos, size))

# Helper function to process the math of laying down the room tiles
func _carve_rect(center_pos, size):
	var top_left_corner = (center_pos - size / 2).floor()
	
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			
			if borders.has_point(new_step):
				# COMPLEXITY UPGRADE: 10% chance to skip corners to create rounded/organic looking rooms
				var is_corner = (x == 0 or x == size.x - 1) and (y == 0 or y == size.y - 1)
				if is_corner and randf() < 0.1:
					continue 
				
				_step_history_set[new_step] = true

func get_end_room():
	# BUG FIX: Instead of popping the back (which deletes it from the array), we just read it.
	var end_room = rooms[0]
	var max_distance = 0.0
	
	for room in rooms:
		var distance = start_pos.distance_to(room.position)
		if distance > max_distance:
			max_distance = distance
			end_room = room
			
	return end_room
