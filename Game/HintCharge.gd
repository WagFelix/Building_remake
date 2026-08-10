extends Sprite2D
@export var Hud: Control
var theHint

func _ready():
	theHint = get_parent().get_node("Hint")
	self_modulate = Color(1, 1, 1, 0.34)
	$HintCharge.material.set("shader_parameter/percentage", 0)
	$CoolDown.start(0.01)

func _process(_delta):
	if $CoolDown.is_stopped():
		$CoolDown.start(0.1)

		var tleft = iHint.timerhint.time_left
		var frac = tleft / iHint.hinttimer
		#var wNumitens = Hud.RootNode.catsLeft + Hud.RootNode.catsLeftH + Hud.RootNode.extrasLeft
		var wNumitens = Hud.RootNode.catsLeft + Hud.RootNode.catsLeftH 

		var hintLeft_val = Hud.RootNode.hintLeft

		#print("HC: tleft=", tleft, " hintLeft=", hintLeft_val, " timer_correndo=", tleft > 0, " items=", wNumitens)

		var pode_carregar = tleft > 0 and hintLeft_val <= 0 and wNumitens > 0 and iHint.haveTime == true
		
	
		if pode_carregar :
			theHint.visible = false
			$HintCharge.material.set("shader_parameter/percentage", frac)
		else:
			theHint.visible = true
			$HintCharge.material.set("shader_parameter/percentage", 0)
