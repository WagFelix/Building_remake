extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.scale.x=1.02
	self.scale.y=0.98
	initX()


func initX() -> void:
	var scaleX : float = 1.0
	var scaleY : float = 1.0
	# print("self: ", self.scale.x)
	if self.scale.x>=1.018:
		scaleX=.98
	else:
		scaleX=1.02
	if self.scale.y>=1.018:
		scaleY=.98
	else:
		scaleY=1.02
		
	# print("scalax: ", scaleX)
	var tweenX : Tween
	tweenX = create_tween().set_parallel(true)
	tweenX.stop()
	#tweenX.set_trans(Tween.TRANS_BACK)
	tweenX.set_trans(Tween.TRANS_SINE)
	tweenX.set_ease(Tween.EASE_IN_OUT)
	randomize()
	tweenX.tween_property(self, "scale", Vector2(scaleX, scaleY), randf_range(1.3, 1.9))
	#tweenX.tween_property(self, "scale", Vector2(scaleY, self.scale.x), randf_range(1.8, 2.2))
	tweenX.finished.connect(initX)
	tweenX.play()
	
