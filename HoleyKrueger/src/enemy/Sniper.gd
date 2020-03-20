extends KinematicBody2D

signal die;

const Holizard = preload("res://src/SniperHolizard.tscn")

export var hp=300;
export var shieldHp=15;
export var constBulletNumber=3;

export (PackedScene) var Bullet;

# shield is off by default
var shield=0;
var shieldCount=3;
var bulletNo=constBulletNumber;

var phase=1;
var target = null;
var state = "fire";

var target_rotation = 0;
const turn_speed = 2*PI;

const step_speed = Vector2(1500, 0)
var velocity = Vector2.ZERO

# this is a reference to a AudioStreamPlayer
# will be set by the map when boss spawns
var music;

func next_phase():
	phase=2;


func start_fire():
	state = "fire"; #dont move , fire 3 times


func start_reload():
	state = "reload"; #run away from player, if stuck then teleport
	if phase==2:
		spawn_holizard(2);
	$ReloadTimer.start();
	bulletNo=constBulletNumber;
	
func _on_ReloadTimer_timeout():
	start_fire();



func get_hit(dmg):
	if (shield<=0):
		hp -= dmg;
	else:
		shield-=dmg;
		if shield <=0:
			$Shield.visible = false
	$BossBar.set_value(hp)
	if hp <= 0:
		die();

# Called when the node enters the scene tree for the first time.
func _ready():
	# boss will know the player position at all times
	# you will need to check if player is valid, so that game doesn't crash when player dies.
	target = weakref( get_tree().get_current_scene().player.get_node("PlayerBody") );
	$BossBar.set_value(hp)
	target.get_ref().desiredZoom = 2.0;

func spawn_holizard(number):
	for i in number:
		var h=Holizard.instance();
		h.position= $BarrelPos.get_global_transform().get_origin()
		if target.get_ref():
			h._on_Sense_body_entered(target.get_ref());
		get_tree().get_current_scene().add_child(h);

func reshield():
	shield=shieldHp
	$Shield.visible =true

func teleport ():
	if(get_tree().get_current_scene().player.get_node("PlayerBody").position.y> 1000 ):
		position.y=300;
	else:
		position.y=1700;
	if(get_tree().get_current_scene().player.get_node("PlayerBody").position.x> 0):
		position.x=-1700;
	else: 
		position.x=1700;
	
func rand_teleport():
	# since we have a fixed arena for this boss,
	# we can just use Position2D nodes for a set of predetermined
	# telepor locations
	position = get_parent().get_node("SniperPos%d"%(randi()%4)).position
	# we can also experiment with random positions within arena

func shoot():
	if 1:
		#$AnimationPlayer.play("shoot")
		bulletNo-=1;
		$LaserSound.play()
		var bullet = Bullet.instance();
		bullet.shoot($BarrelPos.get_global_transform().get_origin(), rotation)
		get_tree().get_root().add_child(bullet);

func step_forward():
	velocity = step_speed.rotated(rotation)

func step_sideways():
	var addition = -PI/2 if randi()%2 else PI/2
	velocity = step_speed.rotated(rotation+addition)


# physics process is always called with constant delta, unlike _process
func _physics_process(delta):
	if target.get_ref(): #if player is alive
		var distance_between =  position.distance_to(target.get_ref().position)/4000
		look_at(target.get_ref().get_next_position(distance_between))
		# a timer might be more appropriate for this
		var time = music.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
		$Label.text = str(time);
		$StateMachine.update(time);
		#if x%40==0:
		#	if  abs(position.y-get_tree().get_current_scene().player.get_node("PlayerBody").position.y)<=200 or abs(position.x-get_tree().get_current_scene().player.get_node("PlayerBody") .position.x)<=400 :
	velocity = move_and_slide(velocity)
	velocity *= delta*55
		
func die():
	queue_free();
	emit_signal("die")
	if target.get_ref():
		target.get_ref().desiredZoom = 1.0;
