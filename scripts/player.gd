extends CharacterBody2D

const SPEED = 100
var last_dir = Vector2.ZERO

var enemy_in_range = false
var enemy_attack_cooldown = false
var health = 100
var alive = true
var attacking = false

const WALK_ANIMATIONS = {
	Vector2.UP: {"anim": "walk_back"}, 
	Vector2.DOWN: {"anim": "walk_front"},
	Vector2.LEFT: {"anim": "walk_side", "flip": true}, 
	Vector2.RIGHT: {"anim": "walk_side"},
	Vector2.ZERO: {"anim": "walk_side"}
	}
const IDLE_ANIMATIONS = {
	Vector2.UP: {"anim": "idle_back"},
	Vector2.DOWN: {"anim": "idle_front"},
	Vector2.LEFT: {"anim": "idle_side", "flip": true}, 
	Vector2.RIGHT: {"anim": "idle_side"},
	Vector2.ZERO: {"anim": "idle_side"}
	}
	
const ATTACK_ANIMATIONS = {
	Vector2.UP: {"anim": "attack_back"},
	Vector2.DOWN: {"anim": "attack_front"},
	Vector2.LEFT: {"anim": "attack_side", "flip": true},  
	Vector2.RIGHT: {"anim": "attack_side"},
	Vector2.ZERO: {"anim": "attack_side"}
	}

enum States {IDLE, MOVING, ATTACKING, DYING}
var state: States = States.IDLE
var previous_state = state

func _physics_process(delta: float) -> void:
	if state != States.ATTACKING:
		move_and_slide()

func _process(delta: float) -> void:
	play_anim(last_dir)

func _input(event: InputEvent) -> void:
	player_movement(event)
	
func player_movement(event):
	var current_dir = Vector2.ZERO	
	if Input.is_action_just_pressed(&"attack"):
		if state != States.ATTACKING:
			previous_state = state
			state = States.ATTACKING
	elif Input.is_action_pressed(&"ui_right"):
		if state == States.IDLE:
			state = States.MOVING
		current_dir = Vector2.RIGHT
	elif Input.is_action_pressed(&"ui_left"):
		if state == States.IDLE:
			state = States.MOVING
		current_dir = Vector2.LEFT
	elif Input.is_action_pressed(&"ui_up"):
		if state == States.IDLE:
			state = States.MOVING
		current_dir = Vector2.UP
	elif Input.is_action_pressed(&"ui_down"):
		if state == States.IDLE:
			state = States.MOVING
		current_dir = Vector2.DOWN
	else:
		if state != States.ATTACKING:
			state = States.IDLE
	
	if current_dir != Vector2.ZERO && state != States.ATTACKING:
		last_dir = current_dir
	
	velocity = current_dir * SPEED
	
func play_anim(current_dir: Vector2):
	var anim = $AnimatedSprite2D
	if state == States.MOVING:
		anim.flip_h = WALK_ANIMATIONS[current_dir].get("flip", false)
		anim.play(WALK_ANIMATIONS[current_dir]["anim"])
	elif state == States.IDLE:
		anim.flip_h = IDLE_ANIMATIONS[last_dir].get("flip", false)
		anim.play(IDLE_ANIMATIONS[last_dir]["anim"])
	elif state == States.ATTACKING:
		anim.flip_h = ATTACK_ANIMATIONS[last_dir].get("flip", false)
		anim.play(ATTACK_ANIMATIONS[last_dir]["anim"])
		

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "enemy":
		enemy_in_range = true

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.name == "enemy":
		enemy_in_range = false

func _on_enemy_attack(damage: int) -> void:
	health -= damage
	print("Player health: ", health)
	if health <= 0:
		alive = false
		health = 0 
		print("YOU HAVE DIED")
		self.queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	print($AnimatedSprite2D.animation)
	if $AnimatedSprite2D.animation.begins_with("attack_"):
		state = previous_state
