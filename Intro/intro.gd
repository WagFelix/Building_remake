extends Control




var closetext := false
var clickletter := false
var openedgate := false


func _ready() -> void:
	MusicController._playMusic(0)
	SChanger._LoadNewScene("res://Menu/Menu.tscn", self)
	var itexture = "res://Intro/assets/intro"+functions.langChoice+".png"
	print(itexture)
	$introText/IntroText.set_texture(load(itexture))
	$VideoStreamPlayer.visible=false
	$VideoStreamPlayer.modulate=Color(1,1,1,0)
	#$VideoStreamPlayer.play()
	$IntroFade.visible=true
	$IntroFade.modulate=Color(1,1,1,1)
	$GateArea.visible=false
	var Tweenfade : Tween
	Tweenfade = create_tween()
	Tweenfade.stop()
	Tweenfade.set_trans(Tween.TRANS_CUBIC)
	Tweenfade.set_ease(Tween.EASE_IN)
	Tweenfade.tween_property($IntroFade, "modulate", Color(1,1,1,0),.333)
	Tweenfade.finished.connect(showLetter)
	Tweenfade.play()
	MusicController.playSFX("res://SFX/popupin.mp3", 2, 0.99)
	
func showLetter() -> void:
	$IntroFade.visible=false
	var TweenLetter : Tween
	TweenLetter = create_tween()
	TweenLetter.stop()
	TweenLetter.set_trans(Tween.TRANS_BACK)
	TweenLetter.set_ease(Tween.EASE_IN_OUT)
	TweenLetter.tween_property($introText, "position", Vector2(0,0),1.666)
	TweenLetter.finished.connect(clickLetter)
	TweenLetter.play()	

func clickLetter() -> void:
	clickletter=true
	print("clickletter: ", clickletter)

func _on_gate_area_button_down() -> void:
	if closetext==true:
		$VideoStreamPlayer.visible=true
		var Tweengate : Tween
		Tweengate = create_tween()
		Tweengate.stop()
		Tweengate.set_trans(Tween.TRANS_QUAD)
		Tweengate.set_ease(Tween.EASE_IN_OUT)
		Tweengate.tween_property($VideoStreamPlayer, "modulate", Color(1,1,1,1),.666)
		$TimerFade.start(1.999)
		#Tweengate.finished.connect(fadeout)
		Tweengate.play()	
		#$VideoStreamPlayer.modulate=Color(1,1,1,1)
		$VideoStreamPlayer.play()
		


func _on_intro_text_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton && event.pressed and closetext==false and clickletter==true):
		print("clicou carta")
		clickletter=false
		MusicController.playSFX("res://SFX/popupout.mp3", 2, 0.33)
		var TweenLetter : Tween
		TweenLetter = create_tween()
		TweenLetter.stop()
		TweenLetter.set_trans(Tween.TRANS_BACK)
		TweenLetter.set_ease(Tween.EASE_IN_OUT)
		TweenLetter.tween_property($introText, "position", Vector2(0,-1280),1.666)
		TweenLetter.finished.connect(clickGate)
		TweenLetter.play()	
		
		
func clickGate() -> void:
	closetext=true
	$GateArea.visible=true
	
func fadeout() -> void:
	$IntroFade.visible=true
	var Tweenfade : Tween
	Tweenfade = create_tween()
	Tweenfade.stop()
	Tweenfade.set_trans(Tween.TRANS_CUBIC)
	Tweenfade.set_ease(Tween.EASE_IN)
	Tweenfade.tween_property($IntroFade, "modulate", Color(1,1,1,1),1.333)
	Tweenfade.finished.connect(showmenu)
	Tweenfade.play()


func showmenu() -> void:
	$timer_change.start(.666)

func _on_timer_change_timeout()->void:
	if SChanger.loadStatus()==100:
		Curtain.get_node("Loading").modulate=Color(1,1,1,0)
		SChanger._change()
	else:
		$timer_change.start(.05)	


func _on_video_stream_player_finished() -> void:
	#fadeout()
	pass


func _on_timer_fade_timeout() -> void:
	fadeout()
