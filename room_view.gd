class_name RoomView extends Node2D

enum CatStates {IDLE, CURTAINS, WASHING_MACHINE, OUTLET}

@onready var idle_cat: TextureButton = $IdleCat
@onready var outlet: Node2D = $Outlet
@onready var washing_machine: Node2D = $WashingMachine
@onready var door = washing_machine.get_node("machine_door")
@onready var curtain: Node2D = $Window

## Calls the function after the given seconds have passed. Returns the timer. 
func call_later(seconds: float, callback_func: Callable) -> SceneTreeTimer:
	var timer = get_tree().create_timer(seconds)
	timer.timeout.connect(callback_func)
	return timer

var cur_cat

var cat_state = CatStates.IDLE:
	set(v):
		match(v):
			CatStates.IDLE: 
				cur_cat.visible = false 
				idle_cat.visible = true
			CatStates.CURTAINS: start_curtain_event()
			CatStates.WASHING_MACHINE: start_washing_machine_event()
			CatStates.OUTLET: start_outlet_event()
			_: push_error("Unknown Cat State")
		cat_state = v

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cat_state = CatStates.OUTLET


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cat_state == CatStates.IDLE:
		if Input.is_action_just_pressed("debug1"):
			cat_state = CatStates.CURTAINS
		elif Input.is_action_just_pressed("debug2"):
			cat_state = CatStates.WASHING_MACHINE
		elif Input.is_action_just_pressed("debug3"):
			cat_state = CatStates.OUTLET
	
	match(cat_state):
		CatStates.IDLE: pass
		CatStates.CURTAINS: pass
		CatStates.WASHING_MACHINE: pass
		CatStates.OUTLET: pass
		_: push_error("Unknown Cat State")
		
		
## CURTAIN EVENT *********************************************************************************
func start_curtain_event()->void:
	print("cat is ripping curtain!! stop him")
	Global.play("tear")
	cur_cat = curtain.get_node("WindowCat")
	cur_cat.visible = true
	idle_cat.visible = false
	
	var tween := create_tween()
	tween.tween_property(cur_cat, "position", Vector2(cur_cat.position.x, cur_cat.position.y + 300), 1.0) 
	tween.finished.connect(end_curtain_event)

func end_curtain_event()->void:
	if cat_state == CatStates.CURTAINS:
		print("cat tore up curtain")
	
	cat_state = CatStates.IDLE

func _on_window_cat_button_down() -> void:
	print("you grabbed the cat")
	cat_state = CatStates.IDLE
	
## OUTLET EVENT *********************************************************************************
func start_outlet_event()->void:
	Global.play("hehe")
	print("cat is about to electricute himself!! stop him")
	cur_cat = outlet.get_node("OutletCat")
	cur_cat.visible = true
	idle_cat.visible = false
	
	var tween := create_tween()
	tween.tween_property(cur_cat, "position", Vector2(cur_cat.position.x + 300, cur_cat.position.y), 1.5) 
	tween.finished.connect(end_outlet_event)

func end_outlet_event()->void:
	if cat_state == CatStates.OUTLET:
		
		print("cat electricuted himself")
	
	cat_state = CatStates.IDLE

func _on_outlet_cat_button_down() -> void:
	print("you grabbed the cat")
	cat_state = CatStates.IDLE
	
## WASHING MACHINE EVENT *********************************************************************************
func start_washing_machine_event()->void:
	print("cat is about to drown himself!! stop him")
	cur_cat = washing_machine.get_node("Sprite2D")
	Global.play("thump")
	cur_cat.visible = true
	idle_cat.visible = false
	
	var tween := create_tween()
	tween.tween_property(cur_cat, "rotation", 5, 5) 
	tween.finished.connect(end_washing_machine_event)

func end_washing_machine_event()->void:
	if cat_state == CatStates.OUTLET:
		print("cat drowned himself")
	
	cat_state = CatStates.IDLE

func _on_machine_cat_button_down() -> void:
	print("you grabbed the cat from the washing machine")
	cat_state = CatStates.IDLE


func _on_machine_door_button_down() -> void:
	door.visible = !door.visible
