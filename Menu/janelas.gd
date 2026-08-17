extends Node2D


var janelas := [[null],
	["One", "Onebath"],
	["Two", "Twobath"],
	["Three", "Threebath"],
	["Four", "Fourbath"],
	["Five", "Fivebath"],
	["Roof"],
	["Bunker", "Bunkerbath"]
]


func _ready() -> void:
	var qJanelas = self.get_children()
	for child in qJanelas:
		#child.visible=false
		var changeVisibleC=true
		var changeVisibleH=true
		var qAndar = int(child.name)
		if qAndar>0:
			var tudo = functions.loadcats(janelas[qAndar][0])
			print("TUDO 0 primeira ", tudo[0])
			print("TUDO 1 primeira ", tudo[1])
			if tudo[0]==null:
				changeVisibleC=false
			else:
				if tudo[0].count(false)>0:
					changeVisibleC=false
			if qAndar<6:
				if tudo[1]==null:
					changeVisibleH=false
				else:
					if tudo[0].count(false)>0:
						changeVisibleH=false
					
			#var quantidade_false = array.count(false)
			
			if qAndar<6:
				tudo = functions.loadcats(janelas[qAndar][1])
				print("TUDO 0 seg ", tudo[0])
				print("TUDO 1 seg ", tudo[1])
				if tudo[0]==null:
					changeVisibleC=false
				else:
					if tudo[0].count(false)>0:
						changeVisibleC=false
				print("C FALSE ", tudo[0].count(false))
				if qAndar<6:
					if tudo[1]==null:
						changeVisibleH=false
					else:
						if tudo[1].count(false)>0:
							changeVisibleH=false
					print("H FALSE ", tudo[0].count(false))
							
						
			child.get_child(0).visible=changeVisibleC
			if qAndar<6:
				child.get_child(1).visible=changeVisibleH
		
		
