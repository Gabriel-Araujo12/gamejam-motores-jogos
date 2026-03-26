extends CharacterBody2D
class_name Enemy

@onready var animated_sprite = $AnimatedSprite

@export_category("Variables")
@export var _enemy_type: String = "chase"
@export var _move_speed: float = 192.0

@export var _health: int = 10
@export var _damage: int = 3

@export_category("Objects")
@export var _hitbox_area: Area2D
@export var _invincibility_timer: Timer

func _physics_process(delta: float) -> void:
	if global.player == null:
		return
		
	var _direction: Vector2 = global_position.direction_to(global.player.global_position)
	var _distance: float = global_position.distance_to(global.player.global_position)
	
	if _distance <= 16.0:
		
		return
	
	match _enemy_type:
		"chase":
			_chase(_direction)
			
	move_and_slide()
	
func _chase(_direction: Vector2) -> void:
	animated_sprite.play("run")
	velocity = _direction * _move_speed

func update_health(_value: int) -> void:
	_health -= _value
	
	if _health <= 0:
		queue_free()

func _on_hitbox_area_body_entered(_body) -> void:
	if _body is Player:
		_hitbox_area.set_deferred("monitoring", false)
		_invincibility_timer.start()
		_body.update_health("damage", _damage)

func _on_invencibility_timer_timeout() -> void:
	_hitbox_area.set_deferred("monitoring", true)
