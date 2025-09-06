extends Node2D


@onready var turn_around = $TurnAround
@onready var room_view: Node2D = $RoomView
@onready var dialog_bubble: DialogBubble = $Dialog
@onready var computer_view: Node2D = $ComputerView
@onready var hochberg: AnimatedSprite2D = $ComputerView/Hochberg
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

enum CatStates {IDLE, CURTAINS, WASHING_MACHINE, OUTLET}
enum TaskState {UNRESOLVED, SUCCESS, FAILURE}

const TASK_TIMER_DURATION = 15.0

## Maps the teacher's dialogue to possible player responses.
const dialog_to_response: Dictionary[String, Array] = {
	"Hello, thank you for joining the call. Can you tell me about your previous work experience?": ["My last job was... interesting.", "I'm a quick learner.", "I've been working with cats."],
	"Interesting. How do you handle stressful situations?": ["I stay calm under pressure.", "I take a deep breath.", "I just purr and it all works out."],
	"Okay, I'll be right back. Just need to grab a file.": ["Sounds good.", "Okay.", "I'll be here."],
	"I'm back. Where were we?": ["Talking about stress.", "You were gone for a bit.", "I'm ready for the next question."],
	"Great. Let's talk about problem-solving.": ["I like to think outside the box.", "I use logic and reason.", "I let the cat decide."],
	"Okay, I'll be right back again. Don't go anywhere.": ["Sounds good.", "Okay.", "I'll be here."],
	"I'm back again. One more question.": ["Ready when you are.", "Just a little more.", "I'm still here."],
	"Okay, that's everything for now. We'll be in touch!": ["Thank you!", "Goodbye!", "Looking forward to it!"]
}

var dialog_list: Array[String] = dialog_to_response.keys()
var cur_dialog_id = 0
var room_view_button_ready = false
var hochberg_is_back = false

var score = 100
var game_cycle = 0
var task_state = TaskState.UNRESOLVED
const MAX_CYCLES = 3

# A signal to indicate when the room view tasks are done, with a result.
signal room_tasks_completed

func display_next_dialog()->void:
	if cur_dialog_id >= len(dialog_list):
		print("no more dialog!")
		return
	
	if dialog_bubble:
		dialog_bubble.visible = true
	var current_dialog = dialog_list[cur_dialog_id]
	var responses = dialog_to_response[current_dialog]
	dialog_bubble.set_dialog(current_dialog, responses)
	
	cur_dialog_id += 1
	
	if current_dialog.contains("right back"):
		# Hide the buttons for the cutscene
		if dialog_bubble:
			dialog_bubble.but1.visible = false
			dialog_bubble.but2.visible = false
			dialog_bubble.but3.visible = false
		
		# Trigger the event where the teacher leaves.
		turn_around.visible = false
		await get_tree().create_timer(1.5).timeout
		_on_leave_call_button_down()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide the room view initially
	room_view.visible = false
	turn_around.visible = false
	room_view.room_tasks_completed.connect(_on_room_tasks_completed)
	display_next_dialog()

func _on_leave_call_button_down() -> void:
	hochberg.play("gone")
	# Teacher leaves, show the turn around button.
	# We also need to hide the dialogue bubble.
	if dialog_bubble:
		dialog_bubble.visible = false
	turn_around.visible = true
	room_view_button_ready = true
	task_state = TaskState.UNRESOLVED
	
	# The timer and event now start as soon as the teacher leaves.
	room_view.start_random_event()
	get_tree().create_timer(TASK_TIMER_DURATION).timeout.connect(_on_task_timer_timeout)


func _on_turn_around_button_down() -> void:
	if room_view_button_ready:
		if room_view.visible:
			# Player is in room view, so turn back to interview
			room_view.visible = false
			computer_view.visible = true
			
			if hochberg_is_back:
				dialog_bubble.visible = true
				hochberg.play("default") # Professor comes back to the screen
				
				# Check if the game cycle is over
				game_cycle += 1
				if game_cycle >= MAX_CYCLES:
					end_game()
				else:
					# Respond based on task state
					if task_state == TaskState.SUCCESS:
						display_next_dialog()
					else:
						dialog_bubble.set_dialog("WHAT THE HECK IS GOING ON HERE?", ["Oh no!", "I'm sorry.", "The cat did it!"])
						dialog_bubble.but1.visible = true
						dialog_bubble.but2.visible = true
						dialog_bubble.but3.visible = true
					# Reset the flag after handling the dialogue
					hochberg_is_back = false
			
		else:
			# Player is in interview view, so turn to room
			room_view.visible = true
			computer_view.visible = false
			
			# When the player turns around, they need to see the cat.
			if room_view:
				room_view.show_cat_event()
				
		dialog_bubble.visible = false
		turn_around.visible = true

func _on_room_tasks_completed(success: bool):
	print("TASK COMPLETED")
	# Update score and state, but do NOT change the view
	if success:
		score += 10
		task_state = TaskState.SUCCESS
		print("Task completed successfully! Score is now: " + str(score))
	else:
		score -= 15
		task_state = TaskState.FAILURE
		print("Task failed! Score is now: " + str(score))

func _on_task_timer_timeout():
	# This function handles the professor's return, but does not force a view change
	print("Timer ran out, professor is back!")
	
	# The professor is back, regardless of the view
	hochberg_is_back = true
	
	if room_view.visible:
		# Player is still in the room, show "ahem!" to prompt a manual return
		dialog_bubble.visible = true
		dialog_bubble.set_dialog("Ahem!", [])


func end_game():
	if dialog_bubble:
		dialog_bubble.visible = true
		dialog_bubble.set_dialog("The interview is over. Your final score is: " + str(score), [])
		# Explicitly disable the buttons so they cannot be clicked
		dialog_bubble.but1.disabled = true
		dialog_bubble.but2.disabled = true
		dialog_bubble.but3.disabled = true

func _on_camera_button_button_down() -> void:
	print("disabled/enabled camera")

func _on_share_screen_button_down() -> void:
	print("shared screen")

func _on_option_3_button_down() -> void:
	print("option 3")
	display_next_dialog()

func _on_option_2_button_down() -> void:
	print("option 2")
	display_next_dialog()

func _on_option_1_button_down() -> void:
	print("option 1")
	display_next_dialog()
