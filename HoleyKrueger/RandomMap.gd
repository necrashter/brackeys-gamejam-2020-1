extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func generate(sizex, sizey):
	for x in range(sizex):
		for y in range(sizey):
			$TileMap.set_cell(x,y, randi()%2); 
#	mapify(sizex, sizey, 3, 0.6)		

# to create smoother maps
func mapify(sizex, sizey, n, t):
	for i in range(n):
		for x in range(sizex):
			for y in range(sizey):
				var tot = 1
				var one = $TileMap.get_cell(x,y)
				if x != 0 and y != 0:
					tot += 1
					one += $TileMap.get_cell(x-1, y-1)
				if x != 0:
					tot += 1
					one += $TileMap.get_cell(x-1, y)					
				if y != 0:
					tot += 1
					one += $TileMap.get_cell(x, y-1)
				if x != sizex-1 and y != 0:
					tot += 1
					one += $TileMap.get_cell(x+1, y-1)
				if x != sizex-1 and y != sizey-1:
					tot += 1
					one += $TileMap.get_cell(x+1, y+1)										
				if x != 0 and y != sizey-1:
					tot += 1
					one += $TileMap.get_cell(x-1, y+1)
				if x != sizex-1:
					tot += 1
					one += $TileMap.get_cell(x+1, y)										
				if y != sizey-1:
					tot += 1
					one += $TileMap.get_cell(x, y+1)
				if float(one)/float(tot) >= t:
					$TileMap.set_cell(x, y, 1)
				else:
					$TileMap.set_cell(x, y, 0)							
												
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	generate(20,20);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
