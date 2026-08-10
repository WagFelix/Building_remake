extends Control


func _on_reload_button_down() -> void:
	get_tree().change_scene_to_file("res://Splash/splash.tscn")


func _on_exit_button_down() -> void:
	get_tree().quit()
