extends Control
var isComplete := false
#var padrao := "res://GLOBAL/ScaleUP_transition/textures/ghosts.png"

func _ready() -> void:
	$Loading.modulate=Color(1,1,1,0)
	$bg.modulate=Color(1,1,1,0)
	$spriteScale.scale=Vector2(0,0)
	$spriteScale.visible=false

func _process(delta) -> void:
	$Loading.rotation_degrees += 666.0/2.0 * delta
	
	
func _showScale() -> void:
	var TweenLoading = create_tween().parallel()
	TweenLoading.stop()
	TweenLoading.set_parallel(true)
	TweenLoading.set_trans(Tween.TRANS_LINEAR)
	TweenLoading.set_ease(Tween.EASE_IN_OUT)
	TweenLoading.tween_property($Loading, "modulate", Color(1,1,1,0.5), .7)
	TweenLoading.play()
	$spriteScale.visible=true
	var TweenScale = create_tween().parallel()
	TweenScale.stop()
	TweenScale.set_parallel(true)
	TweenScale.set_trans(Tween.TRANS_LINEAR)
	TweenScale.set_ease(Tween.EASE_IN_OUT)
	TweenScale.tween_property($spriteScale, "scale", Vector2(2.33,2.33), 1.6)
	TweenScale.tween_property($bg, "modulate", Color(1,1,1,1), 1.6)
	TweenScale.finished.connect(_mostrou)
	TweenScale.play()

func _mostrou() -> void:
	isComplete=true

func _hideScale() -> void:
	isComplete=false
	var TweenLoading = create_tween().parallel()
	TweenLoading.stop()
	TweenLoading.set_parallel(true)
	TweenLoading.set_trans(Tween.TRANS_LINEAR)
	TweenLoading.set_ease(Tween.EASE_IN_OUT)
	TweenLoading.tween_property($Loading, "modulate", Color(1,1,1,0), .3)
	TweenLoading.tween_property($bg, "modulate", Color(1,1,1,0), .3)
	TweenLoading.play()
	
	var TweenScale = create_tween().parallel()
	TweenScale.stop()
	TweenScale.set_parallel(true)
	TweenScale.set_trans(Tween.TRANS_LINEAR)
	TweenScale.set_ease(Tween.EASE_IN_OUT)
	TweenScale.finished.connect(_esconde)
	TweenScale.tween_property($spriteScale, "scale", Vector2(0,0), .6)
	TweenScale.play()

func _esconde() -> void:
	$spriteScale.visible=false
