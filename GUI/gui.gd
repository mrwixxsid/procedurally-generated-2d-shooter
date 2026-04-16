extends CanvasLayer

const  heart_row_size = 8
const heart_offset = 16

@onready var heart: Sprite2D = $heart
@onready var ammo: Label = $ammo
@onready var ammo_amount: Label = $ammo_amount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in Player_Data.health:
		var new_heart = Sprite2D.new()
		new_heart.texture = heart.texture
		new_heart.hframes = heart.hframes
		heart.add_child(new_heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	ammo_amount.text = var_to_str(Player_Data.ammo)
	
	for heart in heart.get_children():
		var index = heart.get_index()
		var x = (index % heart_row_size) * heart_offset
		var y = (index / heart_row_size) * heart_offset
		heart.position = Vector2(x,y)
		
		var last_heart = floor(Player_Data.health)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = (Player_Data.health - last_heart) * 4
		if index < last_heart:
			heart.frame = 4
