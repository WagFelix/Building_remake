extends Node2D


func start() -> void:
	if $Timer5.is_stopped():
		$Timer5.start(60*5)
		#print("RESETED 5")
	if $Timer13.is_stopped():
		$Timer13.start(60*13)
		#print("RESETED 13")


func _on_timer_5_timeout() -> void:
	functions.arquivoPath.save(functions.PROGRESS_BK5)
	start()
	#print("AUTOSAVED 5")


func _on_timer_13_timeout() -> void:
	functions.arquivoPath.save(functions.PROGRESS_BK13)
	start()
	#print("AUTOSAVED 13")
