extends Control

var mouseInSlider := false

func _on_mute_button_down() -> void:
	var wVolume := db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Ambience")))
	#print("VOLUMELINEAR: ", wVolume)
	var nVolume := 100
	if wVolume==0:
		nVolume=100
		$mute/Cancel.visible=false
	else:
		nVolume=0
		$mute/Cancel.visible=true
	functions.AMBIENCEV=nVolume
	functions.save_settings(false)	
	MusicController._volume(nVolume, "Ambience")
	$HBoxContainer/TextureProgress.value = nVolume
	
func _input(_event):
	if(mouseInSlider && Input.is_mouse_button_pressed((MOUSE_BUTTON_LEFT))):
		setValue($HBoxContainer/TextureProgress)
		var newvolume = int($HBoxContainer/TextureProgress.value)
#		functions.save_config=true
		if newvolume==0:
			$mute/Cancel.visible=true
		else:
			$mute/Cancel.visible=false
		functions.AMBIENCEV=newvolume
		MusicController._volume(newvolume, "Ambience")
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


func _ready() -> void:
	var wVolume := db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	if wVolume==0:
		$mute/Cancel.visible=true
	else:
		$mute/Cancel.visible=false
