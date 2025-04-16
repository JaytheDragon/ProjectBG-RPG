extends Node2D

@onready var button = $RestartButton

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	print("starting game!")
	get_tree().change_scene_to_file("res://fight1-1.tscn")
	
func _on_instructions_button_pressed() -> void:
	print("Moving to Instructions!")
	get_tree().change_scene_to_file("res://instructions.tscn")
	

func _on_IP_button_pressed() -> void:
	print("Moving to Innate Potential!")
	get_tree().change_scene_to_file("res://ip.tscn")
	
