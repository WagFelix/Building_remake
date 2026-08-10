extends Node2D

var hinttimer : float = 40.0
var haveTime=true #se tem o item de recharge hint, TRUE
var hint=true #se tem o item de hint, TRUE
var getHint=false
@onready var timerhint := $TimerHint

func _ready():
	pass


func _on_TimerHint_timeout():
	if haveTime==true:
		#functions.savecats(Map.whereIAm, "hintLeft", 1)
		getHint=true
