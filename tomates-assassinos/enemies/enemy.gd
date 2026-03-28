extends CharacterBody2D
class_name Enemy

const _TEXT_POPUP: PackedScene = preload("res://interface/text_popup.tscn")

@onready var animated_sprite = $AnimatedSprite
@onready var main_collision: CollisionShape2D = $MainCollision
@onready var hitbox_collision: CollisionShape2D = $HitboxArea/HitboxCollision
@onready var animation: AnimationPlayer = $AnimatedSprite/Animation

var _is_dashing: bool = false
var _loading_dash: bool = false

@export_category("Variables")
@export var _enemy_type: String = "chase"
@export var _move_speed: float = 192.0
@export var _dash_speed: float = 576.0

@export var _health: int = 10
@export var _damage: int = 3

@export_category("Objects")
@export var _hitbox_area: Area2D
@export var _invincibility_timer: Timer
@export var _dash_wait_timer: Timer
@export var _dash_timer: Timer

var dying: bool = false

func _physics_process(_delta: float) -> void:
	if _loading_dash:
		return
	
	if global.player == null:
		return
		
	var _direction: Vector2 = global_position.direction_to(global.player.global_position)
	var _distance: float = global_position.distance_to(global.player.global_position)
	
	if _distance <= 16.0:
		return
	
	match _enemy_type:
		"chase":
			_chase(_direction)
		"chase_and_dash":
			_chase_and_dash(_direction)
			
	move_and_slide()
	
func _chase(_direction: Vector2) -> void:
	animated_sprite.play("run")
	velocity = _direction * _move_speed
	
func _chase_and_dash(_direction: Vector2) -> void:
	if not _is_dashing:
		animated_sprite.play("run")
		velocity = _direction * _move_speed
	
	if _is_dashing:
		animated_sprite.play("dash")
		velocity = _direction * _dash_speed

func update_health(_value: int) -> void:
	_health -= _value
	
	if _health <= 0:
		set_physics_process(false)
		animated_sprite.play("death")
		main_collision.set_deferred("disabled", true)
		hitbox_collision.set_deferred("disabled", true)
		
		await animated_sprite.animation_finished
		queue_free()
		
	animation.play("hit")
	_spawn_text_popup(_value)

func _spawn_text_popup(_value: int) -> void:
	var _popup: TextPopup = _TEXT_POPUP.instantiate()
	_popup.update_text(_value)
	_popup.global_position = global_position
	get_tree().root.call_deferred("add_child", _popup)

func _on_hitbox_area_body_entered(_body) -> void:
	if _body is Player:
		_hitbox_area.set_deferred("monitoring", false)
		_invincibility_timer.start()
		_body.update_health("damage", _damage)

func _on_invencibility_timer_timeout() -> void:
	_hitbox_area.set_deferred("monitoring", true)


func _on_range_area_body_entered(_body) -> void:
	if _enemy_type != "chase_and_dash":
		return
	
	if _is_dashing:
		return
	
	if _body is Player:
		_dash_wait_timer.start()
		_loading_dash = true

func _on_dash_wait_time_timeout() -> void:
	_loading_dash = false
	_is_dashing = true
	_dash_timer.start()

func _on_dash_timer_timeout() -> void:
	_is_dashing = false
