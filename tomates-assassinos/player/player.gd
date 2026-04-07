extends CharacterBody2D
class_name Player

@onready var animated_sprite = $AnimatedSprite
@onready var weapons_manager = $WeaponsManager
@onready var animation: AnimationPlayer = $AnimatedSprite/Animation

signal health_changed(current_health: int, max_health: int)
var _max_health: int
var _current_weapon_index: int = 0

@export_category("Variables")
@export var _health: int = 30
@export var _move_speed: float = 256.0

func _ready() -> void:
	_max_health = _health
	global.player = self
	select_weapon(0)
	health_changed.emit(_health, _max_health)

func _physics_process(_delta: float) -> void:
	_move()

func _move() -> void:
	var _direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if _direction == Vector2.ZERO:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
		return
	
	animated_sprite.play("run")
	velocity = _direction * _move_speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_1"):
		select_weapon(0)
	elif event.is_action_pressed("weapon_2"):
		select_weapon(1)
	elif event.is_action_pressed("weapon_3"):
		select_weapon(2)
	elif event.is_action_pressed("weapon_4"):
		select_weapon(3)
	elif event.is_action_pressed("weapon_5"):
		select_weapon(4)

func select_weapon(index: int) -> void:
	if index < 0 or index >= weapons_manager.get_child_count():
		return
	
	_current_weapon_index = index
	
	for i in range(weapons_manager.get_child_count()):
		var weapon = weapons_manager.get_child(i)
		
		weapon.visible = (i == index)
		
		for child in weapon.get_children():
			if child is BaseWeapon:
				child.visible = i == index
				child.set_process(i == index)
				child.set_physics_process(i == index)
				
				if i == index:
					child.activate_all_logic()
				else:
					child.cancel_all_logic()

func update_health(_type: String, _value: int) -> void:
	match _type:
		"damage":
			_health -= _value
			sfx.play_playerhit()
			animation.play("hit")
			
			if _health <= 0:
				global.wave_manager.call_deferred("clear_map", true)
			
		"heal":
			_health += _value
			
			if _health > _max_health:
				_health = _max_health
	
	health_changed.emit(_health, _max_health)

func reset_health() -> void:
	_health = _max_health
	health_changed.emit(_health, _max_health)
