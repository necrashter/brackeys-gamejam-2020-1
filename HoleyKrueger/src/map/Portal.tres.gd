extends Area2D

var next_scene;
var portal_name;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_Hole_body_entered(body):
	if body.is_in_group("player"):
		if next_scene:
			body.portal_enter(next_scene, portal_name)


func _on_Hole_body_exited(body):
	if body.is_in_group("player"):
		if next_scene:
			body.portal_exit(next_scene, portal_name)
