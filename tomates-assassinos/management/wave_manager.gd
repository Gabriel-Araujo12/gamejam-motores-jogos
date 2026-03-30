extends Node2D
class_name WaveManager

const _ENEMY_TOMATO: PackedScene = preload("res://enemies/enemy_tomato.tscn")
const _ENEMY_FLYING_TOMATO: PackedScene = preload("res://enemies/enemy_flying_tomato.tscn")
const _ENEMY_DASH_TOMATO: PackedScene = preload("res://enemies/enemy_dash_tomato.tscn")
const _ENEMY_RANGED_TOMATO: PackedScene = preload("res://enemies/enemy_ranged_tomato.tscn")
const _ENEMY_BOSS_TOMATO: PackedScene = preload("res://enemies/enemy_boss.tscn")

var _waves_dict: Dictionary = {
	1: {
		"wave_time": 20,
		"wave_amount": 1,
		"wave_spawn_cooldown": 10,
		"spots_amount": [1, 1],
		"wave_difficulty": "easy"
	},
	
	2: {
		"wave_time": 20,
		"wave_amount": 1,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "easy to medium"
	},
	
	3: {
		"wave_time": 20,
		"wave_amount": 1,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "medium"
	},
	
	4: {
		"wave_time": 20,
		"wave_amount": 1,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "medium to hard"
	},
	
	5: {
		"wave_time": 20,
		"wave_amount": 1,
		"wave_spawn_cooldown": 4,
		"spots_amount": [3, 6],
		"wave_difficulty": "hard"
	}
}

var _current_wave: int = 1

@export_category("Variables")
@export var _initial_position: Vector2 = Vector2(573, 350)

@export_category("Objects")
@export var _wave_timer: Timer
@export var _wave_spawner_timer: Timer
@export var _interface: CanvasLayer = null
@export var _player: Player = null

func _ready() -> void:
	_wave_spawner_timer.start(_waves_dict[_current_wave]["wave_spawn_cooldown"])
	_wave_timer.start(_waves_dict[_current_wave]["wave_time"])
	_interface.update_wave_and_time_label(_current_wave, _wave_timer.time_left - 1)
	_spawn_enemies()

func _on_wave_timer_timeout() -> void:
	_current_wave += 1
	
	if _current_wave > 10:
		print("Você venceu!")
		return
	
	# get_tree().paused = true
	_clear_map()

func _on_wave_spawn_cooldown_timeout() -> void:
	_spawn_enemies()
	_wave_spawner_timer.start(_waves_dict[_current_wave]["wave_spawn_cooldown"])

func _spawn_enemies() -> void:
	var _amount: int = _waves_dict[_current_wave]["wave_amount"]
	var _spots: Array = []
	
	for _children in get_children():
		if not _children is Timer:
			_spots.append(_children)
	
	var _spawn_spots: Array = []
	
	for _i in _amount:
		var _index: int = randi() % _spots.size()
		var _selected_spot: Node2D = _spots[_index]
		_spawn_spots.append(_selected_spot)
		_spots.remove_at(_index)
	
	for _spot in _spawn_spots:
		var _childrens: Array = []
		var _selected_childrens: Array = []
		
		for _children in _spot.get_children():
			_childrens.append(_children)
		
		var _amount_list: Array = _waves_dict[_current_wave]["spots_amount"]
		var _selected_amount: int = randi_range(_amount_list[0], _amount_list[1])
		
		for _i in _selected_amount:
			var _index: int = randi() % _childrens.size()
			var _selected_spot: Node2D = _childrens[_index]
			_selected_childrens.append(_selected_spot)
			_childrens.remove_at(_index)
			
		for _spawner in _selected_childrens:
			_spawn_enemy(_spawner)

func _spawn_enemy(_spawner: Node2D) -> void:
	var _enemy: Enemy = null
	var _randf: float = randf()
	var _difficulty: String = _waves_dict[_current_wave]["wave_difficulty"]
	
	match _difficulty:
		"easy":
			_enemy = _ENEMY_BOSS_TOMATO.instantiate()
		
		"easy to medium":
			if _randf <= 0.7:
				_enemy = _ENEMY_TOMATO.instantiate()
			
			else:
				_enemy = _ENEMY_FLYING_TOMATO.instantiate()
		
		"medium":
			if _randf <= 0.7:
				_enemy = _ENEMY_TOMATO.instantiate()
			
			elif _randf <= 0.7:
				pass
			
			else:
				_enemy = _ENEMY_FLYING_TOMATO.instantiate()
	
		"medium to hard":
			pass
		
		"hard":
			pass
	
	_enemy.global_position = _spawner.global_position
	get_parent().call_deferred("add_child", _enemy)

func _on_current_time_timer_timeout() -> void:
	_interface.update_wave_and_time_label(_current_wave, _wave_timer.time_left)

func _clear_map() -> void:
	for _children in get_parent().get_children():
		if _children is Enemy:
			_children.queue_free()
		
	start_new_wave()

func start_new_wave() -> void:
	_wave_timer.start(_waves_dict[_current_wave]["wave_time"])
	_player.global_position = _initial_position
	_player.reset_health()
