extends CharacterBody2D

const SPEED = 100
var last_dir = Vector2.ZERO

func _physics_process(delta: float) -> void:
	player_movement(delta)
	
func player_movement(delta: float):
	var is_moving = true
	var current_dir = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		current_dir = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		current_dir = Vector2.LEFT
	elif Input.is_action_pressed("ui_up"):
		current_dir = Vector2.UP
	elif Input.is_action_pressed("ui_down"):
		current_dir = Vector2.DOWN
	else:
		is_moving = false
		
	if is_moving:
		last_dir = current_dir
		
	velocity = current_dir * SPEED
	play_anim(is_moving, last_dir)
	move_and_slide()

func play_anim(is_moving: bool, current_dir: Vector2):
	var anim = $AnimatedSprite2D
	if current_dir == Vector2.UP:
		if is_moving:
			anim.play(&"walk_back")
		else:
			anim.play(&"idle_back")
	elif current_dir == Vector2.DOWN:
		if is_moving:
			anim.play(&"walk_front")
		else:
			anim.play(&"idle_front")
	else:
		anim.flip_h = current_dir == Vector2.LEFT
		if is_moving:
			anim.play(&"walk_side")
		else:
			anim.play(&"idle_side")
