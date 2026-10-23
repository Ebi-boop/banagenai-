extends Node
@onready var level = get_tree().get_first_node_in_group("level")

const WAITING = 1

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


#Called when an area enters this area
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_area"):
		await get_tree().create_timer(WAITING).timeout
		level.now_ending = true
