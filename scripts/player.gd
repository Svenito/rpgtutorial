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

enum States {IDLE, MOVING, ATTACKING, DYING}
var state: States = States.IDLE

func _physics_process(delta: float) -> void:
	player_movement(delta)
	
func player_movement(delta: float):
	var is_moving = true
	var current_dir = Vector2.ZERO
	state = States.MOVING
	if Input.is_action_pressed(&"ui_right"):
		current_dir = Vector2.RIGHT
	elif Input.is_action_pressed(&"ui_left"):
		current_dir = Vector2.LEFT
	elif Input.is_action_pressed(&"ui_up"):
		current_dir = Vector2.UP
	elif Input.is_action_pressed(&"ui_down"):
		current_dir = Vector2.DOWN
	else:
		state = States.IDLE
	
	if current_dir != Vector2.ZERO:
		last_dir = current_dir
		
	velocity = current_dir * SPEED
	play_anim(last_dir)
	move_and_slide()

func play_anim(current_dir: Vector2):
	var anim = $AnimatedSprite2D
	if state == States.MOVING:
		anim.flip_h = WALK_ANIMATIONS[current_dir].get("flip", false)
		anim.play(WALK_ANIMATIONS[current_dir]["anim"])
	elif state == States.IDLE:
		anim.flip_h = IDLE_ANIMATIONS[last_dir].get("flip", false)
		anim.play(IDLE_ANIMATIONS[last_dir]["anim"])

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
