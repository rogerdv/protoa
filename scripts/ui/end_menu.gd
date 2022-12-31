extends Control

signal exit



func _on_button_pressed():
	emit_signal("exit")
	queue_free()
