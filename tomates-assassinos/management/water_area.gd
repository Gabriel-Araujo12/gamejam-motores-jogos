extends Area2D

@onready var player: Player = $"../../../Player"

func _on_body_entered(body: Node2D) -> void:
	if is_visible_in_tree():
		if body.is_in_group("Player"):
			player._move_speed -= 60
		elif body.is_in_group("G_Enemy"):
			body.update_speed(-80)

func _on_body_exited(body: Node2D) -> void:
	if is_visible_in_tree():
		if body.is_in_group("Player"):
			player._move_speed += 60
		elif body.is_in_group("G_Enemy"):
			body.update_speed(80)
			
