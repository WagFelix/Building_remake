extends Node2D

@export var screenSize: Vector2 = Vector2(1920, 1080)
@export var hSubdivisions: int=  18
@export var aType: int=  1
@export var centerCompensate: int = 1
@export var compensateX: float = 1.5
@export var wTexture = "res://common_textures/cortina_circle.png"
@export var pace: float = 0.01
@export var timeCortina = .6
#@export var scaleMax: float = 1.332
@export var scaleMax: float = 2.01
var squareSizeX: float = 60
var squareSizeY: float = 40
var nSquares: int = 0
#var wState = 0
@onready var nodebuds := $nodebuds
var executing: int = 0
var buds =  {}
var wLines: int = 1
var wType: int = 1
var inicia = false
var corCortinaIn = Color(.2,.2,.2,1)
var corCortinaOut = Color(.2,.2,.2,1)
#var deltaS : float = 0




func _ready() -> void:
	#TweenBuds = create_tween()
	#TweenLoading = create_tween()
	#TweenBuds.stop()
	#TweenLoading.stop()
	hSubdivisions=int(screenSize.y/squareSizeY)+1
	
	#squareSizeY = int(screenSize.y/hSubdivisions)
	nSquares = int(screenSize.x/squareSizeX * screenSize.y/squareSizeY )*3
	var budposition = Vector2(0+centerCompensate,1)
	for n in range(nSquares):
		#print(budposition)
		buds[n] = Sprite2D.new()
		buds[n].texture = load(wTexture)
		nodebuds.add_child(buds[n])
		buds[n].position = budposition
		buds[n].scale = Vector2(0,0)
		
		if(budposition.x/2+squareSizeX*compensateX<screenSize.x):
			budposition.x+=squareSizeX*compensateX
		else:
			wLines+=1
			if(fmod(wLines,2)==0):
				budposition.x=squareSizeX*compensateX/2+centerCompensate
			else:
				budposition.x=0+centerCompensate
			budposition.y+=squareSizeY/2
	
	$Loading.modulate=Color(1,1,1,0)
	#$Loading.stop()

func _process(delta):
	$Loading.rotation_degrees += 666.0/2.0 * delta
	
func _physics_process(_delta):
	
	if inicia==true :
		inicia=false
		var TweenBuds = create_tween()
		TweenBuds.stop()
		doTypes(executing)
		
		if executing==1:
			var TweenLoading = create_tween()
			TweenLoading.stop()
			TweenLoading.set_trans(Tween.TRANS_LINEAR)
			TweenLoading.set_ease(Tween.EASE_IN_OUT)
			TweenLoading.tween_property($Loading, "modulate", Color(1,1,1,0.5), .7)
			TweenLoading.play()
			
			#$Loading.play()
			

			
		else:
			var TweenLoading = create_tween()
			TweenLoading.stop( )
			TweenLoading.set_trans(Tween.TRANS_LINEAR)
			TweenLoading.set_ease(Tween.EASE_IN_OUT)
			TweenLoading.tween_property($Loading, "modulate", Color(1,1,1,0), .3)
			TweenLoading.play()
			#$Loading.stop()
			#$StopAnimLoad.start(.333)

	
func doTypes(mode):
	if wType==1:
		if mode==2:
			var TweenBuds = create_tween().parallel()
			TweenBuds.set_parallel(true)
			TweenBuds.set_trans(Tween.TRANS_LINEAR)
			TweenBuds.set_ease(Tween.EASE_IN_OUT)
			TweenBuds.tween_property($nodebuds, "modulate", corCortinaOut, timeCortina)
			TweenBuds.play()

			for n in range(nSquares):
				var TweenBuds2 = create_tween().parallel()
				TweenBuds2.set_parallel(true)
				TweenBuds2.tween_property(buds[n], "scale",  Vector2(0,0), timeCortina)
				TweenBuds2.play()
				
			
		elif(mode==1):
			$nodebuds.modulate = corCortinaIn
			for n in range(nSquares):
				var TweenBuds = create_tween()
				TweenBuds.tween_property(buds[n], "scale",  Vector2(scaleMax,scaleMax), timeCortina)
				TweenBuds.play()



func _on_Tween_tween_all_completed(): #desconectado???
	if executing==2:
		doTypes(executing)
		executing=0
		
func hideCurtain(cOut=Color(.666,1,1,1)):
#	pass
	if cOut!=Color(.666,1,1,1):
		corCortinaOut = cOut
	executing = 2
	inicia=true
	
	
func showCurtain(colorIn=Color(.2,.2,.2,1), colorOut=Color(.2,.2,.2,1), timeExec=.6, qwType=1):
	inicia=true
	corCortinaIn = colorIn
	corCortinaOut = colorOut
	timeCortina = timeExec
	executing = 1
	wType = qwType



func _on_stop_anim_load_timeout():
	#$Loading.stop()
	pass
