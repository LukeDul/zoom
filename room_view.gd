class_name RoomView extends Node2D

enum CatStates {IDLE, CURTAINS, WASHING_MACHINE, OUTLET}

@onready var idle_cat: TextureButton = $IdleCat
@onready var outlet: Node2D = $Outlet
@onready var washing_machine: Node2D = $WashingMachine
@onready var door = washing_machine.get_node("machine_door")
@onready var curtain: Node2D = $Window

# A custom signal to communicate back to the main script.
signal room_tasks_completed(success: bool)

var cur_cat
var cur_tween: Tween
var time_limit_timer: SceneTreeTimer
var task_completed = false
var cat_event_started = false

# Calls the function after the given seconds have passed.
# Returns the timer. 
func call_later(seconds: float, callback_func: Callable) -> SceneTreeTimer:
	var timer = get_tree().create_timer(seconds)
	timer.timeout.connect(callback_func)
	return timer

var cat_state = CatStates.IDLE:
	set(v):
		match(v):
			CatStates.IDLE: 
				if cur_cat:
					cur_cat.visible = false 
				idle_cat.visible = true
				if cur_tween and is_instance_valid(cur_tween):
					cur_tween.stop()
				
				# The task is completed, emit the signal.
				room_tasks_completed.emit(task_completed)
				
			CatStates.CURTAINS: pass
			CatStates.WASHING_MACHINE: pass
			CatStates.OUTLET: pass
			_: push_error("Unknown Cat State")
		cat_state = v

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if cat_state == CatStates.IDLE:
		if Input.is_action_just_pressed("debug1"):
			cat_state = CatStates.CURTAINS
			show_cat_event()
		elif Input.is_action_just_pressed("debug2"):
			cat_state = CatStates.WASHING_MACHINE
			show_cat_event()
		elif Input.is_action_just_pressed("debug3"):
			cat_state = CatStates.OUTLET
			show_cat_event()
	
	match(cat_state):
		CatStates.IDLE: pass
		CatStates.CURTAINS: pass
		CatStates.WASHING_MACHINE: pass
		CatStates.OUTLET: pass
		_: push_error("Unknown Cat State")
		
func start_random_event():
	task_completed = false
	cat_event_started = true
	
	var states = [CatStates.CURTAINS, CatStates.WASHING_MACHINE, CatStates.OUTLET]
	var random_state = states[randi() % states.size()]
	
	cat_state = random_state

func show_cat_event():
	if not cat_event_started: return
	
	match(cat_state):
		CatStates.CURTAINS: start_curtain_event()
		CatStates.WASHING_MACHINE: start_washing_machine_event()
		CatStates.OUTLET: start_outlet_event()
	
func set_task_time_limit(seconds: float):
	time_limit_timer = call_later(seconds, on_time_ran_out)

func on_time_ran_out():
	print("Time ran out! Teacher is coming back.")
	task_completed = false
	if cur_tween and is_instance_valid(cur_tween):
		cur_tween.stop()
	cat_state = CatStates.IDLE
	
func start_curtain_event()->void:
	print("cat is ripping curtain!! stop him")
	if curtain:
		cur_cat = curtain.get_node("WindowCat")
		if cur_cat:
			cur_cat.visible = true
	if idle_cat:
		idle_cat.visible = false
	
	cur_tween = create_tween()
	if cur_cat:
		cur_tween.tween_property(cur_cat, "position", Vector2(cur_cat.position.x, cur_cat.position.y + 300), 1.0) 
		cur_tween.finished.connect(end_curtain_event)

func end_curtain_event()->void:
	if is_instance_valid(time_limit_timer):
		print("cat tore up curtain")
		cat_state = CatStates.IDLE
	else:
		pass

func _on_window_cat_button_down() -> void:
	print("you grabbed the cat")
	task_completed = true
	cat_state = CatStates.IDLE
	
func start_outlet_event()->void:
	print("cat is about to electricute himself!! stop him")
	if outlet:
		cur_cat = outlet.get_node("OutletCat")
		if cur_cat:
			cur_cat.visible = true
	if idle_cat:
		idle_cat.visible = false
	
	cur_tween = create_tween()
	if cur_cat:
		cur_tween.tween_property(cur_cat, "position", Vector2(cur_cat.position.x + 300, cur_cat.position.y), 1.5) 
		cur_tween.finished.connect(end_outlet_event)

func end_outlet_event()->void:
	if is_instance_valid(time_limit_timer):
		print("cat electricuted himself")
		cat_state = CatStates.IDLE
	else:
		pass

func _on_outlet_cat_button_down() -> void:
	print("you grabbed the cat")
	task_completed = true
	cat_state = CatStates.IDLE
	
func start_washing_machine_event()->void:
	print("cat is about to drown himself!! stop him")
	if washing_machine:
		cur_cat = washing_machine.get_node("Sprite2D")
		if cur_cat:
			cur_cat.visible = true
	if idle_cat:
		idle_cat.visible = false
	
	cur_tween = create_tween()
	if cur_cat:
		cur_tween.tween_property(cur_cat, "rotation", 5, 5) 
		cur_tween.finished.connect(end_washing_machine_event)

func end_washing_machine_event()->void:
	if is_instance_valid(time_limit_timer):
		print("cat drowned himself")
		cat_state = CatStates.IDLE
	else:
		pass

func _on_machine_cat_button_down() -> void:
	print("you grabbed the cat from the washing machine")
	task_completed = true
	cat_state = CatStates.IDLE

func _on_machine_door_button_down() -> void:
	if door:
		door.visible = !door.visible
