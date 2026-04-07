extends Node

var current_music = ""

@onready var menu_music = $MenuMusic
@onready var game_music = $GameMusic
@onready var boss_music = $BossMusic

func _ready():
	menu_music.stream.set_loop(true)
	game_music.stream.set_loop(true)
	boss_music.stream.set_loop(true)

func play_menu():
	if current_music == "menu":
		return
	
	current_music = "menu"
	
	_stop_all()
	menu_music.play()

func play_game():
	if current_music == "game":
		return
	
	current_music = "game"
	
	_stop_all()
	game_music.play()

func play_boss():
	if current_music == "boss":
		return
	
	current_music = "boss"
	
	_stop_all()
	boss_music.play()

func _stop_all():
	menu_music.stop()
	game_music.stop()
	boss_music.stop()
