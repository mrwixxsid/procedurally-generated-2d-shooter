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



#
#extends Node
#class_name Walker_room
#
#const DIRECTION = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
#var position = Vector2.ZERO
#var direction = Vector2.RIGHT
#
#var borders = Rect2()
#var _step_history_set = {}
#var step_history = []
#
#var step_since_turn = 0
#var rooms = []
#var start_pos = Vector2.ZERO
#
## --- DUNGEON TWEAKS ---
#var min_room_size = 9   # 3x larger rooms
#var max_room_size = 10  # 3x larger rooms
#var max_steps_before_turn = 18  # Shorter hallways means the walker turns more often
#var room_chance = 0.35  # 75% chance to spawn a room when turning (more rooms total)
#var room_complexity_chance = 0.3 # 60% chance for massive rooms to be L-shaped or irregular
#
#func _init(starting_position, new_borders) -> void:
	#assert(new_borders.has_point(starting_position)) 
	#position = starting_position
	#start_pos = starting_position
	#_step_history_set[position] = true
	#borders = new_borders
#
#func walk(steps_count):
	#place_room(position)
	#
	#for i in steps_count:
		#if step_since_turn >= max_steps_before_turn:
			#change_direction()
			#
		#if take_step():
			#_step_history_set[position] = true
		#else:
			#change_direction()
			#
	#place_room(position)
			#
	#step_history = _step_history_set.keys()
	#return step_history
	#
#func take_step():
	#var target_position = position + direction
	#if borders.has_point(target_position):
		#step_since_turn += 1
		#position = target_position
		#return true
	#else:
		#return false
	#
#func change_direction():
	## Spawns rooms much more frequently now
	#if randf() < room_chance:
		#place_room(position)
		#
	#step_since_turn = 0
	#var directions = DIRECTION.duplicate()
	#
	#directions.erase(direction)
	#directions.shuffle()
	#direction = directions.pop_front()
	#
	#while not borders.has_point(position + direction):
		#direction = directions.pop_front()
		#
#func create_room(pos, size):
	#return {"position": pos, "size": size}
	#
#func place_room(pos):
	## Main massive room
	#var size = Vector2(randi() % (max_room_size - min_room_size + 1) + min_room_size, randi() % (max_room_size - min_room_size + 1) + min_room_size)
	#_carve_rect(pos, size)
	#
	## Add a secondary overlapping rectangle to make the giant rooms feel uniquely shaped
	#if randf() < room_complexity_chance:
		#var secondary_size = Vector2(randi() % (max_room_size - min_room_size + 1) + min_room_size, randi() % (max_room_size - min_room_size + 1) + min_room_size)
		#var offset = Vector2(randi() % 8 - 4, randi() % 8 - 4) 
		#_carve_rect(pos + offset, secondary_size)
#
	#rooms.append(create_room(pos, size))
#
## Helper function to stamp the room layout into the dictionary
#func _carve_rect(center_pos, size):
	#var top_left_corner = (center_pos - size / 2).floor()
	#
	#for y in size.y:
		#for x in size.x:
			#var new_step = top_left_corner + Vector2(x, y)
			#
			#if borders.has_point(new_step):
				## Smooth out the corners for a more organic cavern look
				#var is_corner = (x == 0 or x == size.x - 1) and (y == 0 or y == size.y - 1)
				#if is_corner and randf() < 0.2:
					#continue 
				#
				#_step_history_set[new_step] = true
#
#func get_end_room():
	#var end_room = rooms[0]
	#var max_distance = 0.0
	#
	#for room in rooms:
		#var distance = start_pos.distance_to(room.position)
		#if distance > max_distance:
			#max_distance = distance
			#end_room = room
			#
	#return end_room


extends Node
class_name Walker_room

const DIRECTION = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT

var borders = Rect2()
var _step_history_set = {}
var step_history = []

var step_since_turn = 0
var rooms = []
var start_pos = Vector2.ZERO

# --- BALANCED DUNGEON SETTINGS (SHOOTER FRIENDLY) ---
var min_room_size = 5
var max_room_size = 10

var max_steps_before_turn = 20
var room_chance = 0.35
var room_complexity_chance = 0.25

# --- NEW CONTROLS ---
var last_room_position = Vector2.ZERO
var min_room_distance = 12
var min_rooms_required = 8

# --- INIT ---
func _init(starting_position, new_borders) -> void:
	assert(new_borders.has_point(starting_position))
	position = starting_position
	start_pos = starting_position
	_step_history_set[position] = true
	borders = new_borders


# --- MAIN WALK ---
func walk(steps_count):
	place_room(position)

	for i in steps_count:
		if step_since_turn >= max_steps_before_turn:
			change_direction()

		if take_step():
			_step_history_set[position] = true
		else:
			change_direction()

	place_room(position)

	step_history = _step_history_set.keys()

	# --- ENSURE MINIMUM ROOMS ---
	while rooms.size() < min_rooms_required:
		var random_pos = step_history[randi() % step_history.size()]
		place_room(random_pos)

	return step_history


# --- STEP ---
func take_step():
	var target_position = position + direction

	if borders.has_point(target_position):
		step_since_turn += 1
		position = target_position
		return true

	return false


# --- SMART DIRECTION CHANGE ---
func change_direction():
	# Spawn room only sometimes
	if randf() < room_chance:
		place_room(position)

	step_since_turn = 0

	var directions = DIRECTION.duplicate()
	directions.erase(direction)
	directions.shuffle()

	for dir in directions:
		if borders.has_point(position + dir):
			direction = dir
			return


# --- ROOM CREATION ---
func create_room(pos, size):
	return {"position": pos, "size": size}


func place_room(pos):
	# --- DISTANCE CHECK ---
	if rooms.size() > 0:
		if last_room_position.distance_to(pos) < min_room_distance:
			return

	# --- RANDOM SIZE ---
	var size = Vector2(
		randi() % (max_room_size - min_room_size + 1) + min_room_size,
		randi() % (max_room_size - min_room_size + 1) + min_room_size
	)

	# --- OVERLAP CHECK ---
	if not is_area_free(pos, size):
		return

	# --- CARVE MAIN ROOM ---
	_carve_rect(pos, size)

	# --- OPTIONAL COMPLEX SHAPE ---
	if randf() < room_complexity_chance:
		var secondary_size = Vector2(
			randi() % (max_room_size - min_room_size + 1) + min_room_size,
			randi() % (max_room_size - min_room_size + 1) + min_room_size
		)

		var offset = Vector2(randi() % 6 - 3, randi() % 6 - 3)
		_carve_rect(pos + offset, secondary_size)

	rooms.append(create_room(pos, size))
	last_room_position = pos


# --- OVERLAP CONTROL ---
func is_area_free(center_pos, size):
	var top_left = (center_pos - size / 2).floor()
	var filled = 0

	for y in size.y:
		for x in size.x:
			var check = top_left + Vector2(x, y)
			if _step_history_set.has(check):
				filled += 1

	return filled < (size.x * size.y) * 0.2


# --- CARVE ---
func _carve_rect(center_pos, size):
	var top_left_corner = (center_pos - size / 2).floor()

	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)

			if borders.has_point(new_step):
				# Slight organic edges
				var is_corner = (x == 0 or x == size.x - 1) and (y == 0 or y == size.y - 1)
				if is_corner and randf() < 0.15:
					continue

				_step_history_set[new_step] = true


# --- END ROOM ---
func get_end_room():
	var end_room = rooms[0]
	var max_distance = 0.0

	for room in rooms:
		var distance = start_pos.distance_to(room.position)
		if distance > max_distance:
			max_distance = distance
			end_room = room

	return end_room
