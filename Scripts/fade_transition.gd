extends Control

signal fade_in_done

@onready var animator = $AnimationPlayer

# fonction fade_in 
func fade_in() -> void:
	print("t")
	animator.play_backwards("Fade")
	animator.animation_finished.connect(_on_fade_in_done)
	
func _on_fade_in_done() -> void:
	emit_signal("fade_in_done")	
