extends Node2D

@onready var player = get_node("Player")


func _process(delta: float) -> void:
	pass

func _on_water_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player._move_speed -= 60
	elif body.is_in_group("G_Enemy"):
		body.update_speed(-80)
	
func _on_water_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player._move_speed += 60
	elif body.is_in_group("G_Enemy"):
		body.update_speed(80)
