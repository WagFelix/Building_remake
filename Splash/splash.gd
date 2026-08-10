extends Control
@onready var fadein := $AnimationPlayer
@onready var opening := $Container/AnimatedSprite2D
@onready var timer_change := $TimerDevcats
#@onready var googlesignInClient :PlayGamesSignInClient = $PlayGamesSignInClient

var optLang = ["Eng", "Por", "Kor", "Sch", "Jap",  "Rus", "Spa", "Spa", "Ger", "Fre", "Tur", "Pol", "Ita", "Ukr"]


var optLangSteam = ["english", "brazilian", "koreana", "schinese", "japanese", "russian", "latam", "spanish", "german", "french", "turkish", "polish", "italian", "ukrainian"]

#const BillingScript = preload("res://GLOBAL/google/billing_manager.gd")
#var billing_manager



#func _enter_tree() -> void:
	#GodotPlayGameServices.initialize() #inicializa o plugin google play... da erro em pc, nao se preocupem

#func androidAuth():
	#if not GodotPlayGameServices.android_plugin:
		#printerr("android plugin not founded")
		#
	#else:
		#googlesignInClient.is_authenticated()
		##get_tree().quit()	
		#
#func _process(_delta):
	#$DebugBill.text = billing_manager.status
	
#func _on_billing_checked(has_access: bool):
#
	#if has_access:
		#print("Usuário possui acesso")
	#else:
		#print("Usuário NÃO possui acesso")
		##res://GLOBAL/google/noAcess.tscn
		## troca de cena
		##SChanger._LoadNewScene("res://GLOBAL/google/noAcess.tscn", self)
		##get_tree().change_scene_to_file("res://GLOBAL/google/noAcess.tscn")
				
func _ready()->void:
	functions.inMenu=true
	SChanger._LoadNewScene("res://Intro/Intro.tscn", self)
	#androidAuth()
	
	
	#billing_manager = BillingScript.new()
	#add_child(billing_manager)
	#billing_manager.purchase_check_finished.connect(_on_billing_checked)

	
	#SChanger._LoadNewScene("res://Menu/menu_teste.tscn", self)
	$TimerInit.start(.2)
	$TimerFadeout.start(4.1)
	timer_change.start(4.8)
	$TimerLoading.start(2.2)
	#print(scene.GetStatus())
	MusicController.playSFX("res://Splash/Sounds/devcats_splash.mp3", 1, 0.91)
	
	functions.load_settings()
	########### trecho abaixo pra selecao de lingua automatica baseada na steam ################
	if functions.firstIntroLang==true:
		#functions.langChoice="Eng" # só na demo
		#var SteamLang = Steam.getSteamUILanguage()
		#var _choiceL = false
		#if SteamLang=="portuguese":
			#SteamLang="brazilian"
		#var theLang = optLangSteam.find(SteamLang)
		#if theLang>-1 and theLang!=null:
			#functions.langChoice=optLang[theLang]
		functions.firstIntroLang=false
		functions.save_settings()
	
	######################################################
	#####################################################
	
	functions.save_settings()






func _on_timer_init_timeout()->void:
	fadein.play("default")


func _on_animation_player_animation_finished(_anim_name)->void:
	opening.play("default")

#func change_scene()->void:
	#SChanger._change()
	#queue_free() #será que precisaremos disso?
	#print_orphan_nodes()


func _on_timer_change_timeout()->void:
	if SChanger.loadStatus()==100:
		Curtain.get_node("Loading").modulate=Color(1,1,1,0)
		SChanger._change()
	else:
		timer_change.start(.05)	




func _on_timer_loading_timeout()->void:
	pass


func _on_timer_fadeout_timeout()->void:
	$AnimationPlayer2.play("fadeout")
	#pass
