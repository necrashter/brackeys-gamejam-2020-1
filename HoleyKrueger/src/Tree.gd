extends Area2D

export (Color) var default;
export (Color) var opacity;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Tree_body_entered(body):
	if body.is_in_group("seer"):
		$Sprite.modulate = opacity;


func _on_Tree_body_exited(body):
	if body.is_in_group("seer"):
		$Sprite.modulate = default;
