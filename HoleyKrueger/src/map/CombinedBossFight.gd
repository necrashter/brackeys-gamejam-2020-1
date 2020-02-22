extends "res://Combined.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerNode.camera_default =false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$PlayerNode:
		return
	if in_underground:
		$PlayerNode.camera_default = true
	else:
		$PlayerNode.camera_default = false
		if $Node2D/TripleHoly and !$Node2D/TripleHoly/VisibilityNotifier2D.is_on_screen():
			zoom_out()

func zoom_out():
	if !$PlayerNode:
		return
	$PlayerNode.zoom_out()
