extends "res://src/map/UnderGroundSketch.gd"

var battle_started = false;
const SniperBoss = preload("res://src/enemy/Sniper.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-40,40):
		for y in range(-40,40):
			if $TileMap.get_cell(x,y) >= 0:
				$ShadowTiles.set_cell(x,y,0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func beginBoss():
	battle_started = true
	$TileMap.set_cell(0, 17, 1)
	$TileMap.set_cell(-1, 17, 1)
	$ShadowTiles.set_cell(0,17,0)
	$ShadowTiles.set_cell(-1,17,0)
	var sniper = SniperBoss.instance()
	sniper.position = $SniperPos0.position
	add_child(sniper)
	# TODO: add boss music


func _on_ArenaArea_body_entered(body):
	if body.is_in_group("player"):
		beginBoss()
		$ArenaArea.queue_free()
