extends "res://src/map/UnderGroundSketch.gd"


func _ready():
	for x in range(-40,40):
		for y in range(-40,40):
			if $TileMap.get_cell(x,y) >= 0:
				$ShadowTiles.set_cell(x,y,0);
