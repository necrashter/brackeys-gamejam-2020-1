extends Node2D

export (PackedScene) var UnderGround;

var in_underground;
var overground;
var underground;

# Called when the node enters the scene tree for the first time.
func _ready():
	in_underground = false;
	overground = $Node2D
	underground = UnderGround.instance();


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
	overground.on_dig(pos);
	underground.on_dig(pos);
