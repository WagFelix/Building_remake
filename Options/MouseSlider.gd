extends Control

var mouseInSlider := false


func _input(_event):
	if(mouseInSlider && Input.is_mouse_button_pressed((MOUSE_BUTTON_LEFT))):
		setValue($HBoxContainer/TextureProgress)
		var newSens = int($HBoxContainer/TextureProgress.value)
		
		newSens = ((newSens*0.075)/100)+.025
		
		
	
		
		
		functions.scrollSens=newSens
		functions.save_settings(false)

func setValue(slider):
	slider.value = ratioInBody(slider) * slider.max_value
	

func ratioInBody(slider):
	var posClicked = get_local_mouse_position() - slider.position
	var ratio = posClicked.x/slider.size.x
	if (ratio>1):
		ratio = 1
	elif (ratio<0):
		ratio=0
	return ratio 
		


func _on_TextureProgress_mouse_entered():
	mouseInSlider = true


func _on_TextureProgress_mouse_exited():
	mouseInSlider = false
