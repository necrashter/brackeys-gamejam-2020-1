extends Node

const spawnTimes = [0.0, 2.0, 4.0, 6.0]
var spawnIndex = 0
const shieldTime = 0.0
var shielded = false

func start():
	spawnIndex = 0
	shielded = false
	owner.start_magic();
	
func update(time):
	time = fmod(time, 8.0)
	if abs(time-shieldTime) <0.08:
		if not shielded:
			owner.reshield()
			shielded = true
	else:
		shielded = false
	if abs(time-spawnTimes[spawnIndex])<0.08:
		owner.spawn_holizard(1);
		spawnIndex = (spawnIndex+1)%spawnTimes.size();
