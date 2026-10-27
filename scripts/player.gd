extends CharacterBody2D
@onready var animation = $AnimatedSprite2D
@onready var level = get_tree().get_first_node_in_group("level")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_VELOCITY_Y = 2000

var playing = GameState.lost
var finished = GameState.lost
var flipped : bool = false


func _physics_process(delta: float) -> void:
	if GameState.playing == true:
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		#Apply max vertical speed
		if velocity.y > MAX_VELOCITY_Y:
			velocity.y = MAX_VELOCITY_Y

		#Can't do stuff if lost
		if finished != true:
			anim()
			action_managing()
		
		else:
			lost_managing(delta)

		move_and_slide()

	playing = GameState.playing
	finished = GameState.finished


func action_managing():
	#Handle direction
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


func anim():
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


func lost_managing(delta):
	if is_on_floor():
		animation.rotation = 0
		velocity = Vector2.ZERO
		animation.play("Cooked")
		
		await get_tree().create_timer(1.0).timeout
		level.now_ending = true

	else:
		animation.play("Fall")
		animation.rotation += 8 * delta
