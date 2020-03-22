extends CanvasLayer

var take_damage_map;
var hit_damage_map;

const Level = preload("res://src/map/ProceduralCombined.tscn")

func _ready():
	take_damage_map = {
		"casual": 0.5,
		"easy": 0.75,
		"normal": 1.0
	}
	hit_damage_map = {
		"casual": 2.0,
		"easy": 1.5,
		"normal": 1.0,
	}

func set_difficulty(difficulty):
	var globals = get_node("/root/global")
	globals.take_damage_mul = take_damage_map[difficulty]
	globals.hit_damage_mul = hit_damage_map[difficulty]

func start_game():
	get_node("/root/global").jump_scene(Level)


func _on_CasualStartButton_pressed():
	set_difficulty("casual")
	$ColorRect.visible = true
	$ColorRect/Fade.play("fade")
	

func _on_EasyStartButton_pressed():
	set_difficulty("easy")
	$ColorRect.visible = true
	$ColorRect/Fade.play("fade")


func _on_NormalStartButton_pressed():
	set_difficulty("normal")
	$ColorRect.visible = true
	$ColorRect/Fade.play("fade")


func _on_QuitButton_pressed():
	get_tree().quit(0)


func _on_Fade_animation_finished(anim_name):
	start_game()
