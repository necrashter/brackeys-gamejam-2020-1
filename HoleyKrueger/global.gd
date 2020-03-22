extends Node

var current_scene = null

# the damage taken by the player will be multiplied by this
var take_damage_mul = 1.0;
# the damage the player will deliver will be multiplied by this
var hit_damage_mul = 1.0;

var postCredits;

func _ready():
		var root = get_tree().get_root()
		current_scene = root.get_child(root.get_child_count() -1)

func jump_scene(Scene):
	call_deferred("_deferred_jump_scene", Scene)

func goto_scene(Scene):
	# This function will usually be called from a signal callback,
	# or some other function from the running scene.
	# Deleting the current scene at this point might be
	# a bad idea, because it may be inside of a callback or function of it.
	# The worst case will be a crash or unexpected behavior.

	# The way around this is deferring the load to a later time, when
	# it is ensured that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", Scene)


func _deferred_goto_scene(Scene):
	var player = current_scene.player
	current_scene.remove_child(player);
	current_scene.player = null
	# Immediately free the current scene,
	# there is no risk here.
	current_scene.free()
	
	# Instance the new scene.
	current_scene = Scene.instance()
	current_scene.player =player;
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)


func _deferred_jump_scene(Scene):
	# Immediately free the current scene,
	# there is no risk here.
	current_scene.free()
	
	# Instance the new scene.
	current_scene = Scene.instance()
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
