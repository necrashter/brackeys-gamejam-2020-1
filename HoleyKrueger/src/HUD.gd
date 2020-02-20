extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_ammo_text(t):
	$AmmoLabel.text = t;

func update_ammo(ammo, total):
	$AmmoLabel.text = "AMMO: "+str(ammo)+"/"+str(total);

func update_health(hp):
	$HealthLabel.text = "HEALTH: "+str(hp);
	
func update_kills(kills):
	$KillLabel.text =  "KILLS: "+str(kills);
