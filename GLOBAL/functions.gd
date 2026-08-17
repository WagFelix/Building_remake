extends Node

var scene : = ""

var max_fps :int= 120
#var plataforma = "GoG"
var plataforma := "Steam"
#var plataforma := "mobile"

var viewport_size: Vector2i

#var savelocation := "user://"

const SAVE_PATH := "res://settings.cfg"
var arquivoCFG := ConfigFile.new()


var whereIWas := "hall"


const PROGRESS_PATH : = "res://progress.sav"
var arquivoPROGRESS : = ConfigFile.new()

const PROGRESS_PATH2 : = "res://progress2.sav"
var arquivoPROGRESS2 : = ConfigFile.new()


const PROGRESS_BK5 : = "res://progress_BK5.sbk"
const PROGRESS_BK13 : = "res://progress_BK13.sbk"
#var arquivoPROGRESS_BK : = ConfigFile.new()

var savedictionary := {
	resolution = Vector2(1600, 900),
	scr_pos = Vector2(30, 30),
	window_mode = 4 , #	 0-window, 1-minimized, 2-maximized, 3-fullscreen , 4-fullscreen exclusive
	initscreen = 1,
	SFXV = 100,
	MUSICV = 100,
	AMBIENCEV = 100,
	langChoice = "Eng",
	scrollSens= .06,
	cursorSize = 1,
	saveSlot = 1
}
var resolution : Vector2
var window_mode : int
var SFXV : int
var MUSICV : int
var AMBIENCEV : int
var initscreen : int
var langChoice := "Eng"
var scrollSens: float
var cursorSize: int
var saveSlot: int
var scr_pos: Vector2

var SavePath:= ""
var arquivoPath : = ConfigFile.new()

var save_config := false




var firstIntro := true
var firstIntroLang = true


var inMenu := false



class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false
		

func _ready() -> void:
	
	#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

	Engine.max_fps = max_fps
	var loadOK = arquivoCFG.load(SAVE_PATH) 
	if (loadOK != OK):
		create_settings()
		_ready()
	load_settings()
	aspect_ratio_reload()
	print("666")
	init_save()
	print("777")
	#androidAuth()






func aspect_ratio_reload()->void:
	var root_window := get_tree().root
	var screen_size := DisplayServer.screen_get_size()

	# resolução base do projeto
	var base_width  := int(ProjectSettings.get_setting("display/window/size/viewport_width"))
	var base_height := int(ProjectSettings.get_setting("display/window/size/viewport_height"))
	var base_aspect := float(base_width) / float(base_height)

	# proporção do monitor
	var screen_aspect := float(screen_size.x) / float(screen_size.y)

	root_window.set_content_scale_mode(Window.CONTENT_SCALE_MODE_CANVAS_ITEMS)

	if screen_aspect >= base_aspect:
		# monitor mais largo → altura fixa, largura proporcional
		root_window.set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_KEEP_HEIGHT)
	else:
		# monitor mais alto → largura fixa, altura proporcional
		root_window.set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_KEEP_WIDTH)

	root_window.set_content_scale_size(Vector2i(base_width, base_height))

	print("Monitor:", screen_size, "| Base:", Vector2i(base_width, base_height))
	print("Content scale mode e aspect aplicados:", root_window.get_content_scale_mode(), "-", root_window.get_content_scale_aspect())
	viewport_size = get_viewport().get_visible_rect().size
	#last_size = DisplayServer.window_get_size()
	print("Tamanho atual do viewport:", viewport_size)

	
		



func saveitem(item, values):
	arquivoPath.set_value("Itens", str(item), values)
	arquivoPath.save(SavePath)
	
func loaditem(item):
	var loadOK = arquivoPath.load(SavePath)
	if (loadOK == OK):
		var theItem =  arquivoPath.get_value("Itens",str(item))
	
		return(theItem)
	else:
		return(null)

	
func init_save():
	arquivoPath.clear()
	if saveSlot==1:
		SavePath = PROGRESS_PATH
		arquivoPath = arquivoPROGRESS
	else:
		SavePath = PROGRESS_PATH2
		arquivoPath = arquivoPROGRESS2
	var _loadOK = arquivoPath.load(SavePath) #garante o que vem pra memória
	
	
func saveroom(item, values=false):
	arquivoPath.set_value("RoomVisited", str(item), values)
	arquivoPath.save(SavePath)


func loadroom(item):
	var loadOK = arquivoPath.load(SavePath)
	if (loadOK == OK):
		var theItem =  arquivoPath.get_value("RoomVisited",str(item))
		return(theItem)
	else:
		return(false)

func saveGeneral(item, values, section="States"):
	arquivoPath.set_value(str(section), str(item), values)
	arquivoPath.save(SavePath)

func loadGeneral(item, section="States"):
	var loadOK = arquivoPath.load(SavePath)
	if (loadOK == OK):
		#var theItem =  arquivoPath.get_value(str(section),str(item), false)
		var theItem =  arquivoPath.get_value(str(section),str(item), ["fail"])
		print("THEITEM: ", theItem, " tipo: ", typeof(theItem))
		
		if typeof(theItem)>=27 and typeof(theItem)<=37:
			if theItem==["fail"]:
				theItem=null

		return(theItem)
	else:
		return(null)

func saveextra(qtype, values):
	arquivoPath.set_value("extra", qtype, values)
	arquivoPath.save(SavePath)
	
func loadextra(qtype):
	var loadOK = arquivoPath.load(SavePath) 
	if (loadOK == OK):
		var theextra = arquivoPath.get_value("extra", str(qtype), false)
		return(theextra)
	else:
		return(null)

		
func savecats(qroom, qtype, values):
	arquivoPath.set_value(str(qroom), qtype, values)
	arquivoPath.save(SavePath)
	#arquivoPath.save(PROGRESS_BK)
	
			
func loadcats(qroom):
	var loadOK = arquivoPath.load(SavePath) 
	if (loadOK == OK):
		# print("LOADOK ", qroom)
		var roomDiscover = arquivoPath.get_value(str(qroom), "roomDiscover", ["fail"])
		if roomDiscover==["fail"]:
			roomDiscover=null
			
		var roomDiscoverHidden = arquivoPath.get_value(str(qroom), "roomDiscoverHidden", ["fail"])
		if roomDiscoverHidden==["fail"]:
			roomDiscoverHidden=null
			
		var roomHidden = arquivoPath.get_value(str(qroom), "roomHidden", ["fail"])
		if roomHidden==["fail"]:
			roomHidden=null
			
		var hintLeft = arquivoPath.get_value(str(qroom), "hintLeft", 99)
		if hintLeft==99:
			hintLeft=null
			
		var roomExtras = arquivoPath.get_value(str(qroom), "roomExtras", ["fail"])
		if roomExtras==["fail"]:
			roomExtras=null

		
		return([roomDiscover, roomDiscoverHidden, roomHidden, hintLeft, roomExtras])
	else:
		return([null, null, null, null, null])


func create_settings():
	for key in savedictionary:
		# Add values to file 
		arquivoCFG.set_value("Config",key,savedictionary[key]) 
		#arquivoCFG.save(SAVE_PATH)
		arquivoCFG.save(SAVE_PATH)
		#print("criou?")

func load_settings():
	print("LOADANDO CONFIG")
	window_mode = arquivoCFG.get_value("Config", "window_mode") 
	resolution = arquivoCFG.get_value("Config", "resolution")
	#var scrTEMP =   arquivoCFG.get_value("Config", "scr_pos") #no proximo, eliminar isso
	#if scrTEMP==null:
		#scrTEMP=Vector2(30,30)
	#print("SCREENPOS before: ", scrTEMP)	
	#var safePosition = DisplayServer.screen_get_size()
	#print("safePosition: ", safePosition)
	#if safePosition.x<= scrTEMP.x or safePosition.y<= scrTEMP.y: #vamos garantir que a janela nao vai ficar fora da tela
		#scrTEMP.x = (safePosition.x/2)-(resolution.x/2)
		#scrTEMP.y = (safePosition.y/2)-(resolution.y/2)
		#
	#if scrTEMP.x<0:
		#scrTEMP.x=40
	#if scrTEMP.y<0:
		#scrTEMP.y=40
	#scr_pos =scrTEMP
	#
	#print("SCREENPOS: ", scr_pos.x)
	#print("scrTEMP: ", scrTEMP.x)
	print("222")
	SFXV = arquivoCFG.get_value("Config", "SFXV") 
	scrollSens = arquivoCFG.get_value("Config", "scrollSens")
	MUSICV = arquivoCFG.get_value("Config", "MUSICV") 
	AMBIENCEV = arquivoCFG.get_value("Config", "AMBIENCEV") 
	langChoice = arquivoCFG.get_value("Config", "langChoice") 
	firstIntroLang = arquivoCFG.get_value("firstIntroLang", "first")
	print("333")
	if arquivoCFG.get_value("Config", "cursorSize") == null:
		cursorSize=1
		arquivoCFG.set_value("Config","cursorSize",1)
		arquivoCFG.save(SAVE_PATH)
	else:
		cursorSize = int(arquivoCFG.get_value("Config", "cursorSize") )
	
	if arquivoCFG.get_value("Config", "initscreen") == null:
		initscreen=DisplayServer.get_primary_screen()
		arquivoCFG.set_value("Config","initscreen",0) 
		arquivoCFG.save(SAVE_PATH)
	else:
		initscreen = int(arquivoCFG.get_value("Config", "initscreen"))
		if DisplayServer.get_screen_count()<2 and arquivoCFG.get_value("Config", "initscreen")!=0:
			arquivoCFG.set_value("Config","initscreen",0) 
			arquivoCFG.save(SAVE_PATH)
		
	if arquivoCFG.get_value("Config", "saveSlot") == null:
		saveSlot=1
		arquivoCFG.set_value("Config","saveSlot",1)
		arquivoCFG.save(SAVE_PATH)
	else:
		saveSlot = int(arquivoCFG.get_value("Config", "saveSlot") )	
	
		
		
	if firstIntro==null:
		firstIntro=true
	if firstIntroLang==null:
		print("LANGNULLLLL")
		firstIntroLang=true

	print("444")
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(SFXV/float(100)))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musicas"), linear_to_db(MUSICV/float(100)))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), linear_to_db(AMBIENCEV/float(100)))
	

	DisplayServer.window_set_mode(window_mode)
	DisplayServer.window_set_size(resolution)
	#DisplayServer.window_set_position(scr_pos)

	DisplayServer.window_set_current_screen(initscreen)
	print("555")



	
func save_settings(loadsettings=true):
	arquivoCFG.set_value("Config","MUSICV", MUSICV) 
	arquivoCFG.set_value("Config","SFXV", SFXV) 
	arquivoCFG.set_value("Config","AMBIENCEV", AMBIENCEV) 
	arquivoCFG.set_value("Config","scrollSens", scrollSens) 
	arquivoCFG.set_value("Config","langChoice", langChoice) 
	arquivoCFG.set_value("Config","window_mode", window_mode) 
	arquivoCFG.set_value("Config","cursorSize", cursorSize) 
	arquivoCFG.set_value("Config","initscreen", initscreen) 
	arquivoCFG.set_value("Config", "resolution", resolution) 
	arquivoCFG.set_value("Config", "scr_pos", scr_pos) 
	
	arquivoCFG.set_value("firstIntro","first", firstIntro) 
	arquivoCFG.set_value("firstIntroLang","first", firstIntroLang) 
	arquivoCFG.set_value("Config","saveSlot", saveSlot) 
	
	arquivoCFG.save(SAVE_PATH)
	save_config=false
	if loadsettings==true:
		load_settings()



	




func choose(choices):
	randomize()
	var rand_index = randi() % choices.size()
	return choices[rand_index]
	
	
func choose_multi(choices, howmany):
	randomize()
	var choosen = []
	for i in range(howmany):
		var disposable = randi() % choices.size()
		var rand_index = choices[disposable]
		print("Escolhido ", i, ": ", rand_index)
		choices.remove(disposable)
		choosen.push_back(rand_index)
		
	return choosen

func find_Index(search_for, arrWK):
	for i in range(arrWK.size()):
		if arrWK[i].find(search_for) != -1:
			return (i)
		i += 1
	return (-1)
	

#####################################################################################
##################### A partir daqui coisas pra criaçao #############################
##################### de areas e binds automaticos      ############################# #####################################################################################

func create_collision_from_sprite(
	sprite: Sprite2D,
	alpha_threshold := 0.1,
	simplification := 2.0,
	grow := 1.9
):
	if sprite.texture == null:
		push_error("Sprite2D sem textura")
		return

	var image := sprite.texture.get_image()
	image.convert(Image.FORMAT_RGBA8)

	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(image, alpha_threshold)

	var polygons := bitmap.opaque_to_polygons(
		Rect2(Vector2.ZERO, image.get_size())
	)

	if polygons.is_empty():
		push_warning("Nenhum polígono gerado")
		return

	#  PARA CADA "ILHA" OPACA
	for polygon in polygons:
		# Segurança mínima
		if polygon.size() < 3: #garantimos que detectou um poligono
			continue

		# Simplification (Douglas–Peucker)
		if simplification > 0.0:
			polygon = _simplify_polygon_dp(polygon, simplification)

		# Grow / Shrink
		if grow != 0.0:
			var grown := Geometry2D.offset_polygon(
				polygon,
				grow,
				Geometry2D.JOIN_ROUND
			)
			if grown.size() > 0:
				polygon = grown[0]

		var collision := CollisionPolygon2D.new()
		collision.polygon = polygon

		# Offset correto
		collision.position = -image.get_size() * 0.5

		sprite.get_parent().add_child(collision)
		collision.owner = sprite.owner


#########################################################################################
# Douglas–Peucker simplification (pra uso na criaçao de collisionpolygon2D automaticos) #
#########################################################################################

func _simplify_polygon_dp(
	points: PackedVector2Array,
	epsilon: float
) -> PackedVector2Array:
	if points.size() < 3:
		return points

	var dmax := 0.0
	var index := 0
	var end := points.size() - 1

	for i in range(1, end):
		var d := _point_line_distance(
			points[i],
			points[0],
			points[end]
		)
		if d > dmax:
			index = i
			dmax = d

	if dmax > epsilon:
		var rec1 := _simplify_polygon_dp(
			points.slice(0, index + 1),
			epsilon
		)
		var rec2 := _simplify_polygon_dp(
			points.slice(index, end + 1),
			epsilon
		)
		return rec1.slice(0, rec1.size() - 1) + rec2

	return PackedVector2Array([points[0], points[end]])

func has_collision_polygon(node: Node) -> bool:
	for child in node.get_children():
		if child is CollisionPolygon2D:
			return true
	return false
	
func _point_line_distance(
	point: Vector2,
	line_start: Vector2,
	line_end: Vector2
) -> float:
	var line := line_end - line_start
	var len_sq := line.length_squared()

	if len_sq == 0.0:
		return point.distance_to(line_start)

	var t := ((point - line_start).dot(line)) / len_sq
	t = clamp(t, 0.0, 1.0)

	var projection := line_start + line * t
	return point.distance_to(projection)
	
