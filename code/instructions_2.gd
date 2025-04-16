extends Node2D

@onready var button = $StartButton
@onready var button2 = $nextButton

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	print("starting game again!")
	get_tree().change_scene_to_file("res://fight1-1.tscn")
	
func _on_next_button_pressed() -> void:
	print("going to back a page!")
	get_tree().change_scene_to_file("res://instructions.tscn")

func _on_home_button_pressed() -> void:
	print("Returning home again!")
	get_tree().change_scene_to_file("res://start.tscn")
