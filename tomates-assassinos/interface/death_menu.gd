extends Control
class_name DeathMenu

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://management/game_level.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/main_menu.tscn")
