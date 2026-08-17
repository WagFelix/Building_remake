extends Control

var doors = ["res://Game/bunker/bunker.tscn", 
	"res://Game/one/one.tscn",
	"res://Game/two/two.tscn",
	"res://Game/three/three.tscn",
	"res://Game/four/four.tscn",
	"res://Game/five/five.tscn",
	"res://Game/roof/roof.tscn",
]

var qMusic = [
	7,1,2,3,4,5,6,
]
var andar : int = 1

@onready var timer := $timer_change
var timeTrans := 1.2 #tempo suficiente pra fechar o elevador
var changeType : int = 0
@export var inColor := Color(0.784, 0.733, 0.965, 1)
@export var outColor := Color(0.784, 0.733, 0.965, 1)
@export var alternativeOutColor := Color(1.0, 0.835, 0.949, 1)
var stopscene := false



func _ready() -> void:
	functions.whereIWas="hall"
	GlobalPanel._hidePanel()
	GlobalPanel.eCall.visible=true
	GlobalPanel.eCall.modulate=Color(1,1,1,1)
	functions.inMenu=false
	andar = GlobalPanel.andar
	MusicController._playMusic(qMusic[andar])
	var spriteCorridor = "res://Game/Hall/textures/hall0"+str(andar)+".png"
#	if functions.wfloor==7:
	$BG.set_texture(load(spriteCorridor))
	if andar!=5:
		$Stairs.visible=false
	
	if SChanger.changeType==1:	
		Elevador._openE()
	elif SChanger.changeType==0:
		Curtain.hideCurtain()
		
	


func _on_door_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT and stopscene!=true):
		var sounddoor = "res://SFX/door.mp3"
		if andar==0:
			sounddoor="res://SFX/bunker_door.mp3"
		MusicController.playSFX(sounddoor, 1, 0.1)
		var doorScene = doors[andar]
		stopscene=true
		tweenChange(doorScene)


func _on_stairs_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT and stopscene!=true):
		GlobalPanel.andar=6
		stopscene=true
		MusicController.playSFX("res://SFX/stairs.mp3", 1, 0.1)
		var doorScene = doors[6]
		tweenChange(doorScene)



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


func _on_timer_change_timeout() -> void:
	if SChanger.loadStatus()==100:
		Curtain.get_node("Loading").modulate=Color(1,1,1,0)
		SChanger._change()
	else:
		timer.start(.05)
