extends "res://src/map/UnderGroundSketch.gd"

const TS = [0,1]

const Holizard=  preload("res://src/Holizard.tscn")
const Pistol =   preload("res://src/items/Pistol.tscn")
const Bandage =   preload("res://src/items/Bandage.tscn")

func generate_map():
	for x in range(-40,40):
		for y in range(-40,40):
			if randi() % 2:
				$ShadowTiles.set_cell(x,y,0);
				$TileMap.set_cell(x,y,TS[randi()%2]);
			else:
				$ShadowTiles.set_cell(x,y,-1);
				$TileMap.set_cell(x,y,-1);
				if randi() % 40 ==0:
					spawn_holizard(x,y);
				elif randi() % 40 == 0:
					spawn_bandage(x,y)
				elif randi() % 40 == 0:
					spawn_pistol(x,y)

func spawn_holizard(x,y):
	var holizard = Holizard.instance();
	holizard.position.x = 128*x + 64;
	holizard.position.y = 128*y + 64;
	add_child(holizard)

func spawn_pistol(x,y):
	var holizard = Pistol.instance();
	holizard.position.x = 128*x + 64;
	holizard.position.y = 128*y + 64;
	add_child(holizard)

func spawn_bandage(x,y):
	var holizard = Bandage.instance();
	holizard.position.x = 128*x + 64;
	holizard.position.y = 128*y + 64;
	add_child(holizard)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
