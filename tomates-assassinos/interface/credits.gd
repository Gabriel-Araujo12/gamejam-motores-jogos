extends Control
class_name Credits

func _ready() -> void:
	$Back.grab_focus()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/main_menu.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()
