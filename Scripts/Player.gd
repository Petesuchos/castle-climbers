extends CharacterBody2D

@export var speed = 100
@export var gravity = 200
@export var jump_height = -100

var is_attacking = false
var is_clibming = false

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	horizontal_movement()
	if !is_attacking:
		player_animations()
	move_and_slide()

func horizontal_movement() -> void:
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * speed

func player_animations() -> void:
	if Input.is_action_pressed("ui_left") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 7
		
	if Input.is_action_pressed("ui_right") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = -7
		
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")
	
# singular input captures
func _input(event):
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		$AnimatedSprite2D.play("attack")
	
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")

	if is_clibming:
		if event.is_action_pressed("ui_climb"):
			$AnimatedSprite2D.play("climb")
			gravity = 100
			velocity.y = -200
		else:
			gravity = 200
			is_clibming = false	


func _on_animated_sprite_2d_animation_finished() -> void:
	is_attacking = false
