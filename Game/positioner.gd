extends Node2D
@onready var rootAction= get_parent()


func _ready() -> void:
	if functions.whereIWas=="hall":
		rootAction.room_pos_init=Vector2(740, 0)
	if functions.whereIWas.contains("bath"):
		rootAction.room_pos_init=Vector2(-740, 0)
