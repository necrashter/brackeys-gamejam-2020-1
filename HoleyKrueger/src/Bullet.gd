extends Area2D


var damage = 5;
var speed = 4000;
var velocity = Vector2();

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.x = speed;

func shoot(pos, rot):
	rotation = rot;
	position = pos;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity.rotated(rotation) * delta;


func _on_Bullet_body_entered(body):
	if body.is_in_group("fragile"):
		body.get_hit(damage);
		queue_free();
	elif body is StaticBody2D or body is TileMap:
		queue_free()
