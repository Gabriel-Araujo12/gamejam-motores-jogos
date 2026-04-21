extends Node2D
class_name GameLevel

@onready var player = get_node("Player")

#func _on_water_area_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#player._move_speed -= 60
	#elif body.is_in_group("G_Enemy"):
		#body.update_speed(-80)
	#
#func _on_water_area_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#player._move_speed += 60
	#elif body.is_in_group("G_Enemy"):
		#body.update_speed(80)

func _change_level(next_wave: int):
	match next_wave:
		2:
			$"Levels/1".queue_free()
			$"Levels/2".show()
		3:
			$"Levels/2".queue_free()
			$"Levels/3".show()
		4:
			$"Levels/3".queue_free()
			$"Levels/4".show()
		5:
			$"Levels/4".queue_free()
			$"Levels/5".show()
		6:
			$"Levels/5".queue_free()
			$"Levels/6".show()
		7:
			$"Levels/6".queue_free()
			$"Levels/7".show()
	pass
