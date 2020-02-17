extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func generate(sizex, sizey):
	for x in range(sizex):
		for y in range(sizey):
			$TileMap.set_cell(x,y, randi()%2);

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	generate(20,20);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
