extends Control
#ATENÇAO, nao usar o Building Remake como modelo pra jogos futuros. É um modelo muito simpplificado. Usar Flats ou Building 2 mobile de ferefencia...

var thisRoom := "0"
@export var has_fofinho := true
@export var wAndar := "one"

var justReady=false

var apartamentos := [[null],
	["One", "Onebath"],
	["Two", "Twobath"],
	["Three", "Threebath"],
	["Four", "Fourbath"],
	["Five", "Fivebath"],
	["Roof"],
	["Bunker", "Bunkerbath"]
]

@export var from_center:=false # define se os limites da tela são calculados a partir do centro, util pra cenas que possuem bordas mascaradas, como o Altered Kitty do Building 2
#É Possivel que from_center seja SEMPRE a melhor forma de fazer isso, deixando os valores em 0 quando quisermos que os limites sejam os limites da tela... testando... por enquanto ta dando ruim no reposicionamento dos limitadores

########### pinch system #################################
var touches := {}  # Guarda posição dos toques por índice
var pinch_start_distance := 0.0
var pinch_active := false
var pinch_center := Vector2.ZERO
##########################################################


var totalcats : int = 0
var changeType :int = 0 #define o tipo de transição. 0=curtain, 1=elevador
var lerptime :float= .06

@onready var theHintParticles :=$Room/ParticleHint
@onready var theHintParticles2:=$Room/ParticleHint2

@export var catSound := "res://SFX/cats.mp3"
@export var hidSound := "res://SFX/hidden.mp3"
@export var extrasSound := "res://SFX/fofinho.mp3"

################ scroll #####################
var zoom_pos := Vector2(0,0)
@export var zoom_min := Vector2(.501,.501)
@export var zoom_max := Vector2(1,1)
@export var room_pos_init := Vector2(0,0)
var zoom_speed := Vector2(.1,.1) # going to options
@export var zoom := Vector2(.501,.501)
var des_pos := Vector2(0,0)
var des_zoom := Vector2(.5,.5)

@onready var room:=$Room
@onready var XD:=$Room/borderNotifiers/XD
@onready var XE:=$Room/borderNotifiers/XE
@onready var YC:=$Room/borderNotifiers/YC
@onready var YB:=$Room/borderNotifiers/YB

@export var xMaxLimit : int =1920
@export var xMinLimit : int =0
@export var yMaxLimit : int =1080
@export var yMinLimit : int =0


@onready var ShakeTimer := $shakertimer
@export var cooldownShake: float = 0.02
var shaking: int = 0
var amplitude: int = 0

var stopscene := false

var clicado := false

var xinit : float = 0 
var yinit : float = 0 
###################### end scroll

@onready var tdown := $TimerCoolDown
@onready var timer := $TimerChange
@export var coolDown := 0.123

var timeTrans := .6
var timeTransOut := .9

var timeFadeBad := .29

var roomDiscover := [] #normais
var roomDiscoverHidden := []  #gatos escondidos
var roomHidden := [] #esconderijos
var roomExtras := [] #extras / fofinho... sao 3 fofinhos por apartamento

var catsLeft :int = 0
var catsLeftH :int = 0
var extrasLeft :int = 0

##########  hints ################
@export var hintLeft :int  = 1
@onready var nodefind := $HudContainer/Hint/Hint
@onready var middleScreenX: int = 960
@onready var middleScreenY: int = 540
var emissionPositionChange:=false
var hinting := false
@export var noHintRoom := false #se true, é uma sala que nao há hints

############# end hints ############


var zooming:=false
var nsp:=Vector2(0,0)

@export var inColor := Color(0.784, 0.733, 0.965, 1)
@export var outColor := Color(0.784, 0.733, 0.965, 1)
@export var alternativeOutColor := Color(1.0, 0.835, 0.949, 1)


@export var hideBad := false
@export var hideGood := false
#@export var hideBadExtra := true
#@export var scaleExtra := false

var lockDrag := false
var hudTrans := [false,false]
var allowFind := true
@export var allowFindExtra := true
@export var extraItem = ""
#@export var dissolveExtra = true #se true, usa o shader de dissolver



var mouse_pos := Vector2(0,0) # pra evitar clique falso
var safe_distance : float = 20 # pra evitar clique falso


func _ready() -> void:
	functions.whereIWas=self.name
	print("ANDARRRRRRRRRRRR ", GlobalPanel.andar)
	if wAndar=="roof":
		MusicController._playMusic(6)
		#GlobalPanel.andar=6
		
	if SChanger.changeType==1:	
		Elevador._openE()
	elif SChanger.changeType==0:
		Curtain.hideCurtain()
	GlobalPanel.eCall.visible=true
	GlobalPanel.eCall.modulate=Color(1,1,1,1)
	catsLeft=0
	middleScreenX = functions.viewport_size.x/2
	middleScreenY = functions.viewport_size.y/2
	thisRoom = self.name
	
	xMaxLimit=functions.viewport_size.x
	xMinLimit=0
	yMaxLimit=functions.viewport_size.y
	yMinLimit=0	

	mouse_cursor.change_cursor(0)
	
	var tudo = functions.loadcats(thisRoom)
	functions.saveroom(thisRoom, true)
	functions.firstIntro=false
	functions.inMenu=false
	
	iHint.timerhint.start(iHint.hinttimer)
	if iHint.hint==false :
		hintLeft=0
	#MusicController._playMusic(sceneMusic, slowdown) #a musica no remake do building é carregada no hall
	
	
	zoom_speed = Vector2(functions.scrollSens,functions.scrollSens)
	des_zoom = zoom
	room.position=room_pos_init

	##### aqui os itens achados	
	if tudo[0]!=null:
		roomDiscover=tudo[0] #os gatos
	if tudo[1]!=null:
		roomDiscoverHidden=tudo[1] #os gatos hiden
	if tudo[2]!=null:
		roomHidden=tudo[2]
	if tudo[3]!=null:
		if tudo[3]<0:
			pass
		else:
			hintLeft=tudo[3]
	#if tudo[4]!=null:
		#roomExtras = tudo[4]
	var buscaExtras = functions.loadGeneral(wAndar,"roomExtras")
	if buscaExtras!=null:
		roomExtras=buscaExtras
	else:
		roomExtras=[false, false, false]
		
	functions.saveGeneral(wAndar,roomExtras,"roomExtras")
	var contaCats = 0
	
	#$Room/AreaClicks.visible=false
	#$Room/hiddenAreas.visible=false
	#$Room/ExtraAreas.visible=false
	
	$Room/AreaClicks.visible=true #normais
	var roomcats = $Room/AreaClicks.get_children()
	for child in roomcats:
		if tudo[0]==null:
			roomDiscover.push_back(false)
		var areaNodes = child.get_children()
		#areaNodes[1].position = areaNodes[0].position
		if roomDiscover.size()<=contaCats: #workaround gambiarra caso a gente adicione gatos APOS ja ter um save
			roomDiscover.push_back(false)
		if roomDiscover[contaCats]==false:
			areaNodes[1].visible=true
			
			############## Criação automatica de collision ###################
			if not functions.has_collision_polygon(child): #so vai criar se a area nao tiver um collisionpoligon custom
				functions.create_collision_from_sprite(areaNodes[1]) # isso cria a area de clique collisionpolygon2d
			############# isso aqui cria o bind, se ele nao tiver sido criado manualmente #############
			var cb := Callable(self, "_on_catClickRoom_event").bind(contaCats)#isso será feito manualmente só em casos específicos em que precisemos passar mais parametros, ou parametros custom
			if not child.input_event.is_connected(cb):
				child.input_event.connect(cb)
			###################################################################
			###################################################################
			
			areaNodes[0].visible=false
			catsLeft+=1
		else:
			areaNodes[1].visible=false
			if hideGood==true:
				var firula := false
				if areaNodes.size()>=4:
					if areaNodes[3].name == "FIRULA":
						firula=true
				areaNodes[0].visible=true
				if firula==false:
					areaNodes[0].get_parent().visible = false
			else:
				areaNodes[0].visible=true
		contaCats+=1
		totalcats+=1

	functions.savecats(thisRoom, "roomDiscover", roomDiscover)
	#$hud/Counter.set_text(str(catsLeft))
	$HudContainer/Counters/Counter.set_text(str(catsLeft))
	
	var hiddenAreas = $Room.get_node_or_null("hiddenAreas")
	if hiddenAreas:
		contaCats = 0
		var roomcatsH = hiddenAreas.get_children()
		for child in roomcatsH:
			var areaNodes = child.get_children()
			if areaNodes.size() < 2:
				contaCats += 1
				continue

			if tudo[1] == null:
				roomDiscoverHidden.push_back(false)
			if tudo[2] == null:
				roomHidden.push_back(false)
			if roomDiscoverHidden.size() <= contaCats:
				roomDiscoverHidden.push_back(false)
			if roomHidden.size() <= contaCats:
				roomHidden.push_back(false)

			if roomHidden[contaCats]==false:
				areaNodes[0].visible=false
				areaNodes[1].visible=false
				areaNodes[3].visible=false
			else:
				areaNodes[0].visible=true
				areaNodes[1].visible=true
				areaNodes[3].visible=true

			if roomDiscoverHidden[contaCats]==false:
				catsLeftH+=1
				areaNodes[0].visible=false
			else:
				areaNodes[3].visible=true
				areaNodes[1].visible=true
				areaNodes[0].visible=true
				areaNodes[0].modulate=Color(1,1,1,1)
				areaNodes[0].z_index=areaNodes[0].z_index+1
				if hideGood==true or hideBad==true:
					areaNodes[1].modulate=Color(1,1,1,0)
				else:
					areaNodes[1].modulate=Color(1,1,1,.9999)

			if not child.input_event.is_connected(Callable(self, "_on_HiddenOpen").bind(contaCats)):
				child.input_event.connect(Callable(self, "_on_HiddenOpen").bind(contaCats))

			var hiddenNode = child.get_node_or_null("hidden")
			if hiddenNode:
				var catareaNode = hiddenNode.get_node_or_null("catarea")
				if catareaNode and not catareaNode.input_event.is_connected(Callable(self, "_on_Hidencat").bind(contaCats)):
					catareaNode.input_event.connect(Callable(self, "_on_Hidencat").bind(contaCats))

			contaCats += 1
			totalcats += 1

		functions.savecats(thisRoom, "roomDiscoverHidden", roomDiscoverHidden)
		functions.savecats(thisRoom, "roomHidden", roomHidden)
		$HudContainer/Counters/Hidden/CounterHid.set_text(str(catsLeftH))
		if catsLeftH > 0:
			pass
			#$HudContainer/Counters/Hidden.visible = true
		elif catsLeftH == 0:
			#$HudContainer/Counters/Hidden.visible = false
			wingChange()
			#if has_node("hud/CounterHid_fundo"): $hud/CounterHid_fundo.visible = true
	########################################################################
	
	###########################################################################
	######################## os extra sao o fofinho    ########################
	######################## ele aparece numa ordem    ########################
	######################## pre definida, entre as    ########################
	######################## duas salas do apartamento ########################
	###########################################################################
	if has_fofinho==true:
		_mostrafofinho(false)
	
	
	if hintLeft==0 :
		iHint.timerhint.start(iHint.hinttimer)
	hint_initialize()
#	achievHid()
	wingChange()
	
	if catsLeft+catsLeftH<=0:
		iHint.timerhint.stop()
		acaba()
		#GlobalSteam._give(roomAchievs[thisRoom])
	
	
	nsp=room_pos_init
	reposiciona_limitadores()
	justReady=true


func _mostrafofinho(tocasom=false) -> void :
	var extraAreas = $Room.get_node_or_null("ExtraAreas")
	if roomExtras==[true,true,true]:
		$HudContainer/Counters/Fofinopaw.visible=true
		
		var wfofis := "nenhumAchievement"
		if wAndar=="one":
			wfofis = "01fofo"
		if wAndar=="two":
			wfofis = "02fofo"
		if wAndar=="three":
			wfofis = "03fofo"
		if wAndar=="four":
			wfofis = "04fofo"
		if wAndar=="five":
			wfofis = "05fofo"

		
		GlobalSteam._give(wfofis)
		
			
		
		
		if tocasom==true:
			MusicController.playSFX("res://SFX/yes.mp3")
	if extraAreas:
		#contaCats = 0
		var roomcatsH = extraAreas.get_children()
		for child in roomcatsH:
			var areaNodes = child.get_children()
			var selfNode = int(child.name)
			var criaArea := false
			if selfNode==0:
				if roomExtras[0]==false and roomExtras[1]!=true and roomExtras[2]!=true:
					child.visible=true
					criaArea=true
				else:
					child.visible=false
					criaArea=false
			if selfNode==1:
				if roomExtras[0]==true and roomExtras[1]!=true and roomExtras[2]!=true:
					child.visible=true
					criaArea=true
				else:
					child.visible=false
					criaArea=false
			if selfNode==2:
				if roomExtras[0]==true and roomExtras[1]==true and roomExtras[2]!=true:
					child.visible=true
					criaArea=true
				else:
					child.visible=false
					criaArea=false
					
			if criaArea==true:
				############## Criação automatica de collision ###################
				if not functions.has_collision_polygon(child): #so vai criar se a area nao tiver um collisionpoligon custom
					functions.create_collision_from_sprite(areaNodes[0]) # isso cria a area de clique collisionpolygon2d
				############# isso aqui cria o bind, se ele nao tiver sido criado manualmente #############
				var cb := Callable(self, "_on_ExtraClickRoom_event").bind(str(child.name))#isso será feito manualmente só em casos específicos em que precisemos passar mais parametros, ou parametros custom
				if not child.input_event.is_connected(cb):
					child.input_event.connect(cb)
				###################################################################
				###################################################################
	
	
func _on_ExtraClickRoom_event(_viewport, event, _shape_idx, extra): #extra no building remake vem o nome do node
	if (event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT && tdown.is_stopped() && stopscene==false and allowFindExtra==true and GlobalPanel.ePanel.visible==false):
		print("Gato: ", extra, " tdown: ",tdown.is_stopped())
		var dist = mouse_pos-get_viewport().get_mouse_position()
		var distx = abs(dist.x)
		var disty = abs(dist.y)
		
		
		if distx<safe_distance and disty<safe_distance:
			tdown.start(coolDown)
			#var roomcats = $Room/ExtraAreas.get_children()
			print("nomedonode: ", extra)
			var theCat = $Room/ExtraAreas.get_node(extra)
			if theCat.modulate==Color(1,1,1,1):
				#theCat.modulate = Color(1,1,1,0)
				#theCat.visible = true
				#
				#var TweenCat2 : Tween
				#TweenCat2 = create_tween()
				#TweenCat2.stop()
				#TweenCat2.set_trans(Tween.TRANS_LINEAR)
				#TweenCat2.set_ease(Tween.EASE_IN_OUT)
				#
				#TweenCat2.tween_property(theCat, "modulate", Color(1,1,1,1), timeFadeBad)
				#
				#TweenCat2.play()

				var TweenCat : Tween
				TweenCat = create_tween()
				TweenCat.stop()
				TweenCat.set_trans(Tween.TRANS_EXPO)
				TweenCat.set_ease(Tween.EASE_IN_OUT)
				TweenCat.tween_property(theCat, "modulate", Color(1,1,1,0), timeFadeBad*2.666)
				#_mostrafofinho()
				TweenCat.finished.connect(_mostrafofinho)
				TweenCat.play()
					
				

				
				#extrasLeft-=1
				
				
				#print("GATOAMENOS")
				#$hud/CounterExtras.set_text(str(extrasLeft))
				var eSound = extrasSound
				if extra=="03":
					eSound="res://SFX/fofinho2.mp3"				
				MusicController.playSFX(eSound, 1.2, 0.001)
				roomExtras[int(extra)]=true
				functions.saveGeneral(wAndar,roomExtras,"roomExtras")

					

					
				wingChange()

		mouse_pos = get_viewport().get_mouse_position()
		
		
		
		

func wingChange(): #no remake do building, usaremos aqui pra ver se o apartamento foi finalizado
	_mostrafofinho() #mostra pata e da achievement
	print("entrou wingchange")
	var wAch := "01"
	if wAndar=="one":
		wAch = "01"
	if wAndar=="two":
		wAch = "02"
	if wAndar=="three":
		wAch = "03"
	if wAndar=="four":
		wAch = "04"
	if wAndar=="five":
		wAch = "05"
	if wAndar=="roof":
		wAch = "06"
	if wAndar=="bunker":
		wAch = "07"
	
	var indexAp = int(wAch)
	var wAps = apartamentos[indexAp]
	var achSalaCat := true
	var achSalaHid := true
	var wRoomDiscover
	var wRoomDiscoverHidden
	for wSala in wAps:
		print(wSala , " passando em wingchange")
		var tudo = functions.loadcats(wSala)
		if tudo[0]!=null:
			print("TUDO ACHADO 0 ", tudo[0])
			wRoomDiscover=tudo[0]
			if wRoomDiscover.count(false)>0:
				achSalaCat=false
		else:
			achSalaCat=false
			
		if tudo[1]!=null:
			wRoomDiscoverHidden=tudo[1]
			print("TUDO ACHADO 1 ", tudo[1])
			if wRoomDiscoverHidden.count(false)>0:
				achSalaHid=false
		else:
			achSalaHid=false
			
			
	if achSalaCat==true:
		GlobalSteam._give(wAch)
	if achSalaHid==true:
		GlobalSteam._give(wAch+"extra")
		
	if achSalaCat==true and achSalaHid==true :
		var wFecha:=true
		if has_fofinho==true:
			if roomExtras!=[true, true,true]:
				wFecha=false
		if wFecha==true:
			#tweenChange("res://Game/Hall/Hall.tscn")
			if justReady==true: #so mostra se for por clique, nao por entrada na sala
				MusicController.playSFX("res://SFX/sucess.mp3")
				GlobalPanel.mostra()
		
func acaba(): 
	_mostrafofinho()
	

func reposiciona_limitadores():
	if from_center!=true:
		if ($Room/borderNotifiers/XD.global_position.x-$Room/borderNotifiers/XE.global_position.x<get_viewport().get_visible_rect().size.x):
			
			var aumentarX = int((get_viewport().get_visible_rect().size.x-($Room/borderNotifiers/XD.global_position.x-$Room/borderNotifiers/XE.global_position.x))/2)
			$Room/borderNotifiers/XD.position.x = $Room/borderNotifiers/XD.position.x+aumentarX
			$Room/borderNotifiers/XE.position.x = $Room/borderNotifiers/XE.position.x-aumentarX
			# print("reposicionar xizes ", )
		if ($Room/borderNotifiers/YB.global_position.y-$Room/borderNotifiers/YC.global_position.y<get_viewport().get_visible_rect().size.y):
			var aumentarY = int((get_viewport().get_visible_rect().size.y-($Room/borderNotifiers/YB.global_position.y-$Room/borderNotifiers/YC.global_position.y))/2)
			
			#print("aumentarY ", aumentarY)
			
			$Room/borderNotifiers/YB.position.y = $Room/borderNotifiers/YB.position.y+aumentarY
			$Room/borderNotifiers/YC.position.y = $Room/borderNotifiers/YC.position.y-aumentarY
			#print("reposicionar ipsulons ", )
	#print("tamanho y ", get_viewport().get_visible_rect().size.y)

func limits():


	if XD.global_position.x<=xMaxLimit:
		var adjustx = xMaxLimit - XD.global_position.x
		room.position.x=room.position.x+adjustx
	if XE.global_position.x>=xMinLimit:
		var adjustx = xMinLimit - abs(XE.global_position.x)
		#print("XE: ", XE.global_position.x)
		room.position.x=room.position.x+adjustx
	if YC.global_position.y>=yMinLimit:
		var adjusty = yMinLimit - abs(YC.global_position.y)
		room.position.y=room.position.y+adjusty
	if YB.global_position.y<=yMaxLimit:
		var adjusty = yMaxLimit - abs(YB.global_position.y)
		room.position.y=room.position.y+adjusty

func newHint():
	if noHintRoom!=true: #só entra aqui se for uma sala que permite hints
		if hintLeft<1:
			MusicController.playSFX("res://SFX/yes.mp3", 1, .001, 2)
		hintLeft = 1
		functions.savecats(self.name, "hintLeft", 1)
		hint_initialize()	

func hint_initialize():
	if noHintRoom==true:
		$HudContainer/Hint.visible=false
	else:
		if catsLeft>0 or catsLeftH>0:
			$HudContainer/Hint.visible=true
		else:
			$HudContainer/Hint.visible=false

func _process(_delta):

	
	if noHintRoom!=true: #só entra aqui se for uma sala que permite hints
		if iHint.getHint == true:
			iHint.getHint = false
			newHint()
	
#	if thisRoom!=20000:
	zoom=lerp(zoom, des_zoom,lerptime)
	room.scale=zoom
	
	################define zoom do detector de metais##################
	#mouse_cursor.get_node("metal_detector").zoom = zoom
	###################################################################
	
	if zooming==true:
		room.position=lerp(room.position, nsp, lerptime)
		#reposiciona_limitadores()
	
	reposiciona_limitadores() #talvez fazer isso só quando a posiçao ou zoom mudarem? deixa assim por enquanto
	limits()

	if stopscene==true:
		pass

	if pinch_active:
		clicado = false
	
	
	#if stopscene==false and hinting!=true:
	if stopscene==false and hinting!=true and pinch_active==false and touches.size()==0 and GlobalPanel.ePanel.visible==false:
		
		##################################
		#####zoom com joystick:
		##################################
		var zoom_speed_analog := 1.0   # ajuste fino
		var deadzoneZoom := 0.05
		var zoom_in = Input.get_action_strength("zoomin")
		var zoom_out = Input.get_action_strength("zoomout")
		
		var input_strength = zoom_in - zoom_out  # positivo = zoom in, negativo = zoom out
		
		if abs(input_strength) >= deadzoneZoom:
			
			var zoomA = zoom
			var zoomB = lerp(zoom, des_zoom, lerptime)
			
			des_zoom += Vector2.ONE * input_strength * zoom_speed_analog * _delta
			
			des_zoom.x = clamp(des_zoom.x, zoom_min.x, zoom_max.x)
			des_zoom.y = clamp(des_zoom.y, zoom_min.y, zoom_max.y)
			
			if des_zoom != zoomA:
				zooming = false
				
				var mousepos = get_viewport().get_mouse_position()
				var scenepos = room.position	
				
				var viewport_size = get_viewport().get_visible_rect().size
				mousepos = mousepos - (viewport_size / 2)
				
				nsp = (mousepos * zoomA - (mousepos - scenepos) * zoomB) / zoomA
				
				room.position = nsp
				limits()
		
		
		####################################
		############ fim do zoom de joystick
		####################################
		
		
		#mover a sala pelo analogico da direita:
		var dir = Input.get_vector("rightstick_left", "rightstick_right", "rightstick_up", "rightstick_down")
		var strength = dir.length()
		var deadzone := 0.2
		var sens := 1200.0
		if strength > deadzone:
			var norm_dir = dir.normalized()
			
			var adjusted_strength = (strength - deadzone) / (1.0 - deadzone)
			
			var movement = norm_dir * sens * adjusted_strength * _delta
			
			# estilo drag (invertido)
			room.position -= movement
			
			zooming = false
			
			limits()
		
		
		if Input.is_action_pressed("click") and clicado==false and lockDrag==false:
			clicado=true
			xinit = get_viewport().get_mouse_position().x
			yinit = get_viewport().get_mouse_position().y
			
			
		elif !Input.is_action_pressed("click") and clicado==true:
			clicado=false
		elif Input.is_action_pressed("click") and clicado==true:
			#print("MOVENDO ", get_viewport().get_mouse_position())
		
				
				
			if get_viewport().get_mouse_position().x>=0 and get_viewport().get_mouse_position().x<=functions.viewport_size.x:  #pra evitar mover a tela se o mouse ta fora
				room.position.x=room.position.x+get_viewport().get_mouse_position().x-xinit
				xinit = get_viewport().get_mouse_position().x
				zooming=false
			
			if get_viewport().get_mouse_position().y>=0 and get_viewport().get_mouse_position().y<=functions.viewport_size.y:  #pra evitar mover a tela se o mouse ta fora	
				room.position.y=room.position.y+get_viewport().get_mouse_position().y-yinit
				yinit = get_viewport().get_mouse_position().y
				zooming=false
				#print("TESTE, ", room.position.y)
				
				
				#print("xinit: ", xinit)
				
			####################################################################
			#agora que o cursor do mouse tem mais "protagonismo" no jogo, vamos calculaar a posição melhor
			####################################################################
			if xinit<0:
				xinit=0
			if xinit>functions.viewport_size.x:
				xinit=functions.viewport_size.x
			if yinit<0:
				yinit=0
			if yinit>functions.viewport_size.y:
				yinit=functions.viewport_size.y
			####################################################################
				
			limits()
		if Input.is_action_just_released("click"):
			#print("Desclicado na posiçao: ", get_viewport().get_mouse_position())
			print("Posição da sala: ", room.position, " zoom: ", zoom)
			pass
		
	if zoom.x>=zoom_max.x-0.001 and stopscene==false:
		zoom=zoom_max
		room.position.x = round(room.position.x)
		room.position.y = round(room.position.y)
		limits()

func _input(event):

	if stopscene == true or GlobalPanel.ePanel.visible==true:
		return

	########################################################
	# TOUCH / PINCH
	########################################################

	if event is InputEventScreenTouch:

		if event.pressed:
			touches[event.index] = event.position
			#mouse_pos = event.position #nao descomente isso sem escrever um motivo

		else:
			touches.erase(event.index)

			# terminou pinch
			if touches.size() < 2:
				pinch_active = false
				clicado = false

	########################################################
	# DRAG TOUCH
	########################################################

	elif event is InputEventScreenDrag:

		touches[event.index] = event.position

		####################################################
		# PINCH
		####################################################

		if touches.size() >= 2:

			var points = touches.values()

			var pos1 = points[0]
			var pos2 = points[1]

			var current_distance = pos1.distance_to(pos2)

			# começou pinch
			if pinch_active == false:

				pinch_active = true
				pinch_start_distance = current_distance
				pinch_center = (pos1 + pos2) / 2.0

			else:

				################################################
				# CALCULA ZOOM
				################################################

				var zoom_factor = current_distance / pinch_start_distance

				var new_zoom = des_zoom * zoom_factor

				################################################
				# LIMITES
				################################################

				new_zoom.x = clamp(new_zoom.x, zoom_min.x, zoom_max.x)
				new_zoom.y = clamp(new_zoom.y, zoom_min.y, zoom_max.y)

				################################################
				# CENTRO DO PINCH
				################################################

				var current_center = (pos1 + pos2) / 2.0

				################################################
				# DRAG DURANTE PINCH
				################################################

				var delta_center = current_center - pinch_center
				room.position += delta_center

				pinch_center = current_center

				################################################
				# ZOOM CENTRALIZADO
				################################################

				var mousepos = current_center

				var viewport_size = get_viewport().get_visible_rect().size
				mousepos = mousepos - (viewport_size / 2)

				var scenepos = room.position
				var zoomA = zoom

				nsp = (mousepos * zoomA - (mousepos - scenepos) * new_zoom) / zoomA

				################################################
				# APLICA
				################################################

				des_zoom = new_zoom
				zooming = true

				################################################
				# RESET BASE DO PINCH
				################################################

				pinch_start_distance = current_distance

			####################################################
			# EVITA DRAG FANTASMA
			####################################################

			clicado = false

		####################################################
		# DRAG NORMAL COM 1 DEDO
		####################################################

		elif pinch_active == false and hinting != true and lockDrag == false:

			room.position += event.relative
			zooming = false

			limits()

	########################################################
	# KEYBOARD
	########################################################

	if (event is InputEventKey) and (
		Input.is_action_pressed("ui_up")
		or Input.is_action_pressed("ui_down")
		or Input.is_action_pressed("ui_left")
		or Input.is_action_pressed("ui_right")
		or Input.is_action_pressed("ui_page_down")
		or Input.is_action_pressed("ui_page_up")
	) and hinting != true:

		zooming = false

		if Input.is_action_pressed("ui_up"):
			room.position.y += 10

		elif Input.is_action_pressed("ui_down"):
			room.position.y -= 10

		elif Input.is_action_pressed("ui_left"):
			room.position.x += 10

		elif Input.is_action_pressed("ui_right"):
			room.position.x -= 10

		else:

			if Input.is_action_pressed("ui_page_down"):

				if des_zoom >= zoom_min:
					des_zoom -= zoom_speed

				if des_zoom < zoom_min:
					des_zoom = zoom_min

			elif Input.is_action_pressed("ui_page_up"):

				if des_zoom <= zoom_max:
					des_zoom += zoom_speed

				if des_zoom > zoom_max:
					des_zoom = zoom_max

			var zoomA = zoom
			var mousepos = get_viewport().get_mouse_position()
			var scenepos = room.position

			zooming = true

			nsp = (mousepos * zoomA - (mousepos - scenepos) * des_zoom) / zoomA

		limits()

	########################################################
	# MOUSE
	########################################################

	if event is InputEventMouseButton and event.is_released():
		clicado = false

	#if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		#mouse_pos = get_viewport().get_mouse_position() nao descomente isso sem escrever um motivo

	if event is InputEventMouseButton and event.is_pressed() and hinting != true:

		var zoomA = zoom

		####################################################
		# WHEEL DOWN
		####################################################

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

			if des_zoom >= zoom_min:
				des_zoom -= zoom_speed

			if des_zoom < zoom_min:
				des_zoom = zoom_min

		####################################################
		# WHEEL UP
		####################################################

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:

			if des_zoom <= zoom_max:
				des_zoom += zoom_speed

			if des_zoom > zoom_max:
				des_zoom = zoom_max

		####################################################
		# CENTRALIZA NO CURSOR
		####################################################

		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

			var mousepos = get_viewport().get_mouse_position()
			var scenepos = room.position

			zooming = true

			var viewport_size = get_viewport().get_visible_rect().size

			mousepos = mousepos - (viewport_size / 2)

			nsp = (mousepos * zoomA - (mousepos - scenepos) * des_zoom) / zoomA




func _on_catClickRoom_event(_viewport, event, _shape_idx, extra, firula_nao_some=false): #firula nao some é a gambiarra de ultima hora pros gatos falsos(poster, etc) nao sumirem
	if (event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT && tdown.is_stopped() && stopscene==false and allowFind==true and GlobalPanel.ePanel.visible==false):
		#print("Gato: ", extra)
#		var roomcats = $RoallowFindallowFindom/CatsS.get_children()
		var dist = mouse_pos-get_viewport().get_mouse_position()
		var distx = abs(dist.x)
		var disty = abs(dist.y)
		print("Gato: ", extra, mouse_pos, " - ", dist)		
		
		print("safe: ",safe_distance, " -x: ", distx, " -y: ",disty )		
		if distx<safe_distance and disty<safe_distance:
			var roomcats = $Room/AreaClicks.get_children()
			var theCat = roomcats[extra].get_children()
			if theCat[0].visible==false:
				theCat[0].modulate = Color(1,1,1,0)
				theCat[0].visible = true

				theCat[0].z_index = theCat[0].z_index+1
				
				var TweenCat2 : Tween
				TweenCat2 = create_tween()
				TweenCat2.stop()
				TweenCat2.set_trans(Tween.TRANS_LINEAR)
				TweenCat2.set_ease(Tween.EASE_IN_OUT)
				TweenCat2.tween_property(theCat[0], "modulate", Color(1,1,1,1), timeFadeBad)
				TweenCat2.play()
				
				if hideGood==true: #pra esconder os gatos
					if firula_nao_some!=true: #teria sido melhor esses gatos da excessao serem pintados no proprio cenario
						var TweenCat3 : Tween
						TweenCat3 = create_tween().parallel()
						TweenCat3.set_parallel(true) #usar isso?
						TweenCat3.tween_interval(1)
						TweenCat3.stop()
						TweenCat3.set_trans(Tween.TRANS_LINEAR)
						TweenCat3.set_ease(Tween.EASE_IN_OUT)
						TweenCat3.tween_property(theCat[1], "modulate", Color(1,1,1,0), timeFadeBad) #o bad tem que ir junto
						TweenCat3.tween_property(theCat[0], "modulate", Color(1,1,1,0), timeFadeBad)
						
						TweenCat3.play()
				
				
				if hideBad==true:
					var TweenCat : Tween
					TweenCat = create_tween()
					TweenCat.stop()
					TweenCat.set_trans(Tween.TRANS_LINEAR)
					TweenCat.set_ease(Tween.EASE_IN_OUT)
					TweenCat.tween_property(theCat[1], "modulate", Color(1,1,1,0), timeFadeBad)
					TweenCat.play()
					
					

				
				catsLeft-=1
				
				
				tdown.start(coolDown)
				print("GATOAMENOS")
				#$hud/Counter.set_text(str(catsLeft))
				$HudContainer/Counters/Counter.set_text(str(catsLeft))
				MusicController.playSFX(catSound, 1, 0.001)
				roomDiscover[extra]=true
				functions.savecats(thisRoom, "roomDiscover", roomDiscover)
				hint_initialize()
				if catsLeft<=0:
					catsLeft=0
					##################### sistema de achievement normal ################
					######   achievements de sala estao sendo dados no wingchange   ####
					#if achievment_normal!="": #achievement normal
						#GlobalSteam._give(achievment_normal)
					####################################################	
						
					##################### sistema de achievement building 2 ################
					#if catsLeft<=0 and catsLeftH<=0 and achievment_sala!="": #achievement sala
						#GlobalSteam._give(achievment_sala)
				

				if catsLeft==0 and catsLeftH==0:
					acaba()
				wingChange()
		mouse_pos = get_viewport().get_mouse_position()	
		
func _on_Hidencat(_viewport, event, _shape_idx, extra):
	if (event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT && tdown.is_stopped() && stopscene==false and allowFind==true and GlobalPanel.ePanel.visible==false):
		print("Gatos Hidden achados: ", extra)
		
		
		var dist = mouse_pos-get_viewport().get_mouse_position()
		var distx = abs(dist.x)
		var disty = abs(dist.y)
		
		
		if distx<safe_distance and disty<safe_distance:
			
			
			var roomcats = $Room/hiddenAreas.get_children()
			var theCat = roomcats[extra].get_children()
		#print("Color: ", theCat[1].modulate)

			if theCat[1].modulate== Color(1,1,1,1) and theCat[1].visible==true:
				print("UM")
				
				theCat[0].modulate=Color(1,1,1,0)
				theCat[0].visible=true
				theCat[0].z_index = theCat[0].z_index+1
				theCat[1].modulate=Color(1,1,1,.9999)
				
				var TweenCat2 : Tween
				TweenCat2 = create_tween()
				TweenCat2.stop()
				TweenCat2.set_trans(Tween.TRANS_LINEAR)
				TweenCat2.set_ease(Tween.EASE_IN_OUT)
				TweenCat2.tween_property(theCat[0], "modulate", Color(1,1,1,1), timeFadeBad)
				TweenCat2.play()
				
				if hideGood==true: #pra esconder os gatos
					var TweenCat3 : Tween
					TweenCat3 = create_tween().parallel()
					TweenCat3.set_parallel(true) # usar isso?
					TweenCat3.tween_interval(2)
					TweenCat3.stop()
					TweenCat3.set_trans(Tween.TRANS_LINEAR)
					TweenCat3.set_ease(Tween.EASE_IN_OUT)
					
					
					TweenCat3.tween_property(theCat[1], "modulate", Color(1,1,1,0), timeFadeBad) #o bad tem que ir junto
					TweenCat3.tween_property(theCat[0], "modulate", Color(1,1,1,0), timeFadeBad)
					TweenCat3.play()
				
				
				#gambiarra
				if hideBad==true:
					var TweenCat : Tween
					TweenCat = create_tween()
					TweenCat.stop()
					TweenCat.set_trans(Tween.TRANS_LINEAR)
					TweenCat.set_ease(Tween.EASE_IN_OUT)
					TweenCat.tween_property(theCat[1], "modulate", Color(1,1,1,0), timeFadeBad)
					TweenCat.play()
				
				
				catsLeftH-=1
				
		#achievHid()
				tdown.start(coolDown)
				#$hud/CounterHid.set_text(str(catsLeftH))
				$HudContainer/Counters/Hidden/CounterHid.set_text(str(catsLeftH))
				MusicController.playSFX(catSound, 1, 0.001)
				roomDiscoverHidden[extra]=true
				functions.savecats(thisRoom, "roomDiscoverHidden", roomDiscoverHidden)
				hint_initialize()
				if catsLeftH<=0 :
					catsLeftH=0
					########### sistema de achievement normal
					######   achievements de sala estao sendo dados no wingchange   ####
					#if achievment_hidden!="": #achievement hidden
						#GlobalSteam._give(achievment_hidden)
					wingChange()
					###################### sistema de achievement building 2 ################

					
					
					
				if catsLeft==0 and catsLeftH==0:
					iHint.timerhint.stop()
					acaba()
					
				#mouse_pos = get_viewport().get_mouse_position()
		mouse_pos = get_viewport().get_mouse_position()


func _on_HiddenOpen(_viewport, event, _shape_idx, extra1, extra2=null, extra3=false, extra4="", extra5=[]): #extra2 pra quando houver 2 escondidos sob o mesmo lugar, extra3 é pra forçar abrir mesmo sem "event", extra4 é som especial(apartamento gamer, metal gear na caixa), extra5 é pra quando tem muitos escondidos sob o mesmo lugar/suporte grafico(ver santa ceia do building 2, apartamento do artista)
	#print("hidden SADASDASDASSAD")
	if (((event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT) or extra3==true) && tdown.is_stopped() && stopscene==false and GlobalPanel.ePanel.visible==false): #and allowFind==true deixa abrir, nao deixa clicar
		print("hidden DENTROOOOOOOOOOO")
		var dist = mouse_pos-get_viewport().get_mouse_position()
		var distx = abs(dist.x)
		var disty = abs(dist.y)
		
		
		if (distx<safe_distance and disty<safe_distance) or extra3==true:
			print("EXECUTANDOHIDDEN")

			var roomcats = $Room/hiddenAreas.get_children()
			var theCat = roomcats[extra1].get_children()
			var theCat2
			if extra2==null:
				extra2=extra1
			theCat2 = roomcats[extra2].get_children()

			if roomHidden.size() <= extra1:
				roomHidden.resize(extra1 + 1)
			if roomHidden.size() <= extra2:
				roomHidden.resize(extra2 + 1)
			if theCat[1].visible==false or theCat2[1].visible==false:
				theCat[0].visible = false
				theCat[1].visible = true
				theCat[3].visible = true
				roomHidden[extra1]=true
				theCat2[0].visible = false
				theCat2[1].visible = true
				theCat2[3].visible = true
				roomHidden[extra2]=true
				tdown.start(coolDown)
				theCat[2].queue_free()
				if extra2!=extra1:
					theCat2[2].queue_free()

				if extra5.size()>=1:
					for i in range(0, extra5.size()):
						var theCat5 = roomcats[extra5[i]].get_children()
						theCat5[0].visible = false
						theCat5[1].visible = true
						theCat5[3].visible = true
						roomHidden[extra5[i]]=true

				if extra4=="":
					MusicController.playSFX(hidSound, .5, 0.001, 2)
					#get_node_or_null("Room/Par_effects").global_position= theCat[1].global_position
					#get_node_or_null("Room/Par_effects/ParticleHidden").emitting=true
				else:
					MusicController.playSFX(extra4, .8, 0.001, 3)

			functions.savecats(thisRoom, "roomHidden", roomHidden)
			tdown.start(.3)
	#else:
		#tdown.start(.001)
		mouse_pos = get_viewport().get_mouse_position()



func hintGo():
	if hintLeft<=0:
		return
	hintLeft-=1
	functions.savecats(thisRoom, "hintLeft", hintLeft)
	iHint.timerhint.start(iHint.hinttimer)
	MusicController.playSFX("res://SFX/hintclick.mp3", 1, 0.001)
	_findHint()
	hint_initialize()

func _on_Hint_input_event_Button():
	if stopscene==false:
		print("HIIIIIIIIIINTbutton")
		hintGo()


func _on_Hint_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT) and stopscene==false:
		print("HIIIIIIIIIINT")
		hintGo()


func _findHint():
	des_zoom=zoom_max
	var zoomA = zoom
	var mousepos = get_viewport().get_mouse_position()
	
	var scenepos = room.position	
	zooming=true
	nsp= (mousepos*zoomA-(mousepos-scenepos)*des_zoom)/zoomA
	$HudContainer/Hint/Hint/TimerZoom.start(.75)

func achaGato(arrays: Array) -> Dictionary: #agora vamos buscar o gato do hint aleatoriamente
	var possibilidades = []

	for array_id in arrays.size():
		var arr = arrays[array_id]

		for index in arr.size():
			if !arr[index]:
				possibilidades.append({
					"array_id": array_id,
					"index": index
				})

	if possibilidades.is_empty():
		return {}

	return possibilidades.pick_random()
func _on_timer_zoom_timeout(): #hint system
	print("TIMERZOOM ", roomDiscover)
	print("TIMERZOOM ", roomDiscoverHidden)
	zooming = false
	#var findroom = roomDiscover.find(false)
	#var findroomh = roomDiscoverHidden.find(false)
	#var findrooms = roomExtras.find(false)
	
	var _catposition =  Vector2(0,0)
	var newroompositionx = 0
	var newroompositiony = 0
	var distancex:int = 0
	var distancey:int = 0
	
	var gatoAchado = achaGato([roomDiscover,roomDiscoverHidden])
	if !gatoAchado.is_empty():
		if gatoAchado.array_id==0:
			nodefind = get_node("Room/AreaClicks").get_child(gatoAchado.index).get_child(1)
		elif gatoAchado.array_id==1:
			nodefind = get_node("Room/hiddenAreas").get_child(gatoAchado.index).get_child(1).get_child(0).get_child(0)
		hinting=true
	else: 
		print("nada a achar")
	#limits()
	if hinting==true:
		#_catposition = nodefind.global_position
		######## detecçao do node foi feita anteriormente ############
		
		var newroompositionxE = $Room.position.x - XE.global_position.x 
		var newroompositionxD = $Room.position.x - XD.global_position.x +(middleScreenX*2)
		var newroompositionyC = $Room.position.y - YC.global_position.y 
		var newroompositionyB = $Room.position.y - YB.global_position.y +(middleScreenY*2)
		
		distancex = $Room.position.x - nodefind.global_position.x 
		newroompositionx = middleScreenX + distancex
		distancey = $Room.position.y - nodefind.global_position.y 
		newroompositiony = middleScreenY + distancey
		
		if newroompositionx>newroompositionxE:
			newroompositionx = newroompositionxE
		if newroompositiony>newroompositionyC:
			newroompositiony = newroompositionyC
		if newroompositiony<newroompositionyB:
			newroompositiony = newroompositionyB
		if newroompositionx<newroompositionxD:
			newroompositionx = newroompositionxD
			
			
		print("WTF:", newroompositiony, " * ", newroompositionyB)
		
		
		theHintParticles.position=nodefind.position
		theHintParticles2.position=nodefind.position
#		4185 x -381 *** -3780 xxx 3225
		print(newroompositionx, " x ", $Room.position.x, " *** ", XE.global_position.x, " xxx ", distancex)
		#print(newroompositionx, " x ", newroompositiony, " x ", XE.position.x, " x ", XD.position.x , " x ", YC.position.y, " x ", YB.position.y)
		var TweenCat2 : Tween
		TweenCat2 = create_tween()
		TweenCat2.stop()
		TweenCat2.set_trans(Tween.TRANS_LINEAR)
		TweenCat2.set_ease(Tween.EASE_IN_OUT)
		TweenCat2.tween_property($Room, "position", Vector2(newroompositionx, newroompositiony), .9)
		TweenCat2.finished.connect(_on_TweenHint_tween_all_completed)
		TweenCat2.play()


func _on_TweenHint_tween_all_completed():
	print("NOME DO NODE: ", nodefind.name)
	var msize = nodefind.texture.get_size()
	var newEmission = []
	for i in range(-msize.x/2, msize.x/2):
		for j in range(-msize.y/2, msize.y/2):
			if nodefind.is_pixel_opaque(Vector2(i,j))==true:
				newEmission.push_back(Vector2(i,j))
	theHintParticles.lifetime=2.1
	theHintParticles.set_emission_points(newEmission)
	#theHintParticles.scale=room.scale
	theHintParticles.global_position=nodefind.global_position
#
	theHintParticles.emitting=true
	
	theHintParticles2.lifetime=2.1
	theHintParticles2.set_emission_points(newEmission)
	#theHintParticles2.scale=room.scale
	theHintParticles2.global_position=nodefind.global_position
#
	theHintParticles2.emitting=true
	MusicController.playSFX("res://SFX/hintreveal.mp3", 1, 0.001, 2)
	$HudContainer/Hint/Hint/TimerUnhint.start(2.05)


	
func tweenChange(prel=""):
	stopscene=true
	functions.inMenu==true
	#PauseMenu.mostra(false)
	if prel!="":
		print("OREL: ", prel)
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
		SChanger._change() #pra troca de cena sem preloader
		queue_free()
	
	
 

func Shake(wamplitude, thetimes, qnode=self ):
	#print("SHAKING")
	if(ShakeTimer.is_stopped()):
		ShakeTimer.start(cooldownShake)
		randomize()
		self.position = Vector2(randf_range(middleScreenX-wamplitude, middleScreenX+wamplitude), randf_range(middleScreenY-wamplitude, middleScreenY+wamplitude))
		shaking=thetimes
		#print("Times: ", thetimes)
		amplitude=wamplitude
		shaking-=1
		if(shaking>0):
			Shake(amplitude, shaking, qnode)
		else:
			self.position = Vector2(middleScreenX,middleScreenY)
			
	else:
		pass
	
func _on_shakertimer_timeout():
	if(shaking>=0):
		Shake(amplitude, shaking) 


func _on_timer_unhint_timeout():
	hinting = false


func _on_hudestraArea_mouse_entered():
	hudTrans[1]=true
	verificaHud()


func _on_hudestraArea_mouse_exited():
	hudTrans[1]=false
	verificaHud()
	

func verificaHud():
#	print("VERIFICA")
	if hudTrans[0]==true or hudTrans[1]==true:
		$hud.modulate=Color(1,1,1,.2)
		#$hudextra.modulate=Color(1,1,1,.2)
	if hudTrans[0]==false and hudTrans[1]==false:
		$hud.modulate=Color(1,1,1,1)
		#$hudextra.modulate=Color(1,1,1,1)
