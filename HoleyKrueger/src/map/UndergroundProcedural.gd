extends "res://src/map/UnderGroundSketch.gd"

const TS = [0,1]

const Holizard=  preload("res://src/Holizard.tscn")
const Pistol =   preload("res://src/items/Pistol.tscn")
const Bandage =   preload("res://src/items/Bandage.tscn")
const Box =   preload("res://src/items/Box.tscn")

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

func fill_with_dirt():
	for x in range(-40,40):
		for y in range(-40,40):
			$ShadowTiles.set_cell(x,y,0);
			$TileMap.set_cell(x,y,0);

func make_room(room):
	for i in range(room.size.x):
		for j in range(room.size.y):
			$ShadowTiles.set_cell(room.position.x+i, room.position.y+j, -1);
			$TileMap.set_cell(room.position.x+i, room.position.y+j, -1);

func populate_room0(room):
	for i in range(1+(randi()%2)):
		var x = room.position.x + randi()%int(room.size.x)
		var y = room.position.y + randi()%int(room.size.y)
		spawn_box(x,y)

func generate_room_map(max_rooms):
	fill_with_dirt();
	var rooms = []
	for i in range(max_rooms):
		var room = Rect2(
			(randi() % 80) -40,
			(randi() % 80) -40,
			randi()%4 + 2,
			randi()%4 + 2
		);
		var invalid = false;
		for other in rooms:
			if room.intersects(other):
				invalid = true;
				break;
		if invalid:
			continue;
		make_room(room);
		populate_room0(room)
		

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
	

func spawn_box(x,y):
	var holizard = Box.instance();
	holizard.position.x = 128*x + 64;
	holizard.position.y = 128*y + 64;
	add_child(holizard)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
