extends Node2D
@onready var player = get_tree().get_first_node_in_group("player")

var playing = GameState.playing
var lost = GameState.lost
var start_timer_started : bool = false
var speed : float 
var acceleration : bool = false
@export var final_speed : float

const INITIAL_SPEED : int = 2
const ACCELERATION_STEP : float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Actualizing global variables
	playing = GameState.playing
	lost = GameState.lost
	
	if playing != true:
		return
	
	if lost == true:
		return
	
	start_acceleration_timer()
	update_speed()
	moving(delta)


#Starting a timer that will then start the acceleration process
func start_acceleration_timer() -> void:
	#Setting a timer, when finished, speed goes to original.
	if start_timer_started != true:
		start_timer_started = true
		await get_tree().create_timer(1.7).timeout
		acceleration = true


#Updating the speed frame per frame for a better transition
func update_speed() -> void:
	if speed < final_speed and acceleration == true:
		speed = move_toward(
			speed,
			final_speed,
			ACCELERATION_STEP
		)


#Changing the position * delta
func moving(delta: float) -> void:
	position.y += speed * delta
	position.x = player.position.x - $Sprite2D.scale.x / 2


#If the player gets caught
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_area"):
		GameState.lost = true
		GameState.finished = true
