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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func reshield():
	shield=shieldHp
	shieldCount-=1

func teleport():
	if(position.x>=1):
		position.x=-500;
	else:
		position.x=500;

func shoot():
	if 1:
		#$AnimationPlayer.play("shoot")
		$LaserSound.play()
		var bullet = Bullet.instance();
		#var gt = $LowerArm/LaserPos.get_global_transform();
		bullet.shoot(position, rotation-PI/2)
		get_tree().get_root().add_child(bullet);

# Called every frame. 'delta' is the elapsed time since the previous frame.
var x=0;
func _process(delta):
	x+=1;
	if x%120==0:
		shoot();
		teleport();
#	pass
