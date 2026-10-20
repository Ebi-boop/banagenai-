extends Node
@onready var player = $Player
@onready var ending = $Ending
@onready var PartsContainer = $PartsContainer

#Setting the level parts
@export var parts : Array[PackedScene]


var playing = GameState.playing
var part_y = 300
var part_x = -500

func spawn_parts():
	for i in parts:
		print("Hello")
		var part = i.instantiate()
		PartsContainer.add_child(part)
		
		part.position = Vector2(part_x, part_y)
		part_x += 200
	part_x = 300
	part_y += 400

#Called the first frame of the scene.
func _ready() -> void:
	player.position = Vector2(0, 0)
	ending.position = Vector2(0, 25000)
	
	spawn_parts()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#To start the run
	if Input.is_action_just_pressed("ui_accept") and playing != true:
		playing = true
		GameState.playing = true
		
		$Starting.hide()
