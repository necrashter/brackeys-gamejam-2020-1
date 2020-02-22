extends KinematicBody2D


export (PackedScene) var Bullet;

export var speed =800;
const push_force = 1000;
const spade_damage = 2;
var velocity;

var hands;
var handgun_shoot_finished = true;
var can_melee = true;

var nearby_holes =0;

var hp = 100;

var ammo = 100;
var has_handgun = false;
var handgun_ammo = 8;

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2();
	select_spade()


func _process(delta):
	velocity.x = 0;
	velocity.y = 0;
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
	look_at(get_global_mouse_position());
	velocity =move_and_slide(velocity);
	if Input.is_action_just_pressed("k1"):
		select_spade()
	elif Input.is_action_just_pressed("k2"):
		select_handgun();
	if hands == "spade":
		$AnimComplex/Spade.playing = Input.is_mouse_button_pressed(1)
		if Input.is_mouse_button_pressed(2):
			spade_melee()
	elif hands == "handgun":
		if Input.is_mouse_button_pressed(1) and handgun_shoot_finished:
			if handgun_ammo >0:
				shoot_bullet()
			#else: #play empty sound?
		elif Input.is_action_just_pressed("reload"):
			$AnimComplex/Handgun.play("reload")
			$ReloadSound.play()
			handgun_shoot_finished = false;
	if Input.is_action_just_pressed("go_up") and nearby_holes>0:
		get_tree().get_root().get_node("Combined").change_scene();

func select_spade():
	hands = "spade"
	$AnimComplex.rotation_degrees = 120;
	$AnimComplex/Spade.visible = true;
	$AnimComplex/Handgun.visible = false;
	$AnimComplex/backpack.visible = true;
	$AnimComplex/backpack2.visible = false;
	get_node("../BlockSelector").enable();
	$HUD/AmmoLabel.text = "Spade"
	

func select_handgun():
	if has_handgun:
		hands = "handgun"
		$AnimComplex.rotation_degrees = 142;
		$AnimComplex/Spade.visible = false;
		$AnimComplex/Handgun.visible = true;
		$AnimComplex/backpack.visible = false;
		$AnimComplex/backpack2.visible = true;
		get_node("../BlockSelector").disable();
		$HUD.update_ammo(handgun_ammo, ammo);
	else:
		print("You don't have handgun")

func spade_melee():
	if can_melee and !is_blocked():
		$HitAnim.play("hit");
		for body in $MeleeArea.get_overlapping_bodies():
			if body.is_in_group("fragile"):
				body.get_hit(spade_damage)
			if body.is_in_group("pushable"):
				var vec = body.position - position;
				body.push(vec.normalized() * push_force)
		can_melee = false;

func _on_Handgun_animation_finished():
	$AnimComplex/Handgun.stop()
	handgun_shoot_finished = true;
	if $AnimComplex/Handgun.animation == "reload":
		if ammo >=7:
			ammo -= 7-handgun_ammo;
			handgun_ammo = 7;
		else:
			handgun_ammo += ammo;
			ammo = 0;
		$HUD.update_ammo(handgun_ammo, ammo);

func shoot_bullet():
	if is_blocked():
		return;
	$AnimComplex/Handgun.play("shoot")
	$AnimComplex/Handgun/Muzzle/AnimationPlayer.play("muzzle")
	$ShootSound.play()
	var bullet = Bullet.instance();
	bullet.shoot($AnimComplex/Handgun/Position2D.get_global_transform().get_origin(), rotation)
	get_tree().get_root().add_child(bullet);
	handgun_shoot_finished = false
	handgun_ammo -= 1;
	$HUD.update_ammo(handgun_ammo, ammo);

func get_hit(dmg):
	hp -= dmg;
	$HUD.update_health(hp)
	$GruntSound.play()
	if hp <= 0:
		var camera =$Camera2D;
		camera.position = position
		remove_child(camera)
		get_parent().get_parent().add_child(camera)
		get_parent().queue_free()

func give_ammo(count):
	ammo += count
	has_handgun = true;
	if hands == "handgun":
		$HUD.update_ammo(handgun_ammo, ammo)

func give_hp(p):
	hp += p;
	if hp>100:
		hp =100
	$HUD.update_health(hp)

func is_blocked():
	for body in $BlockArea.get_overlapping_bodies():
		if body is StaticBody2D or body is TileMap:
			return true;
	return false

func _on_HitAnim_animation_finished(anim_name):
	can_melee = true;
