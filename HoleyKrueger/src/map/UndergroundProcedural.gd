extends "res://src/map/UnderGroundSketch.gd"

const TS = [0,1]

# Called when the node enters the scene tree for the first time.
#func _init():

func generate_map():
	for x in range(-40,40):
		for y in range(-40,40):
			if randi() % 2:
				$ShadowTiles.set_cell(x,y,0);
				$TileMap.set_cell(x,y,TS[randi()%2]);
			else:
				$ShadowTiles.set_cell(x,y,-1);
				$TileMap.set_cell(x,y,-1);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
