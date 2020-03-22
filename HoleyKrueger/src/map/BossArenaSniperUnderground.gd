extends "res://src/map/UnderGroundSketch.gd"

var battle_started = false;
const SniperBoss = preload("res://src/enemy/Sniper.tscn")
const Holizard = preload("res://src/SniperHolizard.tscn")

const Bandage =   preload("res://src/items/Bandage.tscn")

var sniper;

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-40,40):
		for y in range(-40,40):
			if $TileMap.get_cell(x,y) >= 0:
				$ShadowTiles.set_cell(x,y,0);


func endBoss():
	$AnimationPlayer.play("end")
	get_parent().get_node("AnimationPlayer").play("end")

func beginBoss():
	battle_started = true
	$TileMap.set_cell(0, 17, 1)
	$TileMap.set_cell(-1, 17, 1)
	$ShadowTiles.set_cell(0,17,0)
	$ShadowTiles.set_cell(-1,17,0)
	sniper = SniperBoss.instance()
	sniper.position = $SniperPos0.position
	sniper.music = $BossMusic;
	sniper.connect("die", self, "endBoss");
	sniper.get_node("StateMachine").connect("phase_up", self, "switchPhase");
	add_child(sniper)
	$BossMusic.play()
	$BossMusic2.play()

func switchPhase():
	$BossMusic.volume_db = -80
	$BossMusic2.volume_db = -5
	# set sniper.music = $BossMusic2 ?

func spawn_holizard(pos, target ):
	var h=Holizard.instance();
	h.position= pos
	if target.get_ref():
		h._on_Sense_body_entered(target.get_ref());
	h.connect("die", self, "holizard_death");
	add_child(h);

func holizard_death(pos):
	if randi()%4==0:
		var b = Bandage.instance()
		b.position = pos
		add_child(b)

func _on_ArenaArea_body_entered(body):
	if body.is_in_group("player"):
		beginBoss()
		$ArenaArea.queue_free()
