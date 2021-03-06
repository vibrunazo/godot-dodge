extends Node

export (PackedScene) var Mob
var score = 0
var mob_count = 0
var cooldown = 2.0

func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# on player hit
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	mob_count = 0
	cooldown = 2.0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Music.play()

func _on_StartTimer_timeout():
	print('start timer')
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	cooldown -= 0.04 if cooldown > 1.4 else 0.02 if cooldown > 0.9 else 0.005 
	$MobTimer.wait_time = clamp(cooldown, 0.25, 2)
	print('mob timer: %f' % $MobTimer.wait_time)
	# Choose a random location on Path2D
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene
	var mob = Mob.instance() as Mob
	add_child(mob)
	mob_count += 1
		
	if (mob_count % 4 == 0):
		print('mob seek')
		var vel := Vector2()
		vel = $Player.position - mob.position
		vel = vel.normalized() * rand_range(mob.min_speed, mob.max_speed)
		mob.linear_velocity = vel
		mob.rotation = vel.angle()
	else:
		print('mob dumb')
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
