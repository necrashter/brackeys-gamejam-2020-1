extends Node2D

export (PackedScene) var Hole;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func add_hole(pos):
	var hole = Hole.instance();
	hole.position = pos*128
	hole.position.x += 64
	hole.position.y += 64
	add_child(hole);

func remove_tile(pos):
	var out  = $ShadowTiles.get_cellv(pos) == 0;
	$TileMap.set_cellv(pos, -1);
	$ShadowTiles.set_cellv(pos, -1);
	return out;
