extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const red = Color(1,0,0,0.3);
var dig_pos;

var disabled = false;
var tile_checker;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disabled:
		return;
	var mouse_pos = get_global_mouse_position();
	var player_pos = get_node("../PlayerBody").position;
	if abs(mouse_pos.x - player_pos.x) + abs(mouse_pos.y - player_pos.y) < 192:
		visible=true
		dig_pos = (mouse_pos/128);
		dig_pos.x = floor(dig_pos.x)
		dig_pos.y = floor(dig_pos.y)
		rect_position.x = dig_pos.x * 128
		rect_position.y = dig_pos.y * 128
		if tile_checker.can_dig(dig_pos):
			if Input.is_mouse_button_pressed(1):
				$AnimationPlayer.play("progress");
			else:
				$AnimationPlayer.play("glow");
		else:
			color = red;
	else:
		$AnimationPlayer.stop();
		visible=false
	

func disable():
	disabled = true;
	visible = false;

func enable():
	disabled =false;

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "progress":
		get_node("..").emit_signal("on_dig", dig_pos);
