extends Node2D

export (PackedScene) var UnderGround;

var in_underground;
var overground;
var underground;

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerNode/BlockSelector.tile_checker = self;
	in_underground = false;
	overground = $Node2D
	underground = UnderGround.instance();
	underground.generate_map()
	for x in range(-40,40):
		for y in range(-40,40):
			#else:
			#	overground.get_node("TileMap").set_cell(x,y,-1);
			if overground.get_node("WallTiles").get_cell(x,y)>=0:
				underground.get_node("BackTiles").set_cell(x,y,5);
			elif overground.get_node("TileMap").get_cell(x,y)>=0:
				underground.get_node("BackTiles").set_cell(x,y,5);
			elif underground.get_node("TileMap").get_cell(x,y)==1:
				overground.get_node("TileMap").set_cell(x,y,2);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func change_scene():
	if in_underground:
		add_child_below_node(underground, overground);
		remove_child(underground)
	else:
		add_child_below_node(overground, underground);
		remove_child(overground)
	in_underground = !in_underground


func _on_PlayerNode_on_dig(pos):
	print("digged:",pos.x, pos.y);
	var dug = underground.remove_tile(pos);
	if !in_underground or !dug:
		overground.add_hole(pos);
		underground.add_hole(pos);

func can_dig(pos):
	var undtile = underground.get_node("TileMap").get_cellv(pos)
	var undback = underground.get_node("BackTiles").get_cellv(pos)
	if undback > 0:
		return undtile != 1 and undtile >= 0 and in_underground
	else:
		return undtile != 1
	return undtile != 1 and (undback==-1 or undtile != 1);
