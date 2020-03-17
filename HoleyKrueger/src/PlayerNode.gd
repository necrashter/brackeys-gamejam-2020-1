extends Node2D

signal on_dig(position)

var camera_default = true;
var desired_zoom = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera_default:
		if $PlayerBody/Camera2D.zoom.x >1:
			$PlayerBody/Camera2D.zoom.x = (desired_zoom+$PlayerBody/Camera2D.zoom.x)/2
			$PlayerBody/Camera2D.zoom.y = (desired_zoom+$PlayerBody/Camera2D.zoom.y)/2

func zoom_out():
	$PlayerBody/Camera2D.zoom.x += 0.01
	$PlayerBody/Camera2D.zoom.y += 0.01

func camera_reset():
	camera_default =true
