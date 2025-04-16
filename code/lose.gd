extends Node2D

@onready var button = $RestartButton

func _ready():
	button.connect("pressed", Callable(self, "_on_button_pressed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_button_pressed() -> void:
	print("starting game again!")
	get_tree().change_scene_to_file("res://fight1-1.tscn")
	
func _on_home_button_pressed() -> void:
	print("Returning home again!")
	get_tree().change_scene_to_file("res://start.tscn")
