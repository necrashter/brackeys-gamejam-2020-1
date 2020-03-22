extends "res://src/map/map_sketch.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-40,40):
		for y in range(-40,40):
			if $WallTiles.get_cell(x,y)>=0:
				$ShadowTiles.set_cell(x,y,0);
	$Portal.next_scene = load("res://src/MainMenu.tscn")
	$Portal.portal_name = "MAIN MENU"


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MovementArea_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("HUD").message("WASD: Move")


func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		body.get_node("HUD").clear_message()


func _on_SwingArea_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("HUD").message("Right Click: Swing")


func _on_DigArea_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("HUD").message("Hold Left Click: Dig\nSpace: Go through hole")



func _on_PistolArea_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("HUD").message("Press 2: Select Pistol\nLeft Click: Fire\nR: Reload")
