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
	$DigSound.play()
	$DigSound.stream_paused = true

func blockify(vec):
	vec /= 128
	vec.x = floor(vec.x)
	vec.y = floor(vec.y)
	return vec

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disabled:
		return;
	var mouse_pos = blockify(get_global_mouse_position());
	var player_pos = blockify(get_node("../PlayerBody").position);
	if (mouse_pos.x == player_pos.x and abs(mouse_pos.y - player_pos.y)<=1) or (mouse_pos.y == player_pos.y and abs(mouse_pos.x - player_pos.x)<=1):
		visible=true
		dig_pos = mouse_pos
		rect_position.x = dig_pos.x * 128
		rect_position.y = dig_pos.y * 128
		if tile_checker.can_dig(dig_pos):
			if Input.is_mouse_button_pressed(1):
				$AnimationPlayer.play("progress");
				if $DigSound.stream_paused:
					$DigSound.stream_paused = false;
			else:
				$AnimationPlayer.play("glow");
				$DigSound.stream_paused = true;
		else:
			visible = false
			$AnimationPlayer.stop();
			$DigSound.stream_paused = true;
	else:
		$AnimationPlayer.stop();
		$DigSound.stream_paused = true;
		visible=false
	

func disable():
	disabled = true;
	visible = false;

func enable():
	disabled =false;

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "progress":
		get_node("..").emit_signal("on_dig", dig_pos);
