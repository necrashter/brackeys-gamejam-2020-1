extends Node2D

export (PackedScene) var Hole;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func on_dig(pos):
	var hole = Hole.instance();
	hole.position = pos*128
	hole.position.x += 64
	hole.position.y += 64
	add_child(hole);
