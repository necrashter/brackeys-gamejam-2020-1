extends KinematicBody2D

signal shot;
signal die(position)

export var speed = 6;
export var hp = 4;

var state;
var velocity = Vector2();
var push_velo = Vector2();
var turn_anim;

var victim;

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = speed;
	start_wander()

func start_wander():
	state = "wander";
	rand_turn()
	$AnimationPlayer.add_animation("turn", turn_anim)
	$AnimationPlayer.play("turn")
	$AnimatedSprite.animation = "walk"
	$BoredTimer.start(rand_range(1,3))

func start_idle():
	state = "idle";
	$AnimatedSprite.animation = "idle"
	$BoredTimer.start(rand_range(1,3))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if push_velo.length_squared() > 0.1:
		move_and_collide(push_velo);
		push_velo.x *= .9;
		push_velo.y *= .9;
	elif state == "wander":
		move_and_collide(velocity.rotated(rotation))
	elif state == "chase":
		if !victim.get_ref():
			start_idle();
		else:
			var target_rotation = (victim.get_ref().position - position).angle()
			rotation = target_rotation*0.25 + rotation*0.75
			move_and_collide(velocity.rotated(rotation))

func rand_turn():
	turn_anim = Animation.new();
	turn_anim.add_track(0)
	turn_anim.track_set_path(0, ".:rotation");
	turn_anim.track_insert_key( 0, 0.0, rotation )
	turn_anim.track_insert_key( 0, 1.0, rand_range(0,2*PI))


func _on_BoredTimer_timeout():
	if state == "chase" or state == "dying" or state == "attack":
		return;
	$IdleNoise.play()
	if randi() % 2:
		start_wander();
	else:
		start_idle();


func _on_Sense_body_entered(body):
	if body.is_in_group("zombie_meal"):
		victim = weakref(body);
		$Area2D.get_overlapping_bodies().has(victim);
		$AnimatedSprite.animation = "walk"
		state = "chase";

func get_hit():
	if state=="dying":
		return;
	emit_signal("shot")
	hp -= 1;
	if hp <= 0:
		state = "dying"
		$AnimatedSprite.play("die"+str(randi()%2));


func _on_AnimatedSprite_animation_finished():
	if state=="dying":
		emit_signal("die", position);
		var spr = get_node("AnimatedSprite");
		remove_child(spr);
		#get_parent().add_child(spr);
		get_parent().add_child(spr);
		spr.position = position;
		spr.rotation = rotation;
		spr.scale = scale;
		spr.z_index = -1;
		spr.stop()
		#spr.animation = "die";
		spr.set_frame(16);
		queue_free()
	elif state == "attack":
		if victim.get_ref():
			if $Area2D.get_overlapping_bodies().has(victim.get_ref()):
				victim.get_ref().get_hit(rand_range(2.0, 8.0));
				$AnimatedSprite.play("attack0"+str(randi()%2+1));
			else:
				state = "chase";
				$AnimatedSprite.animation = "walk"
		else:
			start_idle()


func _on_Area2D_body_entered(body):
	if state == "dying":
		return;
	if body.is_in_group("zombie_meal"):
		victim = weakref(body)
		body.get_hit(rand_range(2.0, 8.0));
		state = "attack";
		$AnimatedSprite.play("attack0"+str(randi()%2+1))
		
func push(vec):
	push_velo = vec;
