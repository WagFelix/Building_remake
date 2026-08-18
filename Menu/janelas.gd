extends Node2D


var janelas := [["Bunker", "Bunkerbath"],
	["One", "Onebath"],
	["Two", "Twobath"],
	["Three", "Threebath"],
	["Four", "Fourbath"],
	["Five", "Fivebath"],
	["Roof"],
	
	
]


func _ready() -> void:
	var qJanelas = self.get_children()
	for child in qJanelas:
		#child.visible=false
		var changeVisibleC=true
		var changeVisibleH=true
		var qAndar = int(child.name)
	
				
		if qAndar>=0: 
			var tudo = functions.loadcats(janelas[qAndar][0])
			print(janelas[qAndar][0]," TUDO 0 primeira ", tudo[0])
			print(janelas[qAndar][0]," TUDO 1 primeira ", tudo[1])
			if tudo==null:
				tudo=[null,null]
			if tudo[0]==null:
				tudo[0] = false
				changeVisibleC=false
				print("nem entrou em ", janelas[qAndar][0])
				
			else:
				if tudo[0].count(false)>0:
					changeVisibleC=false
					print("nao completou gatos ", janelas[qAndar][0])
			if qAndar<6 :
				if tudo[1]==null:
					tudo[1]=false
					if qAndar != 0:#o zero(bunker) conta os dois
						changeVisibleH=false
					else:
						changeVisibleC=false
						print("nao entrou ", janelas[qAndar][0])
				else:
					if tudo[1].count(false)>0:
						if qAndar != 0: #o zero(bunker) conta os dois
							changeVisibleH=false
						else:
							changeVisibleC=false
							print("nao completou hidden ", janelas[qAndar][0])
			
			#var quantidade_false = array.count(false)
			
			if qAndar>=0 and qAndar<6: 
				print(janelas[qAndar][1])
				tudo = functions.loadcats(janelas[qAndar][1])
				if tudo==null:
					tudo=[null,null]
				print(janelas[qAndar][1]," TUDO 0 primeira ", tudo[0])
				print(janelas[qAndar][1]," TUDO 1 primeira ", tudo[1])
				if tudo[0]==null:
					tudo[0]=false
					changeVisibleC=false
					print("nao entrou ", janelas[qAndar][1])
				else:
					if tudo[0].count(false)>0:
						print("nao completou gatos ", janelas[qAndar][1])
						changeVisibleC=false
				#print(janelas[qAndar][1])		
				#print("C FALSE ", tudo[0].count(false))
				if qAndar<6 :
					if tudo[1]==null:
						tudo[1]=false
						if qAndar != 0: #o zero(bunker) conta os dois
							changeVisibleH=false
						else:
							changeVisibleC=false
							print("nao entrou hidden ", janelas[qAndar][1])
					else:
						if tudo[1].count(false)>0:
							if qAndar != 0: #o zero(bunker) conta os dois
								changeVisibleH=false
							else:
								changeVisibleC=false
								print("nao completou hidden ", janelas[qAndar][1])
					#print("H FALSE ", tudo[1].count(false))
				

			child.get_child(0).visible=changeVisibleC
			if qAndar<6 and qAndar!=0:
				child.get_child(1).visible=changeVisibleH
		
		
