extends Area2D

var time: float = 0.0

func _physics_process(delta: float) -> void:
	time += delta
	if is_visible_in_tree():
		for body in get_overlapping_bodies():
			if body.is_in_group("Player"):
				body.update_health("damage", 500 * delta)
			elif body.is_in_group("G_Enemy"):
				body.glass_damage()
