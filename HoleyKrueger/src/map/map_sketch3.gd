extends "res://src/map/map_sketch.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-40,40):
		for y in range(-40,40):
			if $WallTiles.get_cell(x,y)>=0:
				$ShadowTiles.set_cell(x,y,0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
