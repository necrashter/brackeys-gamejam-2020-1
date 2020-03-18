extends "res://src/map/UnderGroundSketch.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-40,40):
		for y in range(-40,40):
			if $TileMap.get_cell(x,y) >= 0:
				$ShadowTiles.set_cell(x,y,0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func beginBoss():
	$TileMap.set_cell(0, 17, 1)
	$TileMap.set_cell(-1, 17, 1)
	$ShadowTiles.set_cell(0,17,0)
	$ShadowTiles.set_cell(-1,17,0)
