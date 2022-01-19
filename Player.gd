extends Area2D

class_name Player, "res://art/playerGrey_walk2.png"

signal hit

export var speed = 400 # how fast the player will move in pixels/sec
var screen_size # size of the game window
var target := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _input(event):
	if event is InputEventScreenTouch && event.pressed:
#		print('input event: %s' % event.as_text())
		target = event.position
	if event is InputEventScreenDrag:
		target = event.position
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity := Vector2() # The player's movement vector
	velocity = apply_input(velocity)
	move(velocity, delta)
	animate(velocity)
#	print("vel: %d, %d" % [velocity.x, velocity.y]) 
#	update()

#func _draw():
#	draw_line(Vector2(0, 0), target - position, Color.red, 5)

func apply_input(velocity := Vector2()):
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if position.distance_to(target) > 10 and velocity.length() == 0:
		velocity = target - position
	else:
		target = position
	return velocity

func move(velocity, delta):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func animate(velocity):
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	target = pos
	$Trail.restart()
	show()
	$CollisionShape2D.disabled = false
