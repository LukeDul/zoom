extends Node2D

## HIHI
@onready var player: AudioStreamPlayer = $AudioStreamPlayer

const SFX: Dictionary[String, AudioStream] = {
	"grump": preload("res://sfx/Grump.ogg"),
	"happy": preload("res://sfx/Happy.ogg"),
	"cough": preload("res://sfx/clearing.ogg"), 
	"tear": preload("res://sfx/Tear.ogg"),
	"thump": preload("res://sfx/Washing.ogg"),
	"hehe": preload("res://sfx/Hehehe.ogg"),
}

func play(name: String)->void:
	player.stream = SFX[name]
	player.play()
	
func stop()->void:
	player.stop()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



	
