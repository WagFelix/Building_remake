extends Control

@onready var musicslider := $MusicSlider/HBoxContainer/TextureProgress
@onready var sfxslider := $SfxSlider/HBoxContainer/TextureProgress
@onready var mouseslider := $MouseSlider/HBoxContainer/TextureProgress
@onready var ambienceslider := $AmbienceSlider/HBoxContainer/TextureProgress


var poptimer : float = .3 #timer before options is clickable
@onready var timerpop :=$Delete/Popup/timerpop
#const SAVE_PATH = "user://settings.cfg"
var arquivoCFG = ConfigFile.new()


var optLang = ["Eng", "Por", "Kor", "Sch", "Jap",  "Rus", "Spa", "Spa", "Ger", "Fre", "Tur", "Pol", "Ita", "Ukr", "Tsh"]
#var optLang = ["Eng"]

	

var actionParent
var langchoice : int = 0 
var slotDelete : int = 0

var stopscene = false
@onready var timer := $TimerChange
var timeTrans := .6
@export var inColor := Color(0.784, 0.733, 0.965, 1)
@export var outColor := Color(0.784, 0.733, 0.965, 1)
@export var alternativeOutColor := Color(1.0, 0.835, 0.949, 1)
@export var backSound := "res://SFX/whooshdoor.mp3"

var changing := false

func _ready() -> void:
	Map.whereIAm = "0"
	Map.enterRoom("0")
	SChanger._LoadNewScene("res://Menu/Menu.tscn", self)
	if DisplayServer.get_screen_count()>1:
		$multiScreen.visible=true
		if DisplayServer.get_screen_count()<3:
			$multiScreen/screen3.visible=false
			
		if functions.initscreen==0:
			$multiScreen/screen1.texture_normal = load("res://Options/textures/screen_on.png")
			
			print("TELA INICIAL 1")
		elif functions.initscreen==1:

			$multiScreen/screen2.texture_normal = load("res://Options/textures/screen_on.png")
			print("TELA INICIAL 2")
		elif functions.initscreen==2:

			$multiScreen/screen3.texture_normal = load("res://Options/textures/screen_on.png")
			print("TELA INICIAL 2")
	else:
		$multiScreen.visible=false
	actionParent = get_parent()
	Curtain.hideCurtain()
	var set_texture = load("res://Options/textures/options_save_selected.png")	
	if functions.saveSlot==1:
		$Slot1/Sprite2D.set_texture(set_texture)
	else:
		$Slot2/Sprite2D.set_texture(set_texture)
		
	$Delete/Popup.visible=false
	var tDel = load("res://Options/textures/delete/delete_"+functions.langChoice+".png")
	if tDel!=null:
		$Delete/Popup.set_texture(tDel)
	musicslider.value = functions.MUSICV
	sfxslider.value = functions.SFXV
	ambienceslider.value = functions.AMBIENCEV
	var newSens = functions.scrollSens
	
	newSens = (100*(newSens-.025))/.075
	
	print("NEWSENS: ", newSens)
	
	mouseslider.value = newSens
	
	if (functions.cursorSize == 1):
		print("CURSOR UM")
		$cursorSize1/on2.visible=true
		$cursorSize2/on2.visible=false
	else:
		print("CURSOR DOIS")
		$cursorSize1/on2.visible=false
		$cursorSize2/on2.visible=true
		
	
	if (functions.window_mode == 4):
		$Fullscreen/OptionsFullscreenOn2.visible=true
		$Windowed/OptionsWindowOn2.visible=false
	else:
		$Fullscreen/OptionsFullscreenOn2.visible=false
		$Windowed/OptionsWindowOn2.visible=true
	var auxCont = 0
	for n in optLang:
		if n==functions.langChoice:
			$Language/SpriteLang.set_frame(auxCont)
			langchoice=auxCont
		auxCont+=1
	var textureDelete = "res://Options/textures/deleteoff.png"
#	print(textureDelete)
	$DeleteBtn/Sprite.set_texture(load(textureDelete))
#	if functions.demo==true:
#		$Language.visible=false
	if DisplayServer.get_screen_count()<=1 and DisplayServer.window_get_size().y<1000:
		$Fullscreen.visible=false
		$Windowed.visible=false
	else: #só pra garantir
		$Fullscreen.visible=true
		$Windowed.visible=true
	



func _on_fullscreen_mouse_entered() -> void:
	$Fullscreen/FullAnimation.set_speed_scale(7)
	$Fullscreen/FullAnimation.play("fade")


func _on_fullscreen_mouse_exited() -> void:
	$Fullscreen/FullAnimation.set_speed_scale(7)
	$Fullscreen/FullAnimation.play_backwards("fade")


func _on_fullscreen_button_down():
	print("PRESS")
	$Fullscreen/OptionsFullscreenOn2.visible=true
	$Windowed/OptionsWindowOn2.visible=false
	functions.window_mode=4
#		functions.save_config = true
	functions.save_settings()
	#DisplayServer.window_set_mode(4)



func _on_windowed_mouse_entered():
	$Windowed/WindowAnimation.set_speed_scale(7)
	$Windowed/WindowAnimation.play("fade")


func _on_windowed_mouse_exited():
	$Windowed/WindowAnimation.set_speed_scale(7)
	$Windowed/WindowAnimation.play_backwards("fade")

func _on_windowed_button_down():
	$Fullscreen/OptionsFullscreenOn2.visible=false
	$Windowed/OptionsWindowOn2.visible=true
	functions.resolution=Vector2(1200,720)
	functions.window_mode=0
	
	functions.save_settings()
	#DisplayServer.window_set_mode(0)


func _on_language_mouse_entered() -> void:
	$Language/LangAnimation.set_speed_scale(7)
	$Language/LangAnimation.play("fade")


func _on_language_mouse_exited() -> void:
	$Language/LangAnimation.set_speed_scale(7)
	$Language/LangAnimation.play_backwards("fade")


func _on_language_button_down() -> void:
	langchoice+=1
	if (langchoice>(optLang.size()-1)):
		langchoice=0
	print("Debug: ", langchoice)
	functions.langChoice=optLang[langchoice]
	$Language/SpriteLang.set_frame(langchoice)
	var tDel = load("res://Options/textures/delete/delete_"+functions.langChoice+".png")
	if tDel!=null:
		$Delete/Popup.set_texture(tDel)
	functions.save_settings(false)
	LangText.loadLanguage()
	Map.change_lang() #aqui trocar os textos do mapa/tela de pause
	LangText.loadLanguage()#so pra carregar mais uma vez depois do mapa
	Map.change_lang()
	#langChange()




func _on_Delete_mouse_entered(qual=1)-> void:
	var textureDelete = "res://Options/textures/deleteon.png"
#	print(textureDelete)
	if qual==1:
		$DeleteBtn/Sprite.set_texture(load(textureDelete))
	else:
		$DeleteBtn2/Sprite.set_texture(load(textureDelete))


func _on_Delete_mouse_exited(qual=1)-> void:
	var textureDelete = "res://Options/textures/deleteoff.png"
#	print(textureDelete)
	if qual==1:
		$DeleteBtn/Sprite.set_texture(load(textureDelete))
	else:
		$DeleteBtn2/Sprite.set_texture(load(textureDelete))


func _on_Delete_input_event(qual=1)-> void:
		var tDel = load("res://Options/textures/delete_popup/delete_"+functions.langChoice+".png")
		slotDelete = qual
		if tDel!=null:
			$Delete/Popup.set_texture(tDel)
		$Delete/Popup.visible=true
		$Delete/Popup/No/Sprite.visible=false
		$Delete/Popup/Yes/Sprite.visible=false



func _on_no_input_event()-> void:
	$Delete/Popup.visible=false
	timerpop.start(poptimer)


func _on_yes_mouse_entered()-> void:
	$Delete/Popup/Yes/Sprite.visible=true


func _on_yes_mouse_exited()-> void:
	$Delete/Popup/Yes/Sprite.visible=false


func _on_yes_input_event()-> void:
	MusicController.playSFX("res://SFX/delete.mp3", 1, 0.001)
	#var file = FileAccess.open(functions.PROGRESS_PATH, FileAccess.READ_WRITE)
	#var file_text = file.get_as_text()
	#var file_text_lines: Array = file_text.split("\n")
	#file.close()
	var qfile 
	if slotDelete==1:	
		functions.arquivoPROGRESS.clear()
		qfile = FileAccess.open(functions.PROGRESS_PATH, FileAccess.WRITE)
		qfile.close()
	else:
		functions.arquivoPROGRESS2.clear()
		qfile = FileAccess.open(functions.PROGRESS_PATH2, FileAccess.WRITE)	
		qfile.close()
		
		
	timerpop.start(poptimer)	
	$Delete/Popup.visible=false
	#get_parent().get_parent().get_node('BG/Planeta').visible=false
	#print("QualPArent: ", get_parent().get_parent().name)








func _on_no_mouse_entered():
	$Delete/Popup/No/Sprite.visible=true


func _on_no_mouse_exited():
	$Delete/Popup/No/Sprite.visible=false


func _on_cursor_size_2_mouse_entered() -> void:
	$cursorSize2/on.visible=true
	print("entrou")

func _on_cursor_size_2_mouse_exited() ->void:
	$cursorSize2/on.visible=false
	
func _on_cursor_size_1_mouse_entered() ->void:
	$cursorSize1/on.visible=true
	

func _on_cursor_size_1_mouse_exited() -> void:
	$cursorSize1/on.visible=false

func _on_cursor_size_1_button_down() -> void:
	functions.cursorSize=1
	functions.save_settings(false)
	mouse_cursor.change_cursor()
	$cursorSize1/on2.visible=true
	$cursorSize2/on2.visible=false
		
		


func _on_cursor_size_2_button_down() -> void:
	functions.cursorSize=2
	print(functions.cursorSize)
	print("2222222222")
	functions.save_settings(false)
	mouse_cursor.change_cursor()
	$cursorSize1/on2.visible=false
	$cursorSize2/on2.visible=true
		











func _on_slot_1_mouse_entered():
	var set_texture = load("res://Options/textures/options_save_selected.png")	
	$Slot1/Sprite2D.set_texture(set_texture)
	

func _on_slot_1_mouse_exited():
	var set_texture = load("res://common_textures/pixel_transp.png")	
	if functions.saveSlot!=1:
		$Slot1/Sprite2D.set_texture(set_texture)



func _on_slot_1_button_down():
	var set_texture = load("res://Options/textures/options_save_selected.png")	
	var set_texture_off = load("res://common_textures/pixel_transp.png")
	$Slot1/Sprite2D.set_texture(set_texture)
	$Slot2/Sprite2D.set_texture(set_texture_off)
	functions.saveSlot=1
	functions.save_settings(false)
	functions.init_save()


func _on_slot_2_mouse_entered():
	var set_texture = load("res://Options/textures/options_save_selected.png")	
	$Slot2/Sprite2D.set_texture(set_texture)



func _on_slot_2_mouse_exited():
	var set_texture = load("res://common_textures/pixel_transp.png")	
	if functions.saveSlot!=2:
		$Slot2/Sprite2D.set_texture(set_texture)


func _on_slot_2_button_down():
	var set_texture = load("res://Options/textures/options_save_selected.png")	
	var set_texture_off = load("res://common_textures/pixel_transp.png")
	$Slot2/Sprite2D.set_texture(set_texture)
	$Slot1/Sprite2D.set_texture(set_texture_off)
	functions.saveSlot=2
	functions.save_settings(false)
	functions.init_save()


func _on_screen_button_down(extra: int) -> void:
	print("troca_monitor", extra)
	print("POSICAO DA TELA: ",DisplayServer.window_get_position())
	print("tamanho DA TELA: ",DisplayServer.window_get_size())
	if functions.initscreen!=extra:
		functions.initscreen=extra
		
		
		var telas = $multiScreen.get_children()
		var countatelas = 0
		for child in telas:
			if countatelas==extra:
				child.texture_normal = load("res://Options/textures/screen_on.png")
			else:
				child.texture_normal = load("res://Options/textures/screen_off.png")
			countatelas+=1
	else:
		functions.resolution=DisplayServer.window_get_size()
		var wpos := DisplayServer.window_get_position()
		if wpos.x<0:
			wpos.x=0
		if wpos.y<0:
			wpos.y=0
		functions.scr_pos=wpos
	functions.save_settings(true)
	functions.aspect_ratio_reload()




















	
	
	
func _on_close_button_down() -> void:
	if changing!=true:
		MusicController.playSFX(backSound)
		changing=true
		tweenChange()



	
	
func tweenChange(prel=""):
	stopscene=true
	if prel!="":
		#print("OREL: ", prel)
		SChanger._LoadNewScene(prel, self)
	timer.start(timeTrans) 
	Curtain.showCurtain(inColor, outColor, .6, 1)
		
			
func _on_timer_change_timeout():
	if SChanger.loadStatus()==100:
		iHint.timerhint.stop()
		mouse_cursor.z_index=4096

		SChanger._change()
		queue_free()
		
	else:
		timer.start(.05)	
