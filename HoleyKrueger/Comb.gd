extends Node2D



export (PackedScene) var UnderGround;

var in_underground;
var overground;
var underground;

var player;

const Player = preload("res://src/Player.tscn");

const Holizard=  preload("res://src/Holizard.tscn")
const Pistol =   preload("res://src/items/Pistol.tscn")
const Bandage =   preload("res://src/items/Bandage.tscn")

const IngameInterface = preload("res://src/IngameInterface.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	if !player:
		player = Player.instance();
	player.get_node("BlockSelector").tile_checker = self;
	player.get_node("PlayerBody").position = $Node2D/PlayerPos.position;
	player.connect("on_dig",self,"_on_PlayerNode_on_dig")
	add_child(player)
	add_child(IngameInterface.instance())
	in_underground = false;
	overground = $Node2D
	underground = UnderGround.instance();


func sync_maps():
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


func change_scene():
	if in_underground:
		add_child_below_node(underground, overground);
		remove_child(underground)
	else:
		add_child_below_node(overground, underground);
		remove_child(overground)
	in_underground = !in_underground


func _on_PlayerNode_on_dig(pos):
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


func box_broken(position):
	var entity = Bandage.instance();
	entity.position = position
	if in_underground:
		underground.add_child(entity)
	else:
		overground.add_child(entity)

