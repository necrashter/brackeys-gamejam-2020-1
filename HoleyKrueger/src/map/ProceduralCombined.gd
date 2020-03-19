extends "res://Comb.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	underground.generate_room_map(40)
	sync_maps()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
