extends Control
class_name MainMenu

func _ready() -> void:
	bgm.play_menu()
	$ButtonsContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/game_introduction.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/controls.tscn")
