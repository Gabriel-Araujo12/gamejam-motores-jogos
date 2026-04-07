extends Node2D
class_name BaseWeapon

const _PROJECTILE_REVOLVER: PackedScene = preload("res://weapons/ranged_weapons/projetil_revolver.tscn")
const _PROJECTILE_ESCOPETA: PackedScene = preload("res://weapons/ranged_weapons/projetil_escopeta.tscn")

@onready var sprite = $WeaponBody/WeaponTexture

var _is_attacking: bool = false
var _enemy_ref: Enemy

@export_category("Variables")
@export var _attack_type: String = "melee"
@export var _weapon_sfx_name: String = "faca"
@export var _attack_damage: int
@export var _attack_cooldown: float

@export_category("Objects")
@export var _attack_timer: Timer
@export var _animation: AnimationPlayer
@export var _detection_area: Area2D

func _process(_delta):
	if is_instance_valid(_enemy_ref):
		look_at(_enemy_ref.global_position)
		
		if _attack_type == "melee":
			return
		
		else:
			var angle = wrapf(global_rotation, -PI, PI)
			if abs(angle) > PI / 2:
				sprite.flip_v = true
			else:
				sprite.flip_v = false
	
	else:
		pass

func _on_detection_area_body_entered(_body) -> void:
	if _is_attacking:
		return
		
	if _body is Enemy:
		_enemy_ref = _body
		_detection_area.set_deferred("monitoring", false)
		_attack_timer.start(_attack_cooldown)
		_animation.call_deferred("play", "attack")
		_is_attacking = true
		_play_melee_sound()

func _on_attack_timer_timeout() -> void:
	if is_visible_in_tree():
		_detection_area.set_deferred("monitoring", true)
	
	_is_attacking = false

func _on_attack_area_body_entered(_body) -> void:
	if not is_visible_in_tree():
		return
	
	if _body is Enemy:
		_body.update_health(_attack_damage)

func _spawn_projectile_revolver() -> void:
	if not is_visible_in_tree(): 
		return
	
	if is_instance_valid(_enemy_ref):
		var _direction: Vector2 = global_position.direction_to(_enemy_ref.global_position)
		var _projectile_revolver: ProjectileRevolver = _PROJECTILE_REVOLVER.instantiate()
		_projectile_revolver.global_position = global_position
		_projectile_revolver.attack_damage = _attack_damage
		_projectile_revolver.direction = _direction
		
		get_tree().root.call_deferred("add_child", _projectile_revolver)
		sfx.play_revolver()

func _spawn_projectile_escopeta() -> void:
	if not is_visible_in_tree(): 
		return
	
	if is_instance_valid(_enemy_ref):
		var _direction: Vector2 = global_position.direction_to(_enemy_ref.global_position)
		var _projectile_escopeta: ProjectileEscopeta = _PROJECTILE_ESCOPETA.instantiate()
		_projectile_escopeta.global_position = global_position
		_projectile_escopeta.attack_damage = _attack_damage
		_projectile_escopeta.direction = _direction
		
		get_tree().root.call_deferred("add_child", _projectile_escopeta)
		sfx.play_escopeta()

func activate_all_logic() -> void:
	if _detection_area:
		_detection_area.set_deferred("monitoring", true)
	
	if has_node("WeaponBody/AttackArea"):
		$WeaponBody/AttackArea.set_deferred("monitoring", true)
	
	_is_attacking = false
	_enemy_ref = null

func cancel_all_logic() -> void:
	_enemy_ref = null
	_is_attacking = false
	if _attack_timer: _attack_timer.stop()
	if _animation: _animation.stop()
	
	if _detection_area:
		_detection_area.set_deferred("monitoring", false)
	
	if has_node("WeaponBody/AttackArea"):
		$WeaponBody/AttackArea.set_deferred("monitoring", false)

func _play_melee_sound():
	match _weapon_sfx_name:
		"faca":
			sfx.play_faca()
		"foice":
			sfx.play_foice()
		"forcado":
			sfx.play_forcado()
