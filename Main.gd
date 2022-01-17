extends Node

export (PackedScene) var Mob
var score = 0

func _ready():
	randomize()
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# on player hit
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	print("game over")

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_StartTimer_timeout():
	print('start timer')
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	print("score: %d" % score)

func _on_MobTimer_timeout():
	$MobTimer.wait_time = clamp(2 - score * 0.02, 0.4, 2)
	print('mob timer: %f' % $MobTimer.wait_time)
	# Choose a random location on Path2D
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene
	var mob = Mob.instance() as Mob
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the Velocity (speed & direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
