extends Control

func _ready() -> void:
	self.visible=false
	#self.global_position.x=(functions.viewport_size.x)-300
	#self.global_position.y=100
	
func _on_button_down() -> void:
	pass
	#Map.mostra(true)
	

func mostra(mostrar=true) -> void:
	self.visible=mostrar
