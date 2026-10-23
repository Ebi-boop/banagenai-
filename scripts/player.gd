extends CharacterBody2D
@onready var animation = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_VELOCITY_Y = 2000

var playing
var flipped : bool = false

func _physics_process(delta: float) -> void:
	if GameState.playing == true:
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		#Handle direction
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		#Apply max vertical speed
		if velocity.y > MAX_VELOCITY_Y:
			velocity.y = MAX_VELOCITY_Y

		#Handles animation
		if is_on_floor():
			if velocity.x != 0:
				animation.play("Run")
			else:
				animation.play("Idle")
		else:
			if velocity.y < 0:
				animation.play("Jump")
			else:
				animation.play("Fall")
		
		#handles character flipping
		if velocity.x < 0:
			flipped = true
		
		elif velocity.x > 0:
			flipped = false
		
		if flipped == true:
			animation.flip_h = true
		else:
			animation.flip_h = false

		move_and_slide()
	
	playing = GameState.playing
