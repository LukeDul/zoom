class_name RoomView extends Node2D

enum CatStates {IDLE, CURTAINS, WASHING_MACHINE, OUTLET}
var event_queue: Array[int] = [CatStates.CURTAINS, CatStates.OUTLET, CatStates.WASHING_MACHINE]
@onready var idle_cat: TextureButton = $IdleCat
@onready var outlet: Node2D = $Outlet
@onready var washing_machine: Node2D = $WashingMachine
#@onready var door = washing_machine.get_node("machine_door")
@onready var curtain: Node2D = $Window

# A custom signal to communicate back to the main script.
signal room_tasks_completed(success: bool)

var cur_cat
var cur_tween: Tween
var cat_event_started = false
var task_completed = false # Correctly declared here

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

var is_holding_cat: bool = false:
	set(v):
		$HeldCat.visible = v
		$IdleCat.visible = !v
		is_holding_cat = v
		
func _process(_delta: float) -> void:
	if is_holding_cat == true:
		$HeldCat.global_position = get_global_mouse_position()
		
	
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

func start_next_event():
	task_completed = false
	cat_event_started = true
	
	cat_state = event_queue.pop_front()
	self.show_cat_event()

func show_cat_event():
	pass
	if not cat_event_started: return
	
	match(cat_state):
		CatStates.CURTAINS: start_curtain_event()
		CatStates.WASHING_MACHINE: start_washing_machine_event()
		CatStates.OUTLET: start_outlet_event()
	
func start_curtain_event()->void:
	print("cat is ripping curtain!! stop him")
	Global.play("tear")
	cur_cat = curtain.get_node("WindowCat")
	cur_cat.visible = true
	idle_cat.visible = false
	
	cur_tween = create_tween()
	if cur_cat:
		cur_tween.tween_property(cur_cat, "position", Vector2(cur_cat.position.x, cur_cat.position.y + 300), 3.61) 
		cur_tween.finished.connect(end_curtain_event)

func end_curtain_event()->void:
	print("cat tore up curtain")
	curtain.get_node("AnimatedSprite2D").play("torn")
	
	cat_state = CatStates.IDLE
	

func _on_window_cat_button_down() -> void:
	print("you grabbed the cat")
	Global.stop() # Stops the "tear" sfx, but the music continues.
	task_completed = true
	cat_state = CatStates.IDLE
	is_holding_cat = true 
	
func start_outlet_event()->void:
	Global.play("hehe")
	print("cat is about to electricute himself!! stop him")
	if outlet:
		cur_cat = outlet.get_node("OutletCat")
		if cur_cat:
			cur_cat.visible = true
	if idle_cat:
		idle_cat.visible = false
	
	cur_tween = create_tween()
	if cur_cat:
		cur_tween.tween_property(cur_cat, "position", Vector2(cur_cat.position.x + 450, cur_cat.position.y - 200), 5) 
		cur_tween.finished.connect(end_outlet_event)

func end_outlet_event()->void:
	print("cat electricuted himself")
	$Outlet/OutletSprite.play("burnt")
	cat_state = CatStates.IDLE
	

func _on_outlet_cat_button_down() -> void:
	print("you grabbed the cat")
	# Ruckus music continues to play.
	task_completed = true
	cat_state = CatStates.IDLE
	Global.stop()
	is_holding_cat = true
	
func start_washing_machine_event()->void:
	print("cat is about to drown himself!! stop him")
	cur_cat = washing_machine.get_node("Sprite2D")
	Global.play("thump")
	cur_cat.visible = true
	idle_cat.visible = false
	
	cur_tween = create_tween()
	if cur_cat:
		cur_tween.tween_property(cur_cat, "rotation", 250, 70) 
		cur_tween.finished.connect(end_washing_machine_event)

func end_washing_machine_event()->void:
	#$WashingMachine/Wash.play("open")
	print("cat drowned himself")
	cat_state = CatStates.IDLE


func _on_machine_cat_button_down() -> void:
	print("you grabbed the cat from the washing machine")
	# Ruckus music continues to play.
	$WashingMachine/Wash.play("open")
	task_completed = true
	Global.stop()
	cat_state = CatStates.IDLE
	is_holding_cat = true


func _on_texture_button_button_down() -> void:
	if is_holding_cat:
		is_holding_cat = false
