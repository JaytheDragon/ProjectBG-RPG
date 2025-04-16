extends Node

@export var theme := preload("res://sounds/Jeremy Blake - Powerup! (1).wav")  # your music file
var player: AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()
	player.stream = theme
	player.autoplay = true
	add_child(player)
	player.play()
