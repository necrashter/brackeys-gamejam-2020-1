extends Node2D

signal change_map;

export (PackedScene) var Hole;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func add_hole(pos):
	var hole = Hole.instance();
	hole.position = pos*128
	hole.position.x += 64
	hole.position.y += 64
	add_child(hole);

