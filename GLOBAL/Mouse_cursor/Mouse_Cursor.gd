extends Node2D
#var last_position : Vector2

var cursor_images := [load("res://common_textures/Cursor.png"),
]
var cursor_images2 := [load("res://common_textures/Cursor2.png"),
]
var cursorAtual = 0


var mobile_hide:=true
#var mobile_hide:=false

func _ready() ->void:
	$Sprite_Cursor.visible=true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	change_cursor()
	#Engine.max_fps = 120	
	if functions.plataforma=="mobile":
		#if mobile_hide==true:
			#$Sprite_Cursor.visible=false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		

func _input(event: InputEvent) -> void:
	
	# TOUCH
	if event is InputEventScreenTouch:
		
		# ignora touch emulado pelo mouse
		if event.device == -1:
			return
		
		if event.pressed:
			print("TOUCH REAL")
			if mobile_hide!=true:
				$Sprite_Cursor.visible=true
			else:
				$Sprite_Cursor.visible=false
	elif event is InputEventScreenDrag:	
		if event.device == -1:
			return
		else:
			# print("arrasto")	
			if mobile_hide!=true:
				$Sprite_Cursor.visible=true
			else:
				$Sprite_Cursor.visible=false
	
	# MOUSE
	elif event is InputEventMouseButton:
		
		# ignora mouse emulado pelo touch
		if event.device == -1:
			return
		
		if event.pressed:
			# print("MOUSE REAL")
			$Sprite_Cursor.visible=true
	
	
	# TECLADO
	elif event is InputEventKey:
		if event.pressed:
			# print("TECLADO")
			$Sprite_Cursor.visible=true
	
	
	# JOYSTICK
	elif event is InputEventJoypadButton:
		if event.pressed:
			# print("JOYSTICK")
			$Sprite_Cursor.visible=true
	
	
	# ANALÓGICO
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.5:
			# print("ANALÓGICO")
			$Sprite_Cursor.visible=true
	
	
	
			
	


		
		
func change_cursor(type=0):
	print("mouse cursor, ", functions.cursorSize)
	var offSetPointx = 12
	var offSetPointy = 2
	var wCursor := cursor_images
	if functions.cursorSize==2:
		offSetPointy = 4
		offSetPointx = 23
		wCursor = cursor_images2
		print("cursor grande")
	$Sprite_Cursor.position=Vector2(offSetPointx*-1, offSetPointy*-1)
	#Input.set_custom_mouse_cursor(wCursor[type], Input.CURSOR_ARROW, Vector2(offSetPointx, offSetPointy))	#vamos deixar isso aqui de fora, por enquanto, deixar o cursor do sistema intocado
	$Sprite_Cursor.set_texture(wCursor[type])
	
	
	cursorAtual=type
	if functions.plataforma=="mobile":
		if mobile_hide==true:
			$Sprite_Cursor.visible=false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)



	

func togglemouse() -> void: #vamos tentar nao usar mais isso
	#pass
	if $Sprite_Cursor.visible==false:
		$Sprite_Cursor.visible=true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		$Sprite_Cursor.visible=false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if functions.plataforma=="mobile":
		if mobile_hide==true:
			$Sprite_Cursor.visible=false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)	
	
	
func _process(_delta) -> void:
	if Input.is_action_pressed("mouse_sprite_toggle") and $Cooldown.is_stopped():
		$Cooldown.start(.2)
		togglemouse()
	var new_position = self.get_global_mouse_position()
	
	#if get_viewport().get_mouse_position().y<0 or get_viewport().get_mouse_position().y>1080 or get_viewport().get_mouse_position().x<0 or get_viewport().get_mouse_position().x>1920:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #mostra mouse do sistema
	#else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#
	#if new_position.x<0:
		#new_position.x=0
	#if new_position.y<0:
		#new_position.y=0
	#if new_position.x>1920:
		#new_position.x=1920
	#if new_position.y>1080:
		#new_position.y=1080


	if self.position!=new_position:
		self.position=new_position

func _showMouse(_show=true)-> void : #desabilitado por enquanto
	pass
