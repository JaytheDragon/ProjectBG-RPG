# DialogueManager.gd
extends Node

# Signal emitted when the entire dialogue sequence is finished.
signal dialogue_finished

# Reference to the DialogueUI scene (instanced in your game; you can also preload and add it as a child of your UI root).
@onready var dialogue_ui: Control = $DialogueUI

# Queue that holds the dialogue lines (each can be a dictionary or string for simplicity)
var dialogue_queue: Array[String] = []

func _ready():
	# Initially, hide the dialogue UI
	dialogue_ui.visible = false

func queue_dialogue(lines: Array[String]) -> void:
	dialogue_queue = lines.duplicate()
	_show_next_line()

func _show_next_line() -> void:
	if dialogue_queue.size() > 0:
		var next_line = dialogue_queue.pop_front()
		_display_line(next_line)
	else:
		_finish_dialogue()

func _display_line(line: String) -> void:
	# Show the dialogue UI and set the text.
	dialogue_ui.visible = true
	# Assuming DialogueUI has a RichTextLabel child called "Label"
	dialogue_ui.get_node("Label").text = line
	# Optionally, play a sound:
	_play_next_sound()

func _play_next_sound() -> void:
	# You can play a sound effect here. For example:
	var audio = preload("res://sounds/dialogue_click.mp3").instance()
	dialogue_ui.add_child(audio)
	audio.play()

func on_dialogue_next():  # Connected to a signal or button press on DialogueUI
	_show_next_line()

func _finish_dialogue() -> void:
	dialogue_ui.visible = false
	emit_signal("dialogue_finished")
