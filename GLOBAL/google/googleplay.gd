extends Node2D
#apenas como exemplo
@onready var googlesignInClient :PlayGamesSignInClient= $PlayGamesSignInClient



func _enter_tree() -> void:
	GodotPlayGameServices.initialize() #inicializa o plugin google play... da erro em pc, nao se preocupem
	
	
func _ready() -> void:
	androidAuth()
	
func androidAuth():
	if not GodotPlayGameServices.android_plugin:
		printerr("android plugin not founded")
		$Label.text = "Plugin Not Found!"
	else:
		googlesignInClient.is_authenticated()
		#googlesignInClient.sign_in()
		$Label.text = ""

func _giveAch(ach) -> void:
	$PlayGamesAchievementsClient.unlock_achievement(ach)
	#$Label.text = ach
