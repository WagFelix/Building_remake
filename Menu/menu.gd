extends Control
@onready var tdown := $TimerCoolDown
#@onready var timer := $TimerChange
@export var coolDown := 0.123
var stopscene := false
var mouse_pos := Vector2(0,0) # pra evitar clique falso
var safe_distance : float = 20 # pra evitar clique falso
var timeFadeBad := .29

func _ready() -> void:
	GlobalPanel._hidePanel()
	if SChanger.changeType==1:	
		Elevador._openE()
	elif SChanger.changeType==0:
		Curtain.hideCurtain()
		
	GlobalPanel.eCall.visible=false
	MusicController._playMusic(0)
	var welcome = functions.loadGeneral("menu", "StrayCats")
	if welcome==null:
		welcome=false
	if welcome == true:
		$hiddenCat/bad.visible=false
		$hiddenCat/good.visible=true
		GlobalSteam._give("Building") #warm-up
	else:
		$hiddenCat/bad.visible=true
		$hiddenCat/good.visible=false
	#print("cena: ", Engine.get_main_loop().root.get_tree().get_current_scene())
	#print("cena: ", get_tree().current_scene)
	if get_tree().current_scene.name=="Menu":
		print("identificou menu")

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
				functions.saveGeneral("menu", true, "StrayCats")
				GlobalSteam._give("Building") #warm-up


func _on_door_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#print("dooorimput, ", event)
	if (event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT and stopscene!=true and $TimerCoolDown.is_stopped()):
		print("ABREPANELLLL")
		$TimerCoolDown.start(1.666)
		GlobalPanel.mostra()
