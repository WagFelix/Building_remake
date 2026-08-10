extends Area2D
@export var preloadScene := "res://Game/Hall/Hall.tscn"
@export var backSound := "res://SFX/door.mp3"
@onready var parentNode := get_parent()

@export var parentLevel :=2

var mouse_pos = Vector2(0,0)


func _ready() -> void:
	for i in range(0, parentLevel):
		if i>=1:
			parentNode=parentNode.get_parent()
	#elif parentLevel==2:
		#parentNode= get_parent().get_parent()
	#elif parentLevel==3:
		#parentNode= get_parent().get_parent().get_parent()
	#elif parentLevel==4:
		#parentNode= get_parent().get_parent().get_parent().get_parent()
	print(self.name, " ---PARENT: ", parentNode.name)	
	
	
func _on_door_input_event(_viewport: Node, event: InputEvent, _shape_idx: int, alternativeOutColor=false) -> void:
	#print("PORTA")
	if (event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT && parentNode.tdown.is_stopped() && parentNode.stopscene==false ):
		var dist = mouse_pos-get_viewport().get_mouse_position()
		var distx = abs(dist.x)
		var disty = abs(dist.y)
		print("DISTANCIA ", dist)
#		if mouse_pos==get_viewport().get_mouse_position():
		if distx<15 and disty<15:
			print("TROCASALA")
			MusicController.playSFX(backSound)
			if alternativeOutColor==true:
				parentNode.outColor=parentNode.alternativeOutColor #no building 2 é pra diferenciar a cor da saida para o corredor
			parentNode.tweenChange(preloadScene)

		mouse_pos = get_viewport().get_mouse_position()
