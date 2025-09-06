class_name DialogBubble
extends Node2D

@onready var dialog_label: Label = $ColorRect/Label
@onready var options_label: Label = $ColorRect/Label2
@onready var label1: Label = $HBoxContainer/TextureButton/Label
@onready var label2: Label = $HBoxContainer/TextureButton2/Label
@onready var label3: Label = $HBoxContainer/TextureButton3/Label

@onready var but1: TextureButton = $HBoxContainer/TextureButton
@onready var but2: TextureButton = $HBoxContainer/TextureButton2
@onready var but3: TextureButton = $HBoxContainer/TextureButton3

func set_dialog(text: String, responses: Array)->void:
	if dialog_label:
		dialog_label.text = text
	
	if but1 and label1:
		label1.text = responses[0] if responses.size() > 0 else ""
		but1.visible = responses.size() > 0
	
	if but2 and label2:
		label2.text = responses[1] if responses.size() > 1 else ""
		but2.visible = responses.size() > 1
	
	if but3 and label3:
		label3.text = responses[2] if responses.size() > 2 else ""
		but3.visible = responses.size() > 2
	
	if options_label:
		options_label.text = ""

func toggle_buttons()->void:
	if but1:
		but1.disabled = !but1.disabled
	if but2:
		but2.disabled = !but2.disabled
	if but3:
		but3.disabled = !but3.disabled
