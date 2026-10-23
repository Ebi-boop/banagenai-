extends Node
@onready var player = $Player
@onready var StormClouds = $StormClouds
@onready var camera = $Player/Camera2D
@onready var ending = $Ending
@onready var PartsContainer = $PartsContainer
@onready var BlueBG = $BlueBG
@onready var GreenBG = $GreenBG

#Setting the level parts
@export var parts : Array[PackedScene]
@export var ending_y : float
@export var odd_offset : float


var playing = GameState.playing

var part_y = 300
var part_x = -1000

var now_ending : bool = false
var ending_screen = preload("res://scenes/end_screen.tscn")
var ending_camera_x = 850

#Manage the generation of the parts, called in "func _ready()"
func spawn_parts():
	#Generating the first row
	for j in range(16):
		for i in parts:
			var part = i.instantiate()
			PartsContainer.add_child(part)
			
			part.position = Vector2(part_x, part_y)
			part_x += 400
		
		#Setting the values for next spawn
		if odd_offset > 0 and j % 2 == 0:
			part_x = -1000 + odd_offset
		else:
			part_x = -1000
			
		part_y += 600
		
		#Changing order 
		var shuffled_part = parts[0]
		parts.remove_at(0)
		parts.append(shuffled_part)


#Called the first frame of the scene.
func _ready() -> void:
	player.position = Vector2(0, 0)
	ending.position = Vector2(0, ending_y)
	
	spawn_parts()


#Manage the ending, sent by the script of "ending"
func end():
	now_ending = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#To start the run
	if Input.is_action_just_pressed("ui_accept") and playing != true:
		playing = true
		GameState.playing = true
		
		$Starting.hide()
	
	#Manage the ending
	if now_ending == true:
		camera.offset.x = move_toward(
			camera.offset.x, 
			ending_camera_x, 
			8)
		
		#We had the ending screen after the camera moved
		if camera.offset.x == 800:
			var scene = ending_screen.instantiate()
			add_child(scene)
	
	#Manage entities positions
	BlueBG.position.x = player.position.x - BlueBG.size.x / 2
	GreenBG.position.x = player.position.x - GreenBG.size.x / 2
	ending.position.x = player.position.x
