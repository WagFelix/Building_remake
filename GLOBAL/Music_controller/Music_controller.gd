extends Node2D

const SAVE_VOLUME := "res://sound_volumes.vol" #em plataformas como android, isso tem que ficar no user://
var volumeCFG := ConfigFile.new()



@onready var playerMusic = $AudioStreamPlayer
@onready var playerAmbience = $AudioStreamPlayer2


@onready var playerSFX = $AudioStreamSFX
@onready var playerSFX1 = $AudioStreamSFX
@onready var playerSFX2 = $AudioStreamSFX2
@onready var playerSFX3 = $AudioStreamSFX3


var ambienceList = [ 
	"res://AmbienceSFX/ambience_cutscene.mp3", #0
	"res://AmbienceSFX/sfx_lake_ambience.ogg", #1 Puurzen
	"res://AmbienceSFX/sfx_gym_ambience.ogg", #2 #Gyn
	
]

var musicList = [ 
	"res://Music/mainmenu.mp3", 	#0
	"res://Music/floor1.mp3", #1
	"res://Music/floor2.mp3", #2
	"res://Music/floor3.mp3", #3
	"res://Music/floor4.mp3", #4
	"res://Music/floor5.mp3", #5
	"res://Music/roof.mp3", #6
	"res://Music/bunker.mp3", #7
	
	
	
]


var tocando = -1
var tocandoAmbience = -1
var playingAll = false
var themusic = ""
var themusicVolume: float = 1
var theambienceVolume: float = 1
var theambience = ""
var slowdown : float = 1
var finished = true
var dontPlay = false
var TweenAudio : Tween
var TweenStop : Tween

func _ready():
	var _loadOK = volumeCFG.load(SAVE_VOLUME)
	
	TweenAudio = create_tween()
	TweenStop = create_tween()
	TweenAudio.stop()
	TweenStop.stop()
	TweenAudio.finished.connect(_on_TweenAudio_tween_completed)
	TweenStop.finished.connect(_on_TweenStop_tween_all_completed)
	
	TweenAudio.set_trans(Tween.TRANS_LINEAR)
	TweenAudio.set_ease(Tween.EASE_OUT)
	TweenAudio.tween_property(playerMusic, "volume_db", -60, .92)
	
	TweenStop.set_trans(Tween.TRANS_LINEAR)
	TweenStop.set_ease(Tween.EASE_OUT)
	TweenStop.tween_property(playerMusic, "volume_db", -60, .92)

	
	playerMusic = $AudioStreamPlayer
	
	playerMusic.set_bus("Musicas")
	playerAmbience = $AudioStreamPlayer2
	playerAmbience.set_bus("Ambience")
	print("music controller iniciated")


func loadvolume(soundfile, tipo): #devolver o volume especial do item
	var slices = soundfile.get_slice_count("/")
	soundfile = soundfile.get_slice("/", slices-1)
	var cVolume = volumeCFG.get_value(tipo, soundfile)  
	print("Volume custom: ", cVolume)
	return(cVolume)

func playSFX(sfxsound, volume=1.0, waitTime=0.000, canal=1, velocidade=1.0):	
	var cVolume = loadvolume(sfxsound, "sfx")
	#print("Sound: ", sfxsound)
	if cVolume!=null:
		volume=float(cVolume) #ajusta volume custom do arquivo
	VolumeEditor.mostra(sfxsound, volume, "sfx")
	if canal==2:
		playerSFX2.set_bus("SFX")
		playerSFX2.stream = load(sfxsound)
		playerSFX2.set_volume_db(linear_to_db(volume))
		playerSFX2.set_pitch_scale(velocidade)	
	elif canal==1:	
		playerSFX.set_bus("SFX")
		playerSFX.stream = load(sfxsound)
		playerSFX.set_volume_db(linear_to_db(volume))
		playerSFX.set_pitch_scale(velocidade)	
	elif canal==3:
		playerSFX3.set_bus("SFX")
		playerSFX3.stream = load(sfxsound)
		playerSFX3.set_volume_db(linear_to_db(volume))
		playerSFX3.set_pitch_scale(velocidade)	
	if waitTime==0:
		#print("nowait")
		if canal==3:
			_on_soundTimer3_timeout()
		elif canal==2:
			_on_soundTimer2_timeout()
		else:
			_on_soundTimer_timeout()
	else:
		if canal==3:
			$soundTimer3.start(waitTime)
		elif canal==2:
			$soundTimer2.start(waitTime)
		else:
			$soundTimer.start(waitTime)
	
func _on_soundTimer_timeout():
	#print("playing sfx1")
	playerSFX.play()
	
func _volume(novovolume, _bus):
	#print("VOLUEM: ", novovolume)
	var nvolume = linear_to_db(float(novovolume)/float(100))
	if nvolume != 0:
		nvolume+=-6
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(_bus), nvolume)

		
func _playAmbience(mType, wslowdown=1.0, timestop=.3):
	var playMusic = false
	
	dontPlay = false
	if mType!=tocandoAmbience:# or slowdown!=wslowdown:
		playMusic=true
		tocandoAmbience=mType
	if slowdown!=wslowdown:
		playerAmbience.set_pitch_scale(wslowdown)	
	slowdown=wslowdown	
	if(mType==99):#para de tocar
		playMusic=true
		dontPlay = true
		tocandoAmbience=-1
			
	if playMusic==true:
		if mType!=99:
			theambience=ambienceList[mType]
			var cVolume = loadvolume(theambience, "ambience")
			if cVolume!=null:
				var qvolume=float(cVolume) #ajusta volume custom do arquivo
				theambienceVolume=qvolume
			TweenAudio = create_tween()
			TweenAudio.stop()
			TweenAudio.finished.connect(_on_Ambience_TweenAudio_tween_completed)
			TweenAudio.set_trans(Tween.TRANS_LINEAR)
			TweenAudio.set_ease(Tween.EASE_OUT)
			TweenAudio.tween_property(playerAmbience, "volume_db", -60, .92)

			TweenAudio.play()
		else:
			stopAmbience(timestop)
		
func _playMusic(mType, wslowdown:float=1.0, timestop=.3, qvolume:float=1):
	var playMusic = false
	
	dontPlay = false
	if mType!=tocando:# or slowdown!=wslowdown:
		playMusic=true
		print("trocou de musica, antes tocava ",tocando, ", agora toca ",  mType)
		tocando=mType
		
	if slowdown!=wslowdown:
		playerMusic.set_pitch_scale(wslowdown)	
	slowdown=wslowdown	
	if(mType==99):#para de tocar
		print("para de tocar a musica")
		playMusic=true
		dontPlay = true
		tocando=-1
			
	if playMusic==true:
		print("entramos nos fades da musica")
		if mType!=99:
			themusic=musicList[mType]
			var cVolume = loadvolume(themusic, "music")
			if cVolume!=null:
				qvolume=float(cVolume) #ajusta volume custom do arquivo
			themusicVolume=qvolume
			TweenAudio = create_tween()
			TweenAudio.stop()
			TweenAudio.finished.connect(_on_TweenAudio_tween_completed)
			TweenAudio.set_trans(Tween.TRANS_LINEAR)
			TweenAudio.set_ease(Tween.EASE_OUT)
			TweenAudio.tween_property(playerMusic, "volume_db", -60, .92)

			TweenAudio.play()
		else:
			stopMusic(timestop)




func stopAmbience(timestop=.3):
	TweenStop = create_tween()
	TweenStop.stop()
	TweenStop.finished.connect(_on_TweenStop_Ambience_tween_all_completed)
	TweenStop.tween_property(playerAmbience, "volume_db", -60, timestop)
	TweenStop.play()


func stopMusic(timestop=.3):
	TweenStop = create_tween()
	TweenStop.stop()
	TweenStop.finished.connect(_on_TweenStop_tween_all_completed)
	TweenStop.tween_property(playerMusic, "volume_db", -60, timestop)
	TweenStop.play()


func _on_Ambience_TweenAudio_tween_completed():
	if theambience!="" and theambience !="res://":
		playerAmbience.stream = load(theambience)
	if dontPlay==false:
		playerAmbience.set_pitch_scale(slowdown)
		playerAmbience.play()
		playerAmbience.set_volume_db(linear_to_db(theambienceVolume))
	#playerAmbience.volume_db=0
	
	
#func _on_TweenAudio_tween_completed(_object, _key):
func _on_TweenAudio_tween_completed():
	if themusic!="" and themusic !="res://":
		playerMusic.stream = load(themusic)
	if dontPlay==false:
		playerMusic.set_pitch_scale(slowdown)
		playerMusic.play()
		playerMusic.set_volume_db(linear_to_db(themusicVolume))
	print("TWEENZOU ", themusic)
	print("dontplay ", dontPlay)
	#playerMusic.volume_db=0


func _on_soundTimer2_timeout():
	print("playing sfx2")
	playerSFX2.play()


func _on_soundTimer3_timeout():
	print("playing sfx3")
	playerSFX3.play()


func _on_specifcMusic_timeout():
	playerMusic.play()

func _on_TweenStop_Ambience_tween_all_completed():
	playerAmbience.stop()


func _on_TweenStop_tween_all_completed():
	playerMusic.stop()
