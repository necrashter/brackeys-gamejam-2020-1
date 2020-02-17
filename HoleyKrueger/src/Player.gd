extends KinematicBody2D



export var speed =10;
var velocity;

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2();


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
	move_and_collide(velocity);
