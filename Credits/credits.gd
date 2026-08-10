extends Control
var stopscene = false
@export var changeType : int =1
@onready var timer := $TimerChange
var timeTrans := 1.2 #tempo suficiente pra fechar o elevador
@export var inColor := Color(0.784, 0.733, 0.965, 1)
@export var outColor := Color(0.784, 0.733, 0.965, 1)
@export var alternativeOutColor := Color(1.0, 0.835, 0.949, 1)
@export var backSound := "res://SFX/whooshdoor.mp3"

@onready var tdown := $TimerCoolDown
#@onready var timer := $TimerChange
@export var coolDown := 0.123
var mouse_pos := Vector2(0,0) # pra evitar clique falso
var safe_distance : float = 20 # pra evitar clique falso
var timeFadeBad := .29

func _ready() -> void:
	GlobalPanel._hidePanel()
	SChanger._LoadNewScene("res://Menu/Menu.tscn", self)
	Elevador._openE()
	var credits = functions.loadGeneral("credits", "StrayCats")
	if credits==null:
		credits=false
	if credits == true:
		$hiddenCat/bad.visible=false
		$hiddenCat/good.visible=true
		GlobalSteam._give("Credits") #credits
	else:
		$hiddenCat/bad.visible=true
		$hiddenCat/good.visible=false
	
func _on_close_button_down() -> void:
	#MusicController.playSFX(backSound)
	tweenChange()

func _on_btn_devcats_button_down() -> void:
	if functions.plataforma=="Steam":
		var _disposable = OS.shell_open("https://store.steampowered.com/developer/devcats")
	else:
		var _disposable = OS.shell_open("https://www.devcatsgames.com/")


func _on_btn_insta_button_down() -> void:
	var _disposable = OS.shell_open("https://www.instagram.com/devcatsgames/")


func _on_btn_discord_button_down() -> void:
	var _disposable = OS.shell_open("https://discord.gg/rr8zmYk9VH")

	
	
func tweenChange(prel=""):
	stopscene=true
	functions.inMenu==true
	#PauseMenu.mostra(false)
	if prel!="":
		#print("OREL: ", prel)
		SChanger._LoadNewScene(prel, self)
	timer.start(timeTrans) 
	
	
	SChanger.changeType=changeType # pra troca sem preloader
	
	if changeType==0: #cortina
		Curtain.showCurtain(inColor, outColor, .6, 1)
	elif changeType==1: #elevador
		Elevador._closeE()
	else: #failsafe
		Elevador._closeE()
			
func _on_timer_change_timeout():
	if SChanger.loadStatus()==100:
		iHint.timerhint.stop()
		mouse_cursor.z_index=4096

		SChanger._change()
		queue_free()
		
	else:
		timer.start(.05)	


func _on_hidden_cat_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT && tdown.is_stopped() && stopscene==false):
			if $hiddenCat/bad.visible==true and $hiddenCat/bad.modulate==Color(1,1,1,1):
				tdown.start(coolDown)
				$hiddenCat/good.visible=true
				var TweenCat2 : Tween
				TweenCat2 = create_tween()
				TweenCat2.stop()
				TweenCat2.set_trans(Tween.TRANS_LINEAR)
				TweenCat2.set_ease(Tween.EASE_IN_OUT)
				TweenCat2.tween_property($hiddenCat/bad, "modulate", Color(1,1,1,0), timeFadeBad)
				TweenCat2.play()
				MusicController.playSFX("res://SFX/cats.mp3", 1, 0.001)
				functions.saveGeneral("credits", true, "StrayCats")
				GlobalSteam._give("Credits") #cradits
