extends Control
@onready var RootNode: Control = get_parent()

var hudHight: int = 158
var andar : int = 1

@export var counterColor := Color(1,1,1,1)
@export var counterHidColor := Color(1,1,1,1)

func _ready() -> void:
	andar = GlobalPanel.andar
	print("ANDARRRRR ", andar)
	self.position = Vector2(-get_viewport().get_visible_rect().size.x / 2 + hudHight, -get_viewport().get_visible_rect().size.y / 2)
	$Counters/Counter.add_theme_color_override("font_color", counterColor)
	$Counters/Hidden/CounterHid.add_theme_color_override("font_color", counterColor)
	
	var spriteBG = "res://Game/_common_textures/counter/floor0"+str(andar)+"-counter.png"
#	if functions.wfloor==7:
	$Counters/bg.set_texture(load(spriteBG))
	
	
	var spriteLupa = "res://Game/_common_textures/glass/floor"+str(andar)+"-hint.png"
#	if functions.wfloor==7:
	$Hint/Hint/Hint2.set_texture(load(spriteLupa))
	$Hint/HintCharge.set_texture(load(spriteLupa))
	$Hint/HintCharge/HintCharge.set_texture(load(spriteLupa))
	
	#$hide_area.visible = true
	#$Counters/Hidden.visible=true


# ---- HINT
func _on_hint_button_button_down() -> void:
	get_parent()._on_Hint_input_event_Button()

func _on_timer_zoom_timeout() -> void:
	get_parent()._on_timer_zoom_timeout()

func _on_timer_unhint_timeout() -> void:
	get_parent()._on_timer_unhint_timeout()

# -----------------------------------------------------------

# --- AREA ESCONDE OU MOSTRA HUD
func _on_hide_area_mouse_entered() -> void:
	var TweenFade : Tween
	TweenFade = create_tween()
	TweenFade.stop()
	TweenFade.set_trans(Tween.TRANS_LINEAR)
	TweenFade.set_ease(Tween.EASE_IN_OUT)
	TweenFade.tween_property(self, "modulate:a", 0.2, 0.29)
	TweenFade.play()


func _on_hide_area_mouse_exited() -> void:
	var TweenFade : Tween
	TweenFade = create_tween()
	TweenFade.stop()
	TweenFade.set_trans(Tween.TRANS_LINEAR)
	TweenFade.set_ease(Tween.EASE_IN_OUT)
	TweenFade.tween_property(self, "modulate:a", 1.0, 0.29)
	TweenFade.play()
