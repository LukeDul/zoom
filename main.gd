extends Node2D

@onready var turn_around = $TurnAround
@onready var room_view: Node2D = $RoomView
@onready var dialog_bubble: DialogBubble = $Dialog

## Maps hochbergs dialog to the possible responses. 
const dialog_to_response: Dictionary[String, Array] = {
	"hi": ["hello", "uh", "help"]
}

var dialog_list: Array[String] = dialog_to_response.keys()

var cur_dialog_id = 0

func display_next_dialog()->void:
	if cur_dialog_id >= len(dialog_list):
		print("no more dialog!")
		return
		
	dialog_bubble.visible = true 
	dialog_bubble.set_dialog(dialog_list[cur_dialog_id], dialog_to_response[dialog_list[cur_dialog_id]])
	
	cur_dialog_id += 1
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_next_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_turn_around_button_down() -> void:
	room_view.visible = !room_view.visible
	
func _on_mute_button_button_down() -> void:
	dialog_bubble.toggle_buttons()
	print("muted/unmuted")

func _on_texture_button_button_down() -> void:
	print("option 1")
	pass # Replace with function body.

func _on_texture_button_2_button_down() -> void:
	print("option 2")
	pass # Replace with function body.

func _on_texture_button_3_button_down() -> void:
	print("option 3")
	pass # Replace with function body.


func _on_leave_call_button_down() -> void:
	print("left call")


func _on_camera_button_button_down() -> void:
	print("disabled/enabled camera")


func _on_share_screen_button_down() -> void:
	print("shared screen")
