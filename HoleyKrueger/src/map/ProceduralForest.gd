extends "res://src/map/map_sketch3.gd"

export (PackedScene) var Tree;
const Gun = preload("res://src/items/Pistol.tscn");
const Holizard = preload("res://src/Holizard.tscn")
const Bandage =   preload("res://src/items/Bandage.tscn")
const Box =   preload("res://src/items/Box.tscn")

var randoms = [Gun]

func _ready():
	var rooms = generate_room_map(15)
	for i in range(200 + (randi()%200)):
		var tree = Tree.instance();
		tree.position = random_pos_outside(rooms)
		add_child(tree)
		
		if randi()%5==0:
			var ee = randoms[randi()%randoms.size()].instance();
			ee.position = tree.position;
			add_child(ee);
		elif randi()%5:
			var ee = Holizard.instance();
			ee.connect("die", self, "holizard_death")
			ee.position = tree.position;
			add_child(ee);
	$PlayerPos.position = random_pos_outside(rooms)
	$Portal.next_scene = load("res://src/map/BossArenaSniper.tscn")
	#$Portal.position = random_pos_outside(rooms)
	$Portal.portal_name = "SNIPER BOSS ARENA"

func make_room(room):
	for i in range(room.size.x):
		$ShadowTiles.set_cell(room.position.x+i, room.position.y, 0);
		$WallTiles.set_cell(room.position.x+i, room.position.y, 4);
		$ShadowTiles.set_cell(room.position.x+i, room.position.y+room.size.y-1, 0);
		$WallTiles.set_cell(room.position.x+i, room.position.y+room.size.y-1, 4);
		for j in range(room.size.y):
			$TileMap.set_cell(room.position.x+i, room.position.y+j, 3);
	for j in range(room.size.y):
		$ShadowTiles.set_cell(room.position.x, room.position.y+j, 0);
		$WallTiles.set_cell(room.position.x, room.position.y+j, 4);
		$ShadowTiles.set_cell(room.position.x+room.size.x-1, room.position.y+j, 0);
		$WallTiles.set_cell(room.position.x+room.size.x-1, room.position.y+j, 4);
	if randi()%2==0:
		# select a random tile and make it dirt
		var x = room.position.x+1 + (randi()%int(room.size.x-2))
		var y = room.position.y+1 + (randi()%int(room.size.y-2))
		$TileMap.set_cell(x,y, -1);
	else:
		# select a random edge tile, and remove the wall
		var x
		var y
		if randi()%2:
			x = room.position.x+1 + (randi()%int(room.size.x-2))
			y  = room.position.y if randi()%2 else room.position.y+room.size.y-1
		else:
			x = room.position.x if randi()%2 else room.position.x+room.size.x-1
			y  = room.position.y+1 + (randi()%int(room.size.y-2))
		$ShadowTiles.set_cell(x,y,-1);
		$WallTiles.set_cell(x,y,-1);
	

func populate_room(room,i):
	match i:
		0:
			$Portal.position = random_pos_in(room)
		_:
			var box = Box.instance()
			box.position = random_pos_in(room)
			add_child(box)

func generate_room_map(max_rooms):
	var rooms = []
	var real_rooms = [] # rooms in real coordinates
	for i in range(max_rooms):
		var room = random_room_rect(rooms)
		make_room(room);
		populate_room(room, i)
		real_rooms.append(Rect2(room.position*128, room.size*128))
		room.position.x -= 1
		room.position.y -= 1
		room.size.x += 2
		room.size.y += 2
		rooms.append(room)
	return real_rooms

func random_room_rect(rooms):
	var room = Rect2(
		(randi() % 80) -40,
		(randi() % 80) -40,
		randi()%5 + 4,
		randi()%5 + 4
	);
	var invalid = false;
	for other in rooms:
		if room.intersects(other):
			invalid = true;
			break;
	if invalid:
		return random_room_rect(rooms)
	return room

func random_pos_outside(rooms):
	var vec = Vector2()
	vec.x = (randi() %10240 - 5120)
	vec.y = (randi() %10240 - 5120)
	for room in rooms:
		if room.has_point(vec):
			return random_pos_outside(rooms)
	return vec


func random_pos_in(room):
	var out =  Vector2(
		room.position.x +1 + randi()%int(room.size.x-2),
		room.position.y +1 + randi()%int(room.size.y-2)
	)*128
	out.x += 64
	out.y += 64
	return out

func holizard_death(pos):
	if randi()%6==0:
		var b = Bandage.instance()
		b.position = pos
		add_child(b)
