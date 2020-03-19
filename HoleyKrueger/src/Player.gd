extends KinematicBody2D


export (PackedScene) var Bullet;

export var speed =800;
export var acc = 8000;
const push_force = 1200;
const spade_damage = 3;
const push = 100;
var velocity;
var acceleration;

var hands;
var handgun_shoot_finished = true;
var can_melee = true;

var nearby_holes =0;

var hp = 100;

var ammo = 0;
var has_handgun = false;
var handgun_ammo = 8;

const ZERO = Vector2(0,0)

var next_scene;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.force_update_scroll()
	$Camera2D.position= Vector2(0,0)
	velocity = Vector2();
	acceleration = Vector2();
	select_spade()


func _physics_process(delta):
	acceleration.x = 0;
	acceleration.y = 0;
	if Input.is_action_pressed("ui_right"):
		acceleration.x += 1
	if Input.is_action_pressed("ui_left"):
		acceleration.x -= 1
	if Input.is_action_pressed("ui_up"):
		acceleration.y -= 1
	if Input.is_action_pressed("ui_down"):
		acceleration.y += 1
	if acceleration.length_squared() > 0:
		acceleration = acceleration.normalized() * acc*delta;
	velocity.x *= 50*delta;
	velocity.y *= 50*delta;
	velocity.x += acceleration.x;
	velocity.y += acceleration.y;
	look_at(get_global_mouse_position());
	velocity = move_and_slide(velocity, ZERO, false, 4, PI/4, false);
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			#collision.collider.apply_impulse(collision.position - collision.collider.position, -collision.normal * push)
			collision.collider.apply_central_impulse(-collision.normal * push)
	
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
			else: #play empty sound?
				$AnimComplex/Handgun.play("reload")
				$ReloadSound.play()
				handgun_shoot_finished = false;
		elif Input.is_action_just_pressed("reload"):
			$AnimComplex/Handgun.play("reload")
			$ReloadSound.play()
			handgun_shoot_finished = false;
	if Input.is_action_just_pressed("go_up"):
		if next_scene:
			get_node("/root/global").goto_scene(next_scene)
		elif nearby_holes>0:
			get_tree().get_current_scene().change_scene();

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
		$HitAnim.stop()
		can_melee = true;
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
			if body == self:
				continue
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
	#for body in $BlockArea.get_overlapping_bodies():
	#	if body is StaticBody2D or body is TileMap:
	#		return true;
	return false

func _on_HitAnim_animation_finished(anim_name):
	can_melee = true;


func portal_enter(next, portal_name):
	next_scene = next
	$HUD.message("PRESS SPACE TO JUMP TO %s"%portal_name)


func portal_exit(next, portal_name):
	next_scene = null
	$HUD.clear_message()
