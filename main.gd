extends Node2D

@onready var turn_around = $TurnAround
@onready var room_view: Node2D = $RoomView
@onready var dialog_bubble: DialogBubble = $Dialog
@onready var computer_view: Node2D = $ComputerView
@onready var hochberg: AnimatedSprite2D = $ComputerView/Hochberg
@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer
	

enum CatStates {IDLE, CURTAINS, WASHING_MACHINE, OUTLET}
enum TaskState {UNRESOLVED, SUCCESS, FAILURE}

const TASK_TIMER_DURATION = 12.0

## Maps the teacher's dialogue to possible player responses.
const dialog_to_response: Dictionary[String, Array] = {
	"Hello, thank you for joining the call. Can you tell me about your previous work experience?": ["My last job was... interesting.", "I'm a quick learner.", "I've been working with cats."],
	"Interesting. How do you handle stressful situations?": ["I stay calm under pressure.", "I take a deep breath.", "I just purr and it all works out."],
	"Okay, I'll be right back. Just need to grab a file.": ["Sounds good.", "Okay.", "I'll be here."], # Interruption 1
	"I'm back. Where were we?": ["Talking about stress.", "You were gone for a bit.", "I'm ready for the next question."],
	"Great. Let's talk about problem-solving.": ["I like to think outside the box.", "I use logic and reason.", "I let the cat decide."],
	"Okay, I'll be right back again. Don't go anywhere.": ["Sounds good.", "Okay.", "I'll be here."], # Interruption 2
	"I'm back again. One more question.": ["Ready when you are.", "Just a little more.", "I'm still here."],
	
	"Tell me about a time you worked on a team.": ["I'm a great collaborator.", "I prefer to lead.", "My cat was the project manager."],
	"Fascinating. One moment, my dog is barking. Be right back.": ["No problem.", "I understand.", "I'll wait."], # Interruption 3
	"Alright, sorry about that. Now, for my final question.": ["I'm ready.", "Let's finish this.", "Was it a big dog?"],

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.play_music("normal")
	
	room_view.visible = false
	turn_around.visible = false
	room_view.room_tasks_completed.connect(_on_room_tasks_completed)
	display_next_dialog()

func _on_leave_call_button_down() -> void:
	# Stop the normal music for suspense. This is the only pause.
	Global.stop_music()
	hochberg.play("gone")
	
	if dialog_bubble:
		dialog_bubble.visible = false
	turn_around.visible = true
	room_view_button_ready = true
	task_state = TaskState.UNRESOLVED
	
	room_view.start_next_event()
	get_tree().create_timer(TASK_TIMER_DURATION).timeout.connect(_on_task_timer_timeout)
	

func _on_turn_around_button_down() -> void:
	if room_view_button_ready:
		if room_view.visible:
			# Player is turning back to the interview, play normal music.
			Global.play_music("normal")
			print("Turning from Room View to Computer View")
			room_view.visible = false
			computer_view.visible = true
			
			if hochberg_is_back:
				print("Professor is back, continuing dialogue.")
				
				
				if task_state == TaskState.SUCCESS:
					hochberg.play("default")
					print("Task was a success, displaying next dialogue.")
					display_next_dialog()
				else:
					print("Task failed, displaying failure dialogue.")
					hochberg.play("angry")
					dialog_bubble.visible = true
					dialog_bubble.set_dialog("WHAT THE HECK IS GOING ON HERE?", ["Oh no!", "I'm sorry.", "The cat did it!"])
					dialog_bubble.but1.visible = true
					dialog_bubble.but2.visible = true
					dialog_bubble.but3.visible = true
				
				hochberg_is_back = false
			
		else:
			# Player is turning to the room, play the ruckus music.
			Global.play_music("fixing")
			print("Turning from Computer View to Room View")
			room_view.visible = true
			computer_view.visible = false
				
		turn_around.visible = true


func _on_room_tasks_completed(success: bool):
	print("TASK COMPLETED")
	if success:
		score += 10
		task_state = TaskState.SUCCESS
		print("Task completed successfully! Score is now: " + str(score))
	else:
		score -= 15
		task_state = TaskState.FAILURE
		print("Task failed! Score is now: " + str(score))

func _on_task_timer_timeout():
	print("Timer ran out, professor is back!")
	
	# The professor is back, regardless of the view
	#
	if task_state == TaskState.SUCCESS:hochberg.play("default")
	else: hochberg.play("angry")
		
	
	game_cycle += 1
	if game_cycle >= MAX_CYCLES:
		end_game()
	else:
		if computer_view.visible:
			if task_state == TaskState.SUCCESS:
				display_next_dialog()
			else:
				dialog_bubble.visible = true
				dialog_bubble.set_dialog("WHAT THE HECK IS GOING ON HERE?", ["Oh no!", "I'm sorry.", "The cat did it!"])
				dialog_bubble.but1.visible = true
				dialog_bubble.but2.visible = true
				dialog_bubble.but3.visible = true
		else:
			print("Player is in room view, displaying Ahem!")
			dialog_bubble.visible = true
			dialog_bubble.set_dialog("Ahem!", [])
			hochberg_is_back = true

func end_game():
	if dialog_bubble:
		dialog_bubble.visible = true
		dialog_bubble.set_dialog("The interview is over. Your final score is: " + str(score), [])
		dialog_bubble.but1.disabled = true
		dialog_bubble.but2.disabled = true
		dialog_bubble.but3.disabled = true
		if score > 100: 
			get_tree().change_scene_to_file("res://fail.tscn")
		else: 
			get_tree().change_scene_to_file("res://win.tscn")
		

func _on_camera_button_button_down() -> void:
	print("disabled/enabled camera")

func _on_share_screen_button_down() -> void:
	print("shared screen")

func _on_option_3_button_down() -> void:
	if dialog_list[cur_dialog_id-1].contains("right back"):
		_on_leave_call_button_down()
		return
		
	print("option 3")
	display_next_dialog()

func _on_option_2_button_down() -> void:
	if dialog_list[cur_dialog_id-1].contains("right back"):
		_on_leave_call_button_down()
		return
	print("option 2")
	display_next_dialog()

func _on_option_1_button_down() -> void:
	if dialog_list[cur_dialog_id-1].contains("right back"):
		_on_leave_call_button_down()
		return
		
	print("option 1")
	display_next_dialog()
