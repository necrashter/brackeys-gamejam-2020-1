extends RigidBody2D

signal broken(position);

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("broken", get_node("/root/Combined"), "box_broken")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_hit(dmg):
	emit_signal("broken", position)
	queue_free();
