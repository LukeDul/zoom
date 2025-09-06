class_name RoomView extends Node2D

enum CatStates {IDLE, CURTAINS, WASHING_MACHINE, OUTLET}

@onready var idle_cat: TextureButton = $IdleCat
@onready var outlet: Node2D = $Outlet
@onready var washing_machine: Node2D = $WashingMachine
@onready var curtain: Node2D = $Window

var cur_cat: TextureButton

var cat_state = CatStates.IDLE:
	set(v):
		match(v):
			CatStates.IDLE: 
				cur_cat.visible = false 
				idle_cat.visible = true
			CatStates.CURTAINS: start_curtain_event()
			CatStates.WASHING_MACHINE: pass
			CatStates.OUTLET: pass
			_: push_error("Unknown Cat State")
		cat_state = v

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cat_state = CatStates.CURTAINS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match(cat_state):
		CatStates.IDLE: pass
		CatStates.CURTAINS: pass
		CatStates.WASHING_MACHINE: pass
		CatStates.OUTLET: pass
		_: push_error("Unknown Cat State")
		
func start_curtain_event()->void:
	print("cat is ripping curtain!!")
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

	
## Calls the function after the given seconds have passed. Returns the timer. 
func call_later(seconds: float, callback_func: Callable) -> SceneTreeTimer:
	var timer = get_tree().create_timer(seconds)
	timer.timeout.connect(callback_func)
	return timer
