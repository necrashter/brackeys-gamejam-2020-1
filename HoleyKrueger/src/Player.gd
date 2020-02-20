extends KinematicBody2D


export (PackedScene) var Bullet;

export var speed =800;
var velocity;

var hands;
var handgun_shoot_finished = true;

var nearby_holes =0;

var ammo = 100;
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
			$HitAnim.play("hit");
	elif hands == "handgun":
		if Input.is_mouse_button_pressed(1) and handgun_shoot_finished:
			if handgun_ammo >0:
				shoot_bullet()
			#else: #play empty sound?
		elif Input.is_action_just_pressed("reload"):
			$AnimComplex/Handgun.play("reload")
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
	hands = "handgun"
	$AnimComplex.rotation_degrees = 142;
	$AnimComplex/Spade.visible = false;
	$AnimComplex/Handgun.visible = true;
	$AnimComplex/backpack.visible = false;
	$AnimComplex/backpack2.visible = true;
	get_node("../BlockSelector").disable();
	$HUD.update_ammo(handgun_ammo, ammo);


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
	$AnimComplex/Handgun.play("shoot")
	var bullet = Bullet.instance();
	bullet.shoot($AnimComplex/Handgun/Position2D.get_global_transform().get_origin(), rotation)
	get_tree().get_root().add_child(bullet);
	handgun_shoot_finished = false
	handgun_ammo -= 1;
	$HUD.update_ammo(handgun_ammo, ammo);
