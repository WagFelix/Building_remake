extends Node
# Set up some global Steam variables
var IS_OWNED: bool = false
var IS_ONLINE: bool = false
var STEAM_ID: int = 0
var STEAM_USERNAME: String

 
func _ready() -> void:
	# Start Steamworks  
	_initialize_Steam()


# Initializing Steamworks
func _initialize_Steam() -> void:
	# Get the initialization dictionary from Steam
	#var INIT: Dictionary = Steam.steamInit() #nao funciona mais
	var INIT: Dictionary = Steam.steamInitEx()
	# If the status isn't one, print out the possible error and quit the program
	if INIT['status'] != 1:
		print("[STEAM] Failed to initialize: "+str(INIT['verbal'])+" Shutting down...")
		#get_tree().quit()
		#GlobalWorldEnvironment.showDebug()

	# Acquire information about the user
	IS_ONLINE = Steam.loggedOn()
	STEAM_ID = Steam.getSteamID()
	IS_OWNED = Steam.isSubscribed()
	STEAM_USERNAME = Steam.getPersonaName()
	print("STEAM: ", STEAM_ID, STEAM_USERNAME)
	# Check if account owns the game
	if IS_OWNED == false:
		print("[STEAM] User does not own this game")
#		GlobalWorldEnvironment.showDebug()
		# Uncomment this line to close the game if the user does not own the game
#		get_tree().quit()


# Process all Steamworks callbacks
func _process(_delta: float) -> void:
	Steam.run_callbacks()


func verifyDone():
#	if (achievHolder[7][1]==true) and (achievHolder[8][1]==true) and (achievHolder[9][1]==true) and (achievHolder[10][1]==true) and (achievHolder[11][1]==true) :
#		return true
#	else:
		return false
	
	
func _give(ach):
#	if functions.xablau!=true:
#		if functions.normalMode==true:
#			ach=ach+"_normal"
		var _setachievWK = Steam.setAchievement(ach)
		var _storestatsWK = Steam.storeStats()
		#var whereAch = functions.find_Index(ach, achievHolder)
		#if whereAch>=0:
			#achievHolder[whereAch][1]=true
		print("DADO: ", ach)
#		MusicController.playSFX("res://SFX/zipper.mp3", 1, 0)
	

func _statPlus(_ach):
	pass
#	var actualValueWK: int = Steam.getStatInt(_ach)
#	var _newvalueWK = actualValueWK+1
#	var IS_SET: bool = false
#	IS_SET = Steam.setStatInt(_ach, int(_newvalueWK))
#	var _disposableStore= Steam.storeStats()
#	if functions.xablau!=true:
#		var loadSCORE = arquivoSCORE.load_encrypted_pass(SCORE_PATH, functions.caracracha) 
#		if (loadSCORE != OK):
#			functions.create_score()
#		var actualValue = arquivoSCORE.get_value("achiev", _ach, 0)
#		if actualValue==null:
#			actualValue=0
#		var newvalue = actualValue+1
#		print(newvalue)
#		arquivoSCORE.set_value("achiev",_ach,newvalue) 
#		arquivoSCORE.save_encrypted_pass(SCORE_PATH, functions.caracracha)
	


func getStat(_ach):
	pass
#	var actualValueWK: int = Steam.getStatInt(_ach)
#	return(actualValueWK)
#	var loadSCORE = arquivoSCORE.load_encrypted_pass(SCORE_PATH, functions.caracracha) 
#	if (loadSCORE != OK):
#		functions.create_score()
#	var actualValue = arquivoSCORE.get_value("achiev", _ach)
#	if actualValue==null:
#		actualValue=0
#	return(actualValue)
#
#func _getAllAchievs():
#	var ACHIEVE = []
#	for i in range(0, achievHolder.size()):
#		ACHIEVE = Steam.getAchievement(achievHolder[i][0])
#		achievHolder[i][1] = ACHIEVE['achieved']
		
