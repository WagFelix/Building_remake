extends Control

var page : int = 0
var num_pages : int = 2
#var cena : AsyncScene = null
var tSound := "res://SFX/whooshdoor.mp3"
@export var inColor := Color(0.784, 0.733, 0.965, 1)
@export var outColor := Color(0.784, 0.733, 0.965, 1)
@export var alternativeOutColor := Color(1.0, 0.835, 0.949, 1)

func _ready():
	SChanger.changeType=0
	Curtain.hideCurtain()
	
	Map.whereIAm = 0
	Map.enterRoom(0)
	
	
	#Engine.get_main_loop().root.get_tree().set_current_scene(self) #XGH, serve pra indical qual sena sera descarregada na troca de cena
	#cena = AsyncScene.new("res://Menu/menu.tscn",AsyncScene.LoadingSceneOperation.Replace)
	change_pages()
	
	
func change_pages():
	var pages = $pages.get_children()
	for child in pages:
		child.visible=false
	
	pages[page].visible=true
	if page==0:
		$pageA.visible=false
	else:
		$pageA.visible=true
	if page==num_pages-1:
		$pageN.visible=false
	else:
		$pageN.visible=true




func _on_page_button_down(extra):
	print("foi")
	page+=extra
	change_pages()


func _on_volta_button_down():
	#Curtain.showCurtain()
	MusicController.playSFX(tSound)
	#$Timer.start(0.666) 
	SChanger._LoadNewScene("res://Menu/Menu.tscn", self)
	Curtain.showCurtain(inColor, outColor, .6, 1)	
	$Timer.start(.6) 

#func change_scene(prel=""):
	#SChanger._LoadNewScene(prel, self)
	#Curtain.showCurtain(inColor, outColor, .6, 1)	
	#$Timer.start(.6) 
	
func _on_Timer_timeout():
	print("timer up: ", SChanger.loadStatus())
	if SChanger.loadStatus()==100:
		iHint.timerhint.stop()
		#Curtain.hideCurtain()
		SChanger._change()
		#queue_free()
	else:
		$Timer.start(.05)	 


func _on_Btn_button_down(jogo):
	if functions.plataforma=="Steam":
		if jogo==0:
			#Steam.activateGameOverlayToStore(1969080)
			pass
		elif jogo==1:
			#Steam.activateGameOverlayToStore(2070550)
			pass
		elif jogo==2:
			#Steam.activateGameOverlayToStore(2136020)
			pass
		elif jogo==3:
			#Steam.activateGameOverlayToStore(2368470)
			pass
		elif jogo==4:
			#Steam.activateGameOverlayToStore(2582360)
			pass
		elif jogo==5:
			#Steam.activateGameOverlayToStore(2179170)
			pass
		elif jogo==6:
			#Steam.activateGameOverlayToStore(2610090)
			pass
		elif jogo==7:
			#Steam.activateGameOverlayToStore(2673390)
			pass
		elif jogo==8:
			#Steam.activateGameOverlayToStore(3087650)
			pass
		elif jogo==9:
			#Steam.activateGameOverlayToStore(2810730)
			pass
		elif jogo==10:
			#Steam.activateGameOverlayToStore(3355100)
			pass
	else:
		#var _disposable = OS.shell_open("https://www.devcatsgames.com/")
		pass
