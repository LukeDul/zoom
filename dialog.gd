class_name DialogBubble
extends Node2D

@onready var dialog_label: Label = $ColorRect/Label
@onready var options_label: Label = $ColorRect/Label2
@onready var label1: Label = $HBoxContainer/TextureButton/Label
@onready var label2: Label = $HBoxContainer/TextureButton/Label
@onready var label3: Label = $HBoxContainer/TextureButton/Label

@onready var but1: TextureButton = $HBoxContainer/TextureButton
@onready var but2: TextureButton = $HBoxContainer/TextureButton2
@onready var but3: TextureButton = $HBoxContainer/TextureButton3
func set_dialog(text: String, responses: Array)->void:
	dialog_label.text = text
	options_label.text = "1. " + responses[0] + " 2. "+ responses[1] + " 3. " + responses[2]
	
	
func toggle_buttons()->void:
	but1.disabled = !but1.disabled
	but2.disabled = !but2.disabled
	but3.disabled = !but3.disabled
