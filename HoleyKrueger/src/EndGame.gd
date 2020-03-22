extends CanvasLayer

const Menu = preload("res://src/MainMenu.tscn")

func _ready():
	pass


func _on_Button_pressed():
	get_node("/root/global").jump_scene(Menu)
