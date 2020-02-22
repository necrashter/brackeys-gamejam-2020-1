extends Node2D


export (PackedScene) var Bullet;

var target_rotation = 0;
const turn_speed = 4*PI;
var can_shoot = true;
var should_shoot = false;

var hp = 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func lock_target(target, delta):
	target_rotation = (target.position - $LowerArm.get_global_transform().get_origin()).angle() + PI/2 - get_parent().rotation;
	var dif = target_rotation-$LowerArm.rotation
	if dif>PI:
		dif -= 2*PI
	elif dif<-PI:
		dif += 2*PI
	$LowerArm.rotation += clamp(dif, -1, 1)*delta*turn_speed;
	if should_shoot:
		shoot()

func shoot():
	if can_shoot:
		$AnimationPlayer.play("shoot")
		$LaserSound.play()
		var bullet = Bullet.instance();
		var gt = $LowerArm/LaserPos.get_global_transform();
		bullet.shoot(gt.get_origin(), gt.get_rotation()-PI/2)
		get_tree().get_root().add_child(bullet);
		can_shoot = false;


func _on_AnimationPlayer_animation_finished(anim_name):
	can_shoot = true;


func _on_Detector_body_entered(body):
	if body.is_in_group("zombie_meat"):
		should_shoot = true;

func _on_Detector_body_exited(body):
	if body.is_in_group("zombie_meat"):
		should_shoot = false;

func get_hit(dmg):
	hp -= dmg;
	if hp <= 0:
		queue_free();
