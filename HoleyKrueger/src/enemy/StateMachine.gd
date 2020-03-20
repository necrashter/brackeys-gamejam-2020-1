extends Node

const states = ["verse0", "spawner0"]
const transitionTimes = [0.0, 16.0]

var states_map;
var current_state;
var next_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	states_map = {
		"verse0" : $Verse0,
		"spawner0": $Spawner0,
	}
	set_state(states[0])
	next_index = 1

# custom update function, which takes song time as a parameter
func update(time):
	if abs(time - transitionTimes[next_index])<0.1:
		set_state(states[next_index])
		next_index = (next_index+1) % states.size()
	current_state.update(time)


func set_state(state):
	current_state = states_map[state]
	current_state.start()
