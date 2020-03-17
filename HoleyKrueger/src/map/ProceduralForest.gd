extends "res://src/map/map_sketch3.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (PackedScene) var Tree;
var Gun = load("res://src/items/Pistol.tscn");
var Holizard = load("res://src/Holizard.tscn")

var randoms = [Gun, Holizard]

func _ready():
	for i in range(200 + (randi()%200)):
		var tree = Tree.instance();
		tree.position.x = (randi() %10240 - 5120)
		tree.position.y = (randi() %10240 - 5120)
		add_child(tree)
		
		if randi()%2:
			var ee = randoms[randi()%randoms.size()].instance();
			ee.position = tree.position;
			add_child(ee);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
