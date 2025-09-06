class_name DialogBubble
extends Node2D

@onready var dialog_label: Label = $ColorRect/Label
@onready var label1: Label = $ColorRect/TextOptions/label1
@onready var label2: Label = $ColorRect/TextOptions/label2
@onready var label3: Label = $ColorRect/TextOptions/label3

@onready var but1: TextureButton = $ColorRect/TextOptions/label1/option1
@onready var but2: TextureButton = $ColorRect/TextOptions/label2/option2
@onready var but3: TextureButton = $ColorRect/TextOptions/label3/option3

func set_dialog(text: String, responses: Array)->void:
	if dialog_label:
		dialog_label.text = text
	
	if but1 and label1:
		label1.text = "A) " + responses[0] if responses.size() > 0 else ""
		but1.visible = responses.size() > 0
	
	if but2 and label2:
		label2.text = "B) " + responses[1] if responses.size() > 1 else ""
		but2.visible = responses.size() > 1
	
	if but3 and label3:
		label3.text = "C) " + responses[2] if responses.size() > 2 else ""
		but3.visible = responses.size() > 2


func toggle_buttons()->void:
	if but1:
		but1.disabled = !but1.disabled
	if but2:
		but2.disabled = !but2.disabled
	if but3:
		but3.disabled = !but3.disabled
