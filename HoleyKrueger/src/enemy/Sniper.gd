extends KinematicBody2D


export var hp=300;
export var shieldHp=30;

export (PackedScene) var Bullet;

var shield=shieldHp;
var shieldCount=3;

var phase=1;
var target = null;
var state = "idle";

var target_rotation = 0;
const turn_speed = 2*PI;

func next_phase():
	phase=2;

func get_hit(dmg):
	if (shield<=0):
		hp -= dmg;
	else:
		shield-=dmg;
	if hp <= 0:
		die();

# Called when the node enters the scene tree for the first time.
func _ready():
	# boss will know the player position at all times
	# you will need to check if player is valid, so that game doesn't crash when player dies.
	target = weakref( get_tree().get_current_scene().player.get_node("PlayerBody") );


func reshield():
	shield=shieldHp
	# I think it would be better if the number of shield were unlimited
	shieldCount-=1

func teleport():
	# since we have a fixed arena for this boss,
	# we can just use Position2D nodes for a set of predetermined
	# telepor locations
	position = get_parent().get_node("SniperPos%d"%(randi()%4)).position
	# we can also experiment with random positions within arena

func shoot():
	if 1:
		#$AnimationPlayer.play("shoot")
		$LaserSound.play()
		var bullet = Bullet.instance();
		bullet.shoot($BarrelPos.get_global_transform().get_origin(), rotation)
		get_tree().get_root().add_child(bullet);

# Called every frame. 'delta' is the elapsed time since the previous frame.
var x=0;
#func _process(delta):
#	pass

# physics process is always called with constant delta, unlike _process
func _physics_process(delta):
	if target.get_ref(): #if player is alive
		look_at(target.get_ref().position)
		# a timer might be more appropriate for this
		x+=1;
		if x%120==0:
			shoot();
			teleport();
		
func die():
	queue_free();
