extends Sprite

var red = preload("res://gfx/enemies/holy_robot/head.png")
var green = preload("res://gfx/enemies/holy_robot/head_green.png")
var off =  preload("res://gfx/enemies/holy_robot/head_nolight.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_green():
	texture = green

func set_red():
	texture = red

func set_off():
	texture = off
