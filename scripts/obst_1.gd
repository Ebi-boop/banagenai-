extends TileMapLayer
@onready var player = get_tree().get_first_node_in_group("player")

@export var limit_x_offset : int

func _ready() -> void:
	print(player)


func _process(_delta: float) -> void:
	#If the player is too far
	if abs(player.position.x - position.x) >= limit_x_offset:
		#On the right?
		if position.x < player.position.x:
			position.x += limit_x_offset * 2 
		
		#On the left?
		elif position.x > player.position.x:
			position.x -= limit_x_offset * 2 
