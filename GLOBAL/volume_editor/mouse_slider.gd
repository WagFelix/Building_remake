extends Control

var mouseInSlider := false
@onready var parentNode := get_parent().get_parent()

	
	
func _input(_event):
	if(mouseInSlider && Input.is_mouse_button_pressed((MOUSE_BUTTON_LEFT))):
		setValue($HBoxContainer/TextureProgress)
		var newvolume = int($HBoxContainer/TextureProgress.value) / $HBoxContainer/TextureProgress.max_value
		parentNode.gravaVolume(newvolume)
		


func setValue(slider):
	slider.value = ratioInBody(slider) * slider.max_value
	

func ratioInBody(slider):
	var posClicked = get_local_mouse_position() - slider.position
	print("TAMANHOOOOOOOOOOOOOOOOO" , slider.size.x, " - ", posClicked.x)
	var ratio = (posClicked.x)/slider.size.x
	if (ratio>.96):
		ratio = 1
	elif (ratio<0.05):
		ratio=0
	return ratio 
		


func _on_TextureProgress_mouse_entered():
	mouseInSlider = true
	

func _on_TextureProgress_mouse_exited():
	mouseInSlider = false
	
