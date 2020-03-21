extends Node

const randTeleportTime = 0.0;
const shootTimes = [0.0, 1.0, 2.0, 3.0, 3.5];
var shootIndex = 0
const teleportTimes = [0.5, 1.5, 2.5];
var teleportIndex = 0

var teleported = false;

func start():
	shootIndex = 0
	teleportIndex = 0
	teleported = false
	owner.stop_anim()

func update(time):
	time = fmod(time, 4.0)
	if abs(time - randTeleportTime) < 0.08:
		if not teleported:
			owner.rand_teleport();
			teleported = true
	else:
		teleported = false;
	if abs(time - shootTimes[shootIndex]) <0.08:
		# owner refers to the node that this node is saved along with
		# in this case, it is Sniper
		owner.shoot_3();
		shootIndex = (shootIndex+1)%shootTimes.size();
	if abs(time - teleportTimes[teleportIndex]) < 0.08:
		if randi()%2:
			owner.step_forward()
		owner.step_sideways()
		teleportIndex = (teleportIndex+1)%teleportTimes.size();
