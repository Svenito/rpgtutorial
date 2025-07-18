extends CharacterBody2D

var speed = 45
var chasing = false
var player = null

func _physics_process(delta: float) -> void:
	var movement = direction_to_player()
	if chasing:
		position += (player.position - position) / speed

		if movement == Vector2.UP:
			$AnimatedSprite2D.play(&"walk_back")
		elif movement == Vector2.DOWN:
			$AnimatedSprite2D.play(&"walk_front")
		elif movement == Vector2.LEFT:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play(&"walk_side")
		elif movement == Vector2.RIGHT:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play(&"walk_side")
	else:
		if movement == Vector2.UP:
			$AnimatedSprite2D.play(&"idle_back")
		elif movement == Vector2.DOWN:
			$AnimatedSprite2D.play(&"idle_front")
		elif movement == Vector2.LEFT:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play(&"idle_side")
		elif movement == Vector2.RIGHT:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play(&"idle_side")
	move_and_slide()
	
func direction_to_player() -> Vector2:	
	var movement = Vector2.ZERO
	if not player:
		return movement
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
