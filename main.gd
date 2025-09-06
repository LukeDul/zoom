extends Node2D

@onready var turn_around = $TurnAround
@onready var room_view: Node2D = $RoomView

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_turn_around_button_down() -> void:
	room_view.visible = !room_view.visible
	
func _on_mute_button_button_down() -> void:
	print("mute") # Replace with function body.
