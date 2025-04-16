extends Node

func displayNumber(value: int, position: Vector2, isCritical: bool = false):
		var number = Label.new()
		var color = "#FFF"
		if isCritical:
			color = "#FFA500"
		if value == 0:
			color = "#808080"
		if value < 0:
			color = "Green"
			value *= -1
		number.global_position = position
		number.text = str(value)
		number.z_index = 3
		number.label_settings = LabelSettings.new()
		
		
		
		number.label_settings.font_color = color
		number.label_settings.font_size = 18
		number.label_settings.outline_color = "#000"

		call_deferred("add_child", number)
		
		await number.resized
		number.pivot_offset = Vector2(number.size / 2)
		
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(
			number, "position:y", number.global_position.y - 23, 0.25
		).set_ease(Tween.EASE_OUT)
		tween.tween_property(
			number, "position:y", number.global_position.y, 0.5
		).set_ease(Tween.EASE_IN).set_delay(0.25)
		tween.tween_property(
			number, "scale", Vector2.ZERO, 0.25
		).set_ease(Tween.EASE_IN).set_delay(0.5)
		
		await tween.finished
		number.queue_free()
