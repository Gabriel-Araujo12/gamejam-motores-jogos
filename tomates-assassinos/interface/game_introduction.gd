extends Control
class_name GameIntroduction

func _on_proceed_pressed() -> void:
	get_tree().change_scene_to_file("res://management/game_level.tscn")
