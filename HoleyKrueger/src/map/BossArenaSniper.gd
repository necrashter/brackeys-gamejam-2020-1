extends "res://Combined.gd"

const EndGame = preload("res://src/EndGame.tscn")
const Credits = preload("res://src/Credits.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func generate_map():
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	get_node("/root/global").postCredits = EndGame;
	get_node("/root/global").jump_scene(Credits)
