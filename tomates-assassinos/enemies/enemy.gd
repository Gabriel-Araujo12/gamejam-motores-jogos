extends CharacterBody2D
class_name Enemy

const _TEXT_POPUP: PackedScene = preload("res://interface/text_popup.tscn")
const _PROJECTILE_RANGED_TOMATO: PackedScene = preload("res://enemies/projetil_ranged_tomato.tscn")
const _PROJECTILE_BOSS_TOMATO: PackedScene = preload("res://enemies/projetil_boss_tomato.tscn")

@onready var animated_sprite = $AnimatedSprite
@onready var main_collision: CollisionShape2D = $MainCollision
@onready var hitbox_collision: CollisionShape2D = $HitboxArea/HitboxCollision
@onready var animation: AnimationPlayer = $AnimatedSprite/Animation

var _is_spawning: bool = true
var _is_dashing: bool = false
var _loading_dash: bool = false
var _dash_direction: Vector2 = Vector2.ZERO
var _player_ref: Player

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
@export var _shoot_timer: Timer

var dying: bool = false

func _ready():
	animation.play("spawn")

func _on_spawn_finished():
	_is_spawning = false
	scale = Vector2.ONE
	_hitbox_area.set_deferred("monitoring", true)

func _physics_process(_delta: float) -> void:
	if _is_spawning or _loading_dash:
		return
	
	if global.player == null:
		return
	
	var _direction: Vector2 = global_position.direction_to(global.player.global_position)
	var _distance: float = global_position.distance_to(global.player.global_position)
	
	_update_sprite_direction(_direction)
	
	if _distance <= 16.0:
		return
	
	match _enemy_type:
		"chase":
			_chase(_direction)
		"chase_and_dash":
			_chase_and_dash(_direction)
		"ranged":
			_ranged(_direction)
		"boss":
			_boss(_direction)
		
	move_and_slide()

func _update_sprite_direction(_direction: Vector2) -> void:
	if _direction.x < 0:
		animated_sprite.flip_h = true
	
	else:
		animated_sprite.flip_h = false

func _chase(_direction: Vector2) -> void:
	animated_sprite.play("run")
	velocity = _direction * _move_speed
	
func _chase_and_dash(_direction: Vector2) -> void:
	if _is_dashing:
		animated_sprite.play("dash")
		velocity = _dash_direction * _dash_speed
	
	else:
		animated_sprite.play("run")
		velocity = _direction * _move_speed

func _ranged(_direction: Vector2) -> void:
	animated_sprite.play("run")
	velocity = _direction * _move_speed
	
	if _shoot_timer.is_stopped():
			_shoot_timer.start()

func _boss(_direction: Vector2) -> void:
	if _health > 20:
		animated_sprite.play("run_fase1")
		velocity = _direction * _move_speed
		
		if _shoot_timer.is_stopped():
				_shoot_timer.start()
	
	elif _health > 10 and _health <= 20:
		if not _shoot_timer.is_stopped():
			_shoot_timer.stop()
		
		if _is_dashing:
			animated_sprite.play("dash")
			velocity = _dash_direction * _dash_speed
		
		else:
			animated_sprite.play("run_fase2")
			velocity = _direction * _move_speed
	
	else:
		animated_sprite.play("run_fase3")
		velocity = _direction * _move_speed

func update_health(_value: int) -> void:
	if _is_spawning:
		return
	
	_health -= _value
	_spawn_text_popup(_value)
	
	if _health <= 0:
		set_physics_process(false)
		animated_sprite.play("death")
		main_collision.set_deferred("disabled", true)
		hitbox_collision.set_deferred("disabled", true)
		
		if not _shoot_timer.is_stopped():
			_shoot_timer.stop()
		
		await animated_sprite.animation_finished
		queue_free()
		
		return
	
	animation.play("hit")

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
	var is_boss_fase2 = (_enemy_type == "boss" and _health > 10 and _health <= 20)
	
	if _enemy_type != "chase_and_dash" and not is_boss_fase2:
		return
	
	if _is_dashing or _loading_dash:
		return
	
	if _body is Player:
		_dash_wait_timer.start()
		_loading_dash = true

func _on_dash_wait_time_timeout() -> void:
	_loading_dash = false
	velocity = Vector2.ZERO
	_is_dashing = true
	_dash_direction = global_position.direction_to(global.player.global_position)
	_dash_timer.start()

func _on_dash_timer_timeout() -> void:
	_is_dashing = false

func _spawn_projectile_ranged_tomato() -> void:
	var target = _player_ref if is_instance_valid(_player_ref) else global.player
	
	if is_instance_valid(target):
		var _direction: Vector2 = global_position.direction_to(target.global_position)
		var _projectile_ranged_tomato: ProjectileRangedTomato = _PROJECTILE_RANGED_TOMATO.instantiate()
		
		_projectile_ranged_tomato.global_position = global_position
		_projectile_ranged_tomato.direction = _direction
		_projectile_ranged_tomato.attack_damage = _damage
		
		get_tree().root.add_child(_projectile_ranged_tomato)

func _spawn_projectile_boss_tomato() -> void:
	var target = _player_ref if is_instance_valid(_player_ref) else global.player
	
	if is_instance_valid(target):
		var _direction: Vector2 = global_position.direction_to(target.global_position)
		var _projectile_boss_tomato: ProjectileBossTomato = _PROJECTILE_BOSS_TOMATO.instantiate()
		
		_projectile_boss_tomato.global_position = global_position
		_projectile_boss_tomato.direction = _direction
		_projectile_boss_tomato.attack_damage = _damage
		
		get_tree().root.add_child(_projectile_boss_tomato)

func _on_shoot_timer_timeout() -> void:
	if _enemy_type == "ranged":
			_spawn_projectile_ranged_tomato()
			
	elif _enemy_type == "boss":
			_spawn_projectile_boss_tomato()
