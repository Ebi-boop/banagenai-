extends CanvasLayer
@onready var timer = $Timer
@onready var time_label = $Control/VBoxContainer/Label

var time : float = 0
var timer_started : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameState.playing == true and GameState.finished != true:
		visible = true
		
		time = snappedf(time, 0.1)
		GameState.time = time
		
		if timer_started != true:
			timer.start()
			timer_started = true
		
		time_label.text = "Time: " + str(time) + "s"
	
	else:
		visible = false


func _on_timer_timeout() -> void:
	time += timer.wait_time
	
	if GameState.finished != true:
		timer.start()
