extends Control
class_name Controls

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/main_menu.tscn")
