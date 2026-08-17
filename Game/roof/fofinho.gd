extends Area2D
@onready var parentNode := get_parent()

@export var parentLevel :=2


func _ready() -> void:
	print("FOFIS")
	for i in range(0, parentLevel):
		if i>=1:
			parentNode=parentNode.get_parent()
	var count = 0
	self.visible=false
	var jaAchou= functions.loadGeneral("found", "Fofinho")
	var adotou= functions.loadGeneral("adopted", "Fofinho")
	if jaAchou==null:
		jaAchou=false
	
	if jaAchou==false or adotou==null:
		for room in functions.arquivoPath.get_section_keys("roomExtras"):
			print("PROCURA")
			var values = functions.arquivoPath.get_value("roomExtras", room)

			if values.size() == 3 and values[0]==true and values[1]==true and values[2]==true:
				count += 1

			if count >= 5:
				$Found.visible=false
				$Choice.visible=false
				$Thanks.visible=false
				self.visible=true
				print("ACHOU")
				break
	else:
		GlobalSteam._give("Found")
		if adotou==null:
			adotou=false
		if adotou==true:
			GlobalSteam._give("Adopted")

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton && (event.pressed or Input.is_action_just_released("click")) && event.button_index == MOUSE_BUTTON_LEFT && parentNode.tdown.is_stopped() && parentNode.stopscene==false and GlobalPanel.ePanel.visible==false and $Fo00a.modulate==Color(1,1,1,1)):
		GlobalPanel.ePanel.modulate=Color(1,1,1,1)
		GlobalPanel.ePanel.visible=true
		GlobalPanel.visible=false
		parentNode.get_node("HudContainer").visible=false
		parentNode.get_node("Back").visible=false
		
		var TweenFofis : Tween
		TweenFofis = create_tween().parallel()
		TweenFofis.set_parallel(true)
		TweenFofis.tween_interval(1)
		TweenFofis.stop()
		TweenFofis.set_trans(Tween.TRANS_SINE)
		TweenFofis.set_ease(Tween.EASE_OUT)
		TweenFofis.tween_property($Fo00a, "modulate", Color(1,1,1,0), .666) 
		#TweenFofis.tween_property(parentNode.get_node("Room"), "scale", Vector2(1,1), .666) 
		TweenFofis.tween_property(parentNode.get_node("Room"), "position", Vector2(0,262), .666) 
		parentNode.des_zoom=Vector2(1,1)
		parentNode.des_pos=Vector2(0,262)
		TweenFofis.finished.connect(_mostraChoice)
		MusicController.playSFX("res://SFX/fofinho2.mp3")
		GlobalSteam._give("Found")
		functions.saveGeneral("found",true,"Fofinho")
	
		
		TweenFofis.play()
		
func _mostraChoice() -> void:
	parentNode.get_node("HudContainer/Counters/Fofinopaw").visible=true
	var itexture ="res://Game/roof/textures/ending/fofino/fofino-found"+functions.langChoice+".png" 
	$Found.set_texture(load(itexture))
	
	
	$Found.modulate=Color(1,1,1,0)
	$Found.visible=true
	var TweenFofis : Tween
	TweenFofis = create_tween().parallel()
	TweenFofis.set_parallel(true)
	TweenFofis.tween_interval(1)
	TweenFofis.stop()
	TweenFofis.set_trans(Tween.TRANS_SINE)
	TweenFofis.set_ease(Tween.EASE_OUT)
	TweenFofis.tween_property($Found, "modulate", Color(1,1,1,1), .666) 
	TweenFofis.finished.connect(_abreOption)
	TweenFofis.play()		

func _abreOption() -> void:
	$Found/yes.visible=true
	$Found/no.visible=true


func _on_yes_button_down() -> void:
	$Found/yes.visible=false
	$Found/no.visible=false
	var itexture ="res://Game/roof/textures/ending/fofino/fofino-yes"+functions.langChoice+".png"
	$Choice.set_texture(load(itexture))
	$Choice.modulate=Color(1,1,1,0)
	$Choice.visible=true
	GlobalSteam._give("Adopted")
	functions.saveGeneral("adopted",true,"Fofinho")
	var TweenFofis : Tween
	TweenFofis = create_tween().parallel()
	TweenFofis.set_parallel(true)
	TweenFofis.tween_interval(1)
	TweenFofis.stop()
	TweenFofis.set_trans(Tween.TRANS_SINE)
	TweenFofis.set_ease(Tween.EASE_OUT)
	TweenFofis.tween_property($Choice, "modulate", Color(1,1,1,1), .666) 
	TweenFofis.finished.connect(_abreAcaba)
	MusicController.playSFX("res://SFX/yes.mp3")
	TweenFofis.play()

func _abreAcaba() -> void:
	$Acaba.visible=true
	

func _on_no_button_down() -> void:
	$Found/yes.visible=false
	$Found/no.visible=false
	var itexture ="res://Game/roof/textures/ending/fofino/fofino-no"+functions.langChoice+".png"
	$Choice.set_texture(load(itexture))
	$Choice.modulate=Color(1,1,1,0)
	$Choice.visible=true
	GlobalSteam._give("Cruel")
	functions.saveGeneral("adopted",false,"Fofinho")
	var TweenFofis : Tween
	TweenFofis = create_tween().parallel()
	TweenFofis.set_parallel(true)
	TweenFofis.tween_interval(1)
	TweenFofis.stop()
	TweenFofis.set_trans(Tween.TRANS_SINE)
	TweenFofis.set_ease(Tween.EASE_OUT)
	TweenFofis.tween_property($Choice, "modulate", Color(1,1,1,1), .666) 
	TweenFofis.finished.connect(_Cruel)
	MusicController.playSFX("res://SFX/no.mp3")
	TweenFofis.play()


func _Cruel() -> void:
	$Cruel.visible=true
	
	
func _on_acaba_button_down() -> void:
	$Acaba.visible=false
	var itexture ="res://Game/roof/textures/ending/thanks/thanks"+functions.langChoice+".png"
	$Thanks.set_texture(load(itexture))
	$Thanks.visible=true
	parentNode.get_node("Room/borderNotifiers/YC").position=Vector2(0,-9999999)
	var TweenFofis : Tween
	TweenFofis = create_tween().parallel()
	TweenFofis.set_parallel(true)
	TweenFofis.tween_interval(1)
	TweenFofis.stop()
	TweenFofis.set_trans(Tween.TRANS_SINE)
	TweenFofis.set_ease(Tween.EASE_OUT)
	TweenFofis.tween_property(parentNode.get_node("Room"), "position", Vector2(0,1320), 3.666) 
	parentNode.des_pos=Vector2(0,1320)
	TweenFofis.finished.connect(_voltamenu)
	#MusicController.playSFX("res://SFX/fofinho2.mp3")
	TweenFofis.play()

func _voltamenu() -> void:
	$menu.visible=true
	
	

func _on_cruel_button_down() -> void:
	$Cruel.visible=false
	var TweenFofis : Tween
	TweenFofis = create_tween().parallel()
	TweenFofis.set_parallel(true)
	TweenFofis.tween_interval(1)
	TweenFofis.stop()
	TweenFofis.set_trans(Tween.TRANS_SINE)
	TweenFofis.set_ease(Tween.EASE_OUT)
	TweenFofis.tween_property($Fo00a, "modulate", Color(1,1,1,0), 3.666) 
	TweenFofis.tween_property($Fo00b, "modulate", Color(1,1,1,0), 3.666) 
	TweenFofis.finished.connect(_fecha)
	#MusicController.playSFX("res://SFX/fofinho2.mp3")
	TweenFofis.play()

func _fecha() -> void:
	var eEsquerda = Elevador.get_node("Container/esquerda/quit")
	var spriteE = "res://achievements/textures/achievs256/What-a-cruel-world.jpg"
	eEsquerda.set_texture(load(spriteE))
	eEsquerda.visible=true
	$TimerFecha.start(5.666)
	Elevador._closeE()

func _on_menu_button_down() -> void:
	GlobalPanel.ePanel.modulate=Color(1,1,1,0)
	GlobalPanel.ePanel.visible=false
	GlobalPanel.visible=true
	parentNode.tweenChange("res://Menu/Menu.tscn")


func _on_timer_fecha_timeout() -> void:
	get_tree().quit()
