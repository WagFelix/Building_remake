extends Control

@export var preloadScene = "res://Game/Menu/Menu.tscn"
@export var backSound = "res://SFX/door.mp3"
var parentNode
@export var ghostTransition:=false
@export var isLiving:=false


func _ready():
	parentNode = get_parent()
	print("NAMEPARENJT: ",  parentNode.name)
	if isLiving==true:
		self.visible=false
	#if Map.whereIAm!=6 and Map.whereIAm!=11: #evita load de sala errada
		#background_load.preload_scene(preloadScene)





func _on_TextureButton_button_down():
	if (parentNode.stopscene==false):

		MusicController.playSFX(backSound)

		if ghostTransition==true:
			parentNode.changeType=2 #a transição do scale	
		parentNode.tweenChange(preloadScene)
