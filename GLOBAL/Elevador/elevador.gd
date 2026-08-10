extends Control
var isclosed:=false
@export var ePosOpen  := Vector2(-1932,0)
@export var dPosOpen  := Vector2(1932,0)
@export var ePosClose := Vector2(-645,0)
@export var dPosClose := Vector2(645,0)
var timedoor:float= 1.20
var timeclosed:float= 1.2
@onready var pEsquerda := $Container/esquerda
@onready var pDireita := $Container/direita


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pEsquerda.position=ePosOpen
	pDireita.position=dPosOpen
	self.visible=false


func _openE() -> void :
	MusicController.playSFX("res://SFX/elevator-open.mp3", 1, .9, 2)
	$TimerClosed.start(timeclosed)

func _timeropen():	
	print("open elevator")
	var TweenDoor : Tween
	TweenDoor = create_tween().parallel()
	TweenDoor.stop()
	TweenDoor.set_parallel(true)
	TweenDoor.set_trans(Tween.TRANS_CUBIC)
	TweenDoor.set_ease(Tween.EASE_IN_OUT)
	#TweenCat2.tween_property($hud, "position", Vector2($hud.position.x, hudzero), timeFadeBad)
	TweenDoor.tween_property(pEsquerda, "position", ePosOpen, timedoor)
	TweenDoor.tween_property(pDireita, "position", dPosOpen, timedoor)

	TweenDoor.finished.connect(_changeStateDoor)
	TweenDoor.play()

func _changeStateDoor() -> void:
	isclosed=false #talvez nao precisemos, mas deixa aqui
	self.visible=false


func _closeE() -> void :
	print("close elevator")
	self.visible=true
	
	var TweenDoor : Tween
	#TweenDoor = create_tween().parallel()
	TweenDoor = create_tween()
	TweenDoor.set_parallel(true)
	TweenDoor.stop()
	TweenDoor.set_trans(Tween.TRANS_LINEAR)
	TweenDoor.set_ease(Tween.EASE_IN_OUT)
	#TweenCat2.tween_property($hud, "position", Vector2($hud.position.x, hudzero), timeFadeBad)
	TweenDoor.tween_property(pEsquerda, "position", ePosClose, timedoor)
	TweenDoor.tween_property(pDireita, "position", dPosClose, timedoor)
	MusicController.playSFX("res://SFX/elevator-close.mp3", 1, .001, 3) 
	TweenDoor.finished.connect(_closeDoor)
	TweenDoor.play()

func _closeDoor():
	isclosed=true
	print("FECHOUUUUUUUUUU, ", isclosed)

func _on_timer_closed_timeout() -> void:
	_timeropen()#abrir as portas
