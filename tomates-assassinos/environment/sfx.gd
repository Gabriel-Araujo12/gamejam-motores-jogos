extends Node

var current_music = ""

@onready var faca_sound = $Faca
@onready var foice_sound = $Foice
@onready var forcado_sound = $Forcado
@onready var revolver_sound = $Revolver
@onready var escopeta_sound = $Escopeta
@onready var thompson_sound = $Thompson
@onready var playerhit_sound = $PlayerHit
@onready var tomatodeath_sound = $TomatoDeath

func play_faca():
	faca_sound.play()

func play_foice():
	foice_sound.play()

func play_forcado():
	forcado_sound.play()

func play_revolver():
	revolver_sound.play()

func play_escopeta():
	escopeta_sound.play()

func play_thompson():
	thompson_sound.play()

func play_playerhit():
	playerhit_sound.play()

func play_tomatodeath():
	tomatodeath_sound.play()
