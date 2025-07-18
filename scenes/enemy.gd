extends CharacterBody2D

var speed = 45
var chasing = false
var player = null
var last_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var direction = direction_to_player()
	var anim = $AnimatedSprite2D
	if chasing:
		position += (player.position - position) / speed
		last_direction = direction
	
		if direction == Vector2.UP:
			anim.play(&"walk_back")
		elif direction == Vector2.DOWN:
			anim.play(&"walk_front")
		else:
			anim.flip_h = direction == Vector2.LEFT
			anim.play(&"walk_side")
	else:
		if last_direction == Vector2.UP:
			anim.play(&"idle_back")
		elif last_direction == Vector2.DOWN:
			anim.play(&"idle_front")
		else:
			anim.flip_h = direction == Vector2.LEFT
			anim.play(&"idle_side")
	move_and_slide()
	
func direction_to_player() -> Vector2:	
	if not player:
		return Vector2.ZERO
	
	var movement = Vector2.ZERO
	var distances = Vector2(position.x - player.position.x, position.y - player.position.y)

	if abs(distances.x) > abs(distances.y):
		if distances.x < -2:
			movement = Vector2.RIGHT
		elif distances.x > 2:
			movement = Vector2.LEFT
	else:
		if distances.y > 2:
			movement = Vector2.UP
		elif distances.y < -2:
			movement = Vector2.DOWN
	return movement
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	chasing = true	

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	chasing = false
