extends CanvasLayer
class_name Interface

@export_category("Objects")
@export var _wave_and_enemies: Label
@export var _wave_manager: WaveManager
@export var _health_bar: ProgressBar

func _ready() -> void:
	if global.player:
		global.player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(current_health: int, max_health: int) -> void:
	_health_bar.max_value = max_health
	_health_bar.value = current_health

func update_wave(_wave: int) -> void:
			_wave_and_enemies.text = (
				"ONDA " + str(_wave)
			)

func toogle_waves(_wave_state: bool, _waves_container: bool) -> void:
	get_tree().paused = _waves_container
	
	$WaveAndEnemies.visible = _wave_state
	$TransitionBetweenWaves.visible = _waves_container

func _on_proceed_pressed() -> void:
	toogle_waves(true, false)
	_wave_manager.start_new_wave()
