extends CharacterBody2D

const SPEED = 100
var current_dir = "none"

func _physics_process(delta: float) -> void:
	player_movement(delta)
	
func player_movement(delta: float):
	
	velocity.x = 0
	velocity.y = 0
	if Input.is_action_pressed("ui_right"):		
		play_anim(true)
		current_dir = "right"
		velocity.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		play_anim(true)
		current_dir = "left"
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_up"):
		play_anim(true)
		current_dir = "up"
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		play_anim(true)
		current_dir = "down"
		velocity.y = SPEED
	else:
		play_anim(false)	
	move_and_slide()

func play_anim(is_moving: bool):
	var anim = $AnimatedSprite2D
	anim.flip_h = false	
	
	if current_dir == "up":
		if is_moving:
			anim.play("walk_back")
		else:
			anim.play("idle_back")
	elif current_dir == "down":
		if is_moving:
			anim.play("walk_front")
		else:
			anim.play("idle_front")
	else:
		anim.flip_h = current_dir == "left"
		if is_moving:
			anim.play("walk_side")
		else:
			anim.play("idle_side")
