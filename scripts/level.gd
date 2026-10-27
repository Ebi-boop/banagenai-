extends Node
@onready var player = $Player
@onready var StormClouds = $StormClouds
@onready var camera = $Player/Camera2D
@onready var ending = $Ending
@onready var PartsContainer = $PartsContainer
@onready var background = $BG
@onready var blueBG = $BG/BlueBG
@onready var end_screen = $EndScreen

#Setting the level parts
@export var parts : Array[PackedScene]
@export var ending_y : float
@export var odd_offset : float

#Constants
const BG_OFFSET_END = 3000
const bg_size_y = 13394 #I calculated it by additioning both backgrounds' size.y   *DO NOT CHANGE*

#Globals
var playing = GameState.playing

#Initial part position
var part
var part_y = 300
var part_y_jump = 500
var part_x = -1300
var part_x_jump = 600
var x_offset_randomizer : float 

#Ending
var losing_animation : bool = false
var now_ending : bool = false
var ending_camera_x = 850


#Background
var got_bg_position : bool = false
var initial_bg_y : float
var initial_player_y : float



#Manage the generation of the parts, called in "func _ready()"
func spawn_parts():
	#Generating the rows of part
	var rows = (ending_y - 600.0) / part_y_jump
	for j in range(rows):
		for i in parts:
			part = i.instantiate()
			PartsContainer.add_child(part)
			
			part.position = Vector2(part_x, part_y)
			part_x += part_x_jump
		
		#Setting the values for next spawn
		if odd_offset > 0 and j % 2 != 0:
			x_offset_randomizer = randf_range(-250, 250)
			part_x = -1000 + odd_offset + x_offset_randomizer
		else:
			part_x = -1000
		
		part_y += part_y_jump
		
		
		#Changing order 
		var shuffled_part = parts[0]
		parts.remove_at(0)
		parts.append(shuffled_part)


#Called the first frame of the scene.
func _ready() -> void:
	GameState.playing = false
	GameState.lost = false
	GameState.finished = false
	
	player.position = Vector2(0, 0)
	ending.position = Vector2(0, ending_y)
	
	#Backgrounds position
	background.position.y = ending_y - (bg_size_y - BG_OFFSET_END)
	
	#The additionnal 1000 is for the camera
	var needed_size = 0 + 1000 + background.position.y
	#Make the blue background bigger so the whole layout is covered
	blueBG.size.y += needed_size
	blueBG.position.y -= needed_size
	

	
	spawn_parts()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Actualize variables
	playing = GameState.playing
	
	#Manage entities positions
	background.position.x = player.position.x - background.size.x / 2
	
	if ending.position.y - player.position.y >= 500:
		ending.position.x = player.position.x
	
	
	#To start the run
	if Input.is_action_just_pressed("ui_accept") and playing != true:
		print("Let's go!")
		playing = true
		GameState.playing = true
		
		$Starting.hide()
	
	#Manage ending
	if now_ending == true:
		background_follows_player()
		ending_camera_offset()
		manage_ending_screen()
		GameState.finished = true


#The camera does a transition at the end
func ending_camera_offset():
	camera.offset.x = move_toward(
			camera.offset.x, 
			ending_camera_x, 
			8)


#Manages the apparition of the ending screen
func manage_ending_screen():
	if camera.offset.x == ending_camera_x:
		end_screen.visible = true



#The background follows the player after the end
func background_follows_player():
	if not got_bg_position:
		initial_player_y = player.position.y
		initial_bg_y = background.position.y
		got_bg_position = true
	else:
		background.position.y = initial_bg_y + (player.position.y - initial_player_y)


#After the timer and the player lost, now transition towards end
func ready_for_lost():
	losing_animation = true
