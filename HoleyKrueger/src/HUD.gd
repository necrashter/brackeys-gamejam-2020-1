extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_ammo(ammo):
	$AmmoLabel.text = "AMMO: "+str(ammo);

func update_health(hp):
	$HealthLabel.text = "HEALTH: "+str(hp);
	
func update_kills(kills):
	$KillLabel.text =  "KILLS: "+str(kills);
