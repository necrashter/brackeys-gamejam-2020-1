extends KinematicBody2D

signal shot;
signal die(position)

export var speed = 600;
export var hp = 10;

var state;
var velocity = Vector2();
var push_velo = Vector2();
var turn_anim;

var victim;

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = speed;
	#start_wander()
	

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
func _physics_process(delta):
	var net_velo = Vector2();
	if state == "wander":
		net_velo = velocity.rotated(rotation)
	elif state == "chase":
		if !victim.get_ref():
			start_idle();
		else:
			var target_rotation = (victim.get_ref().position - position).angle()
			rotation = target_rotation#*0.25 + rotation*0.75
			net_velo = velocity.rotated(rotation)
	if push_velo.length_squared() > 0.1:
		push_velo.x *= 55*delta;
		push_velo.y *= 55*delta;
		net_velo.x += push_velo.x
		net_velo.y += push_velo.y
	move_and_slide(net_velo)

func _process(delta):
	if state:
		$Label.text = state;
	else:
		$Label.text = "NULL"

func rand_turn():
	turn_anim = Animation.new();
	turn_anim.add_track(0)
	turn_anim.track_set_path(0, ".:rotation");
	turn_anim.track_insert_key( 0, 0.0, rotation )
	turn_anim.track_insert_key( 0, 1.0, rand_range(0,2*PI))


func _on_BoredTimer_timeout():
	if state == "chase" or state == "dying" or state == "attack":
		return;
	if randi() %2:
		$IdleNoise0.play()
	else:
		$IdleNoise1.play()
	if randi() % 2:
		start_wander();
	else:
		start_idle();


func _on_Sense_body_entered(body):
	if body.is_in_group("zombie_meat"):
		victim = weakref(body);
		$Area2D.get_overlapping_bodies().has(victim);
		$AnimatedSprite.animation = "walk"
		$AnimationPlayer.stop()
		state = "chase";

func get_hit(dmg):
	if state=="dying":
		return;
	$PainNoise.play()
	emit_signal("shot")
	hp -= dmg;
	if hp <= 0:
		state = "dying"
		die()

func die():
	emit_signal("die", position);
	#var spr = get_node("AnimatedSprite");
	#remove_child(spr);
	#get_parent().add_child(spr);
	#get_parent().add_child(spr);
	#spr.position = position;
	#spr.rotation = rotation;
	#spr.scale = scale;
	#spr.z_index = -1;
	#spr.stop()
	#spr.animation = "die";
	#spr.set_frame(16);
	queue_free();
	
func _on_AnimatedSprite_animation_finished():
	if state == "attack":
		if victim.get_ref():
			if $Area2D.get_overlapping_bodies().has(victim.get_ref()):
				$AttackTimer.start();
			else:
				state = "chase";
				$AnimatedSprite.animation = "walk"
		else:
			start_idle()


func _on_Area2D_body_entered(body):
	if state == "dying":
		return;
	if body.is_in_group("zombie_meat"):
		victim = weakref(body)
		$AttackTimer.start();
		$AnimatedSprite.play("attack")
		state = "attack";


func _on_Area2D_body_exited(body):
	if victim and victim.get_ref():
		if body == victim.get_ref() and state == "attack":
			state = "chase"
			$AnimatedSprite.animation = "walk"
			$AttackTimer.stop()

func push(vec):
	push_velo = vec;


func _on_AttackTimer_timeout():
	if victim and victim.get_ref():
		if $Area2D2.get_overlapping_bodies().has(victim.get_ref()):
			victim.get_ref().get_hit(rand_range(2.0, 8.0));
