extends Control
var andar : int = 1
var tCool : float = .666
var ttween : float = .666
@onready var eCall := $Call
@onready var ePanel := $Panel




@onready var timer := $timer_change
var timeTrans := 1.2 #tempo suficiente pra fechar o elevador
var changeType : int = 1
@export var inColor := Color(0.784, 0.733, 0.965, 1)
@export var outColor := Color(0.784, 0.733, 0.965, 1)
@export var alternativeOutColor := Color(1.0, 0.835, 0.949, 1)
var stopscene := false




#get_tree().current_scene.name!="Menu"
func _input(_event):
	if(Input.is_action_pressed("back") and $TimerCoolDown.is_stopped()): 
		print("PAINEL")
		mostra()

func _on_call_button_down() -> void:
	mostra()			
				
				
func _ready() -> void:
	eCall.visible=false
	ePanel.visible=false
	ePanel.modulate=Color(1,1,1,0)


func _hidePanel() -> void:
	ePanel.visible=false
	ePanel.modulate=Color(1,1,1,0)

func mostra() -> void:
	print("MOSTRANDO")
	$TimerCoolDown.start(tCool) 
	var mostrar := true
	if $Panel.visible==true:
		#print("PAINEL2")
		mostrar=false
	elif $Panel.visible==false:
		#print("PAINEL3")
		mostrar=true
		
	var TweenMostra : Tween
	TweenMostra = create_tween()
	TweenMostra.stop()
	TweenMostra.set_trans(Tween.TRANS_SINE)

	if mostrar==true:
		ePanel.visible=true
		TweenMostra.set_ease(Tween.EASE_OUT)
		TweenMostra.tween_property(ePanel, "modulate", Color(1,1,1,1), ttween)
	else:
		TweenMostra.set_ease(Tween.EASE_IN)
		TweenMostra.tween_property(ePanel, "modulate", Color(1,1,1,0), ttween)

	TweenMostra.finished.connect(_on_tweenmostra)
	TweenMostra.play()
		

func _on_tweenmostra() -> void:
	if ePanel.modulate==Color(1,1,1,0):
		ePanel.visible=false


func _on_power_button_down() -> void:
	Elevador.get_node("Container/esquerda/quit").visible=true
	Elevador.get_node("Container/direita/quit").visible=true
	Elevador._closeE()
	$TimerQuit.start(5.666)


func _on_panel_button_down(extra: int) -> void:
	andar=extra
	SChanger._LoadNewScene("res://Game/Hall/Hall.tscn", self)
	tweenChange()


func _go_home() -> void:
	SChanger._LoadNewScene("res://Menu/Menu.tscn", self)
	tweenChange()


func _on_timer_change_timeout() -> void:
	if SChanger.loadStatus()==100:
		Curtain.get_node("Loading").modulate=Color(1,1,1,0)
		SChanger._change()
	else:
		timer.start(.05)	


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


func _on_timer_quit_timeout() -> void:
	get_tree().quit()


func _on_credits_button_down() -> void:
	SChanger._LoadNewScene("res://Credits/credits.tscn", self)
	tweenChange()
	


func _on_options_button_down() -> void:
	SChanger._LoadNewScene("res://Options/options.tscn", self)
	tweenChange()
