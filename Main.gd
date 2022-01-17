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
	print('mob timing')
	
