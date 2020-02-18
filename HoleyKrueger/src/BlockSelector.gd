extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const red = Color(1,0,0,0.3);
var dig_progress;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = (get_global_mouse_position()/128);
	pos.x = floor(pos.x)
	pos.y = floor(pos.y)
	rect_position.x = pos.x * 128
	rect_position.y = pos.y * 128
	if get_global_mouse_position().distance_squared_to(get_node("../PlayerBody").position) < 65536:
		$AnimationPlayer.play("glow");
		if Input.is_mouse_button_pressed(1):
			dig_progress += delta
			if dig_progress>=1:
				get_node("..").emit_signal("on_dig", pos);
				dig_progress=-1000
		else:
			dig_progress = 0;
	else:
		color = red
	
