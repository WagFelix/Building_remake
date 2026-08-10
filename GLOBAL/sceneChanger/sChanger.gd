extends Node2D

#tentando usar sem o preloader, vou comentar tudo aqui e refazer abaixo
#var scene : AsyncScene = null
#
#func _LoadNewScene(newScene, oldScene) -> void:
	#Engine.get_main_loop().root.get_tree().set_current_scene(oldScene) #XGH, 
	#scene = AsyncScene.new(newScene,AsyncScene.LoadingSceneOperation.Replace)
#
#func _change() -> void:
	#scene.ChangeScene()
	#scene.queue_free()
	#
#func loadStatus():
	#return(scene.progress)

var scene : = ""
var changeType := 0

func _LoadNewScene(newScene, _oldScene) -> void:
	#Engine.get_main_loop().root.get_tree().set_current_scene(oldScene) #XGH, 
	scene = newScene
	
func _change() -> void:
	get_tree().change_scene_to_file(scene)
	
func loadStatus():
	#return(scene.progress)
	return 100
