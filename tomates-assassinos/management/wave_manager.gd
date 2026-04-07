extends Node2D
class_name WaveManager

const _ENEMY_TOMATO: PackedScene = preload("res://enemies/enemy_tomato.tscn")
const _ENEMY_FLYING_TOMATO: PackedScene = preload("res://enemies/enemy_flying_tomato.tscn")
const _ENEMY_DASH_TOMATO: PackedScene = preload("res://enemies/enemy_dash_tomato.tscn")
const _ENEMY_RANGED_TOMATO: PackedScene = preload("res://enemies/enemy_ranged_tomato.tscn")
const _ENEMY_BOSS_TOMATO: PackedScene = preload("res://enemies/enemy_boss.tscn")

var _waves_dict: Dictionary = {
	1: {
		"wave_amount": 3,
		"wave_spawn_cooldown": 10,
		"spots_amount": [3, 4],
		"wave_difficulty": "easy"
	},
	
	2: {
		"wave_amount": 3,
		"wave_spawn_cooldown": 10,
		"spots_amount": [3, 4],
		"wave_difficulty": "easy to medium"
	},
	
	3: {
		"wave_amount": 4,
		"wave_spawn_cooldown": 12,
		"spots_amount": [3, 4],
		"wave_difficulty": "medium"
	},
	
	4: {
		"wave_amount": 5,
		"wave_spawn_cooldown": 15,
		"spots_amount": [3, 4],
		"wave_difficulty": "special 1"
	},
	
	5: {
		"wave_amount": 4,
		"wave_spawn_cooldown": 12,
		"spots_amount": [4, 5],
		"wave_difficulty": "medium to hard"
	},
	
	6: {
		"wave_amount": 5,
		"wave_spawn_cooldown": 15,
		"spots_amount": [3, 4],
		"wave_difficulty": "special 2"
	},
	
	7: {
		"wave_amount": 1,
		"wave_spawn_cooldown": 10,
		"spots_amount": [1, 1],
		"wave_difficulty": "hard"
	}
}

var _current_wave: int = 1
var _spawned_batches: int = 0
var _player_dead: bool = false

@export_category("Variables")
@export var _initial_position: Vector2 = Vector2(573, 350)

@export_category("Objects")
@export var _wave_spawner_timer: Timer
@export var _interface: CanvasLayer = null
@export var _player: Player = null

func _ready() -> void:
	global.wave_manager = self
	_interface.update_wave(_current_wave)
	start_new_wave()

func _process(_delta: float) -> void:
	if _spawned_batches >= _waves_dict[_current_wave]["wave_amount"]:
		check_wave_status()

func start_new_wave() -> void:
	_spawned_batches = 0
	_player.global_position = _initial_position
	_player.reset_health()
	_interface.update_wave(_current_wave)
	
	_spawn_enemies()
	_spawned_batches += 1
	
	if _spawned_batches < _waves_dict[_current_wave]["wave_amount"]:
		_wave_spawner_timer.start(_waves_dict[_current_wave]["wave_spawn_cooldown"])
	
	if _current_wave < 7:
		bgm.play_game()
	else:
		bgm.play_boss()

func check_wave_status() -> void:
	await get_tree().process_frame 
	
	var enemies_alive = 0
	for node in get_parent().get_children():
		if node is Enemy:
			enemies_alive += 1
	
	_interface.update_wave(_current_wave)
	
	if enemies_alive == 0 and _spawned_batches >= _waves_dict[_current_wave]["wave_amount"]:
		if not _player_dead:
			_advance_wave()

func _advance_wave() -> void:
	_current_wave += 1
	
	if _current_wave > _waves_dict.size():
		bgm.play_menu()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://interface/victory_menu.tscn")
	else:
		clear_map()
		_interface.toogle_waves(false, true)

func _on_wave_spawn_cooldown_timeout() -> void:
	_spawn_enemies()
	_spawned_batches += 1
	
	if _spawned_batches < _waves_dict[_current_wave]["wave_amount"]:
		_wave_spawner_timer.start(_waves_dict[_current_wave]["wave_spawn_cooldown"])
	else:
		_wave_spawner_timer.stop()

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
			_enemy = _ENEMY_TOMATO.instantiate()
		
		"easy to medium":
			if _randf <= 0.7:
				_enemy = _ENEMY_TOMATO.instantiate()
			
			else:
				_enemy = _ENEMY_FLYING_TOMATO.instantiate()
		
		"medium":
			if _randf <= 0.5:
				_enemy = _ENEMY_TOMATO.instantiate()
			
			elif _randf > 0.5 and _randf <= 0.75:
				_enemy = _ENEMY_FLYING_TOMATO.instantiate()
			
			else:
				_enemy = _ENEMY_DASH_TOMATO.instantiate()
	
		"medium to hard":
			if _randf <= 0.5:
				_enemy = _ENEMY_RANGED_TOMATO.instantiate()
			
			else:
				_enemy = _ENEMY_DASH_TOMATO.instantiate()
		
		"hard":
			_enemy = _ENEMY_BOSS_TOMATO.instantiate()
		
		"special 1":
			_enemy = _ENEMY_DASH_TOMATO.instantiate()
		
		"special 2":
			_enemy = _ENEMY_RANGED_TOMATO.instantiate()
	
	_enemy.global_position = _spawner.global_position
	get_parent().call_deferred("add_child", _enemy)

func clear_map(_can_kill_player: bool = false) -> void:
	for _children in get_tree().get_nodes_in_group("textpopup"):
		_children.queue_free()
	
	for _children in get_tree().get_nodes_in_group("projectile"):
		_children.queue_free()
	
	for _children in get_parent().get_children():
		if _children is Enemy:
			_children.queue_free()
	
	if _can_kill_player:
		_player_dead = true
		bgm.play_menu()
		_player.queue_free()
		get_tree().change_scene_to_file("res://interface/death_menu.tscn")
		return
	
	_interface.toogle_waves(false, true)
