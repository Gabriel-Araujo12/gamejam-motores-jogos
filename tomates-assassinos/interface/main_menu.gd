extends Control
class_name MainMenu

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/game_introduction.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
