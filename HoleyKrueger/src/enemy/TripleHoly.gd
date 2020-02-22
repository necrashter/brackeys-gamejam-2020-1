extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 1000;
var velocity = Vector2()

const turn_speed = PI;
const pref_dist_sqr = 1000*1000;
const close_dist_sqr = 800*800;
var distance_sqr = pref_dist_sqr;

const cruise_speed = 200;
const seek_speed =400

var target;
var state;
var mood;

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = speed;
	state = "idle"
	mood = "calm"


func turn_to_pos(target_position, delta):
	var target_rotation = (target_position).angle_to_point(position)
	var dif = target_rotation-global_rotation
	if dif>PI:
		dif -= 2*PI
	elif dif<-PI:
		dif += 2*PI
	global_rotation += clamp(dif, -1, 1)*delta*turn_speed;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = state
	if state == "seek": seek(delta, pref_dist_sqr)
	elif state == "circle": circle(delta)

func circle(delta):
	velocity.x = cruise_speed
	if target and target.get_ref():
		var target_position = target.get_ref().position;
		var prev_dist = target_position.distance_to(position);
		position += delta*velocity.rotated(rotation+PI/2)
		var new_dist = target_position.distance_to(position);
		velocity.x =new_dist - prev_dist;
		position += velocity.rotated(rotation)
		turn_to_pos(target_position, delta)
		if position.distance_squared_to(target_position)>pref_dist_sqr:
			state = "seek"

func seek(delta, distance):
	velocity.x = seek_speed
	if target and target.get_ref():
		var target_position = target.get_ref().position;
		turn_to_pos(target_position, delta)
		position += delta*velocity.rotated(rotation)
		if position.distance_squared_to(target_position) <= distance:
			state = "circle"
	else:
		state = "idle"


func back_up(delta, distance):
	velocity.x = seek_speed
	if target and target.get_ref():
		var target_position = target.get_ref().position;
		turn_to_pos(target_position, delta)
		position += delta*velocity.rotated(PI+rotation)
		if position.distance_squared_to(target_position) >= distance:
			state = "circle"
			$CircleTimer.start()
	else:
		state = "idle"

func _on_Domain_body_entered(body):
	if body.is_in_group("zombie_meat"):
		target = weakref(body)
		state = "seek"


func _on_CircleTimer_timeout():
	if mood == "calm":
		mood = "storm"
		distance_sqr = close_dist_sqr
	elif mood == "storm":
		mood = "calm"
		distance_sqr = pref_dist_sqr
		
