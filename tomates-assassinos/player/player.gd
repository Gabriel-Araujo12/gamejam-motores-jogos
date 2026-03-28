extends CharacterBody2D
class_name Player

@onready var animated_sprite = $AnimatedSprite

var _max_health: int

@export_category("Variables")
@export var _health: int = 25
@export var _move_speed: float = 256.0

func _ready() -> void:
	_max_health = _health
	global.player = self

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

func update_health(_type: String, _value: int) -> void:
	match _type:
		"damage":
			_health -= _value
			
			if _health <= 0:
				# Ir para tela das estatísticasa
				queue_free()
			
		"heal":
			_health += _value
			
			if _health > _max_health:
				_health = _max_health

func reset_health() -> void:
	_health = _max_health
