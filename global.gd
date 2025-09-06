extends Node2D

@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer

const SFX: Dictionary[String, AudioStream] = {
	"grump": preload("res://sfx/Grump.ogg"),
	"happy": preload("res://sfx/Happy.ogg"),
	"cough": preload("res://sfx/clearing.ogg"), 
	"tear": preload("res://sfx/Tear.ogg"),
	"thump": preload("res://sfx/Washing.ogg"),
	"hehe": preload("res://sfx/Hehehe.ogg"),
}

const MUSIC: Dictionary[String, AudioStream] = {
	"normal": preload("res://sfx/normalmusic.mp3"),
	"fixing": preload("res://sfx/fixingmusic.mp3"),
}

func play(sfx_name: String)->void:
	player.stream = SFX[sfx_name]
	player.play()
	
func stop()->void:
	player.stop()

func play_music(music_name: String)->void:
	if not music_player: return
	
	music_player.stream = MUSIC[music_name]
	music_player.play()

func stop_music()->void:
	if not music_player: return
	music_player.stop()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
