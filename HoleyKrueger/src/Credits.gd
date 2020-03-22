extends CanvasLayer

func _ready():
	$AnimationPlayer.get_animation("CreditsRoll").track_set_key_value(0,0,Vector2(60, get_viewport().size.y))
	$AnimationPlayer.play("CreditsRoll")
	
func skip():
	get_node("/root/global").jump_scene(get_node("/root/global").postCredits)

func _on_AnimationPlayer_animation_finished(anim_name):
	skip()
