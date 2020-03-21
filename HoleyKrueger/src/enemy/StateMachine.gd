extends Node

signal phase_up;

const states = ["verse0", "spawner0"]
const transitionTimes = [0.0, 16.0]

var states_map;
var current_state;
var next_index = 0
var states_map_phase1;
var states_map_phase2;

var phase_up_now = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	states_map_phase1 = {
		"verse0" : $Verse0,
		"spawner0": $Spawner0,
	}
	states_map_phase2 = {
		"verse0" : $Verse0Angry,
		"spawner0": $Spawner0Angry,
	}
	if get_parent().phase==1:
		states_map=states_map_phase1
	else:
		states_map=states_map_phase2
	set_state(states[0])
	next_index = 1

# custom update function, which takes song time as a parameter
func update(time):
	if abs(time - transitionTimes[next_index])<0.1:
		if phase_up_now:
			emit_signal("phase_up")
			phase_up_now = false;
		set_state(states[next_index])
		next_index = (next_index+1) % states.size()
	current_state.update(time)


func set_state(state):
	current_state = states_map[state]
	current_state.start()

func phase_up():
	states_map = states_map_phase2
	phase_up_now = true
