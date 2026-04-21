extends Node2D
class_name GameLevel

@onready var player = get_node("Player")

func _change_level(next_wave: int):
	match next_wave:
		2:
			$"Levels/1".queue_free()
			player.reset_speed()
			$"Levels/2".show()
		3:
			$"Levels/2".queue_free()
			player.reset_speed()
			$"Levels/3".show()
		4:
			$"Levels/3".queue_free()
			player.reset_speed()
			$"Levels/4".show()
		5:
			$"Levels/4".queue_free()
			player.reset_speed()
			$"Levels/5".show()
		6:
			$"Levels/5".queue_free()
			player.reset_speed()
			$"Levels/6".show()
		7:
			$"Levels/6".queue_free()
			player.reset_speed()
			$"Levels/7".show()
	pass
