extends Area2D
class_name ProjectileRevolver

var direction: Vector2
var attack_damage: int

@export var _move_speed: float = 128.0

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(_delta: float) -> void:
	translate(direction * _delta * _move_speed)

func _on_attack_area_body_entered(_body) -> void:
	if _body is TileMap:
		queue_free()
	
	if _body is Enemy:
		_body.update_health(attack_damage)
		queue_free()
