extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var target = null;
var state = "idle";

var target_rotation = 0;
const turn_speed = 2*PI;

var hp = 100;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Head.set_green()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == "dead":
		return;
	if state == "hunt":
		if target.get_ref():
			var t = target.get_ref();
			target_rotation = (t.position - position).angle() + PI/2;
			if has_node("LeftArm"): $LeftArm.lock_target(t, delta)
			if has_node("RightArm"): $RightArm.lock_target(t, delta)
		else:
			state = "idle"
	var dif = target_rotation-rotation
	if dif>PI:
		dif -= 2*PI
	elif dif<-PI:
		dif += 2*PI
	rotation += clamp(dif, -1, 1)*delta*turn_speed;


func _on_Sight_body_entered(body):
	if state != "dead" and body.is_in_group("zombie_meat"):
		target = weakref(body);
		state = "hunt"
		$Head.set_red()


func _on_Sight_body_exited(body):
	if state=="hunt" and target.get_ref() and target.get_ref() == body:
		state = "idle";
		$Head.set_green()

func get_hit(dmg):
	hp -= dmg
	if hp<=0:
		$Head.set_off()
		state = "dead"
