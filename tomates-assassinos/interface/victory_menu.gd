extends Control
class_name VictoryMenu

func _ready() -> void:
	$ButtonsContainer/Menu.grab_focus()

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
