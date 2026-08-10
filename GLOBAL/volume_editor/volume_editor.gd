extends Node2D
var lastSound := ""
var soundfile := ""



@onready var musicslider := $Panel/MouseSlider/HBoxContainer/TextureProgress


func _ready() -> void:
	self.visible=false

func mostra(qSound, cVolume, tipo="sfx"):
	
	musicslider.value = cVolume * musicslider.max_value
	print("VOLUMESLIDER: ", cVolume, " - ", tipo)
	var slices = qSound.get_slice_count("/")
	soundfile = qSound.get_slice("/", slices-1)
	lastSound=qSound
	$Panel/Sound.text=soundfile

func gravaVolume(qVolume):
	var _loadOK = MusicController.volumeCFG.load(MusicController.SAVE_VOLUME)
	print("GRAVA: ", qVolume)
	#MusicController.volumeCFG.get_value(tipo, soundfile) 
	MusicController.volumeCFG.set_value("sfx", soundfile, qVolume)
	MusicController.volumeCFG.save(MusicController.SAVE_VOLUME)
	
	
	 
func _input(_event) -> void:
	if(Input.is_action_pressed("volumeEditor")):
		if self.visible==false:
			self.visible=true
		else:
			self.visible=false


func _on_btn_play_button_down() -> void:
	MusicController.playSFX(lastSound)
