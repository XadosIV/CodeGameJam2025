extends Node

var clone_prefab: Resource = preload("res://Prefab/melody_clone.tscn")
var current_clone: Node2D

func _ready() -> void:
	RewindManager.start_rewind.connect(_on_start_rewind)
	RewindManager.stop_rewind.connect(_on_stop_rewind)
	RewindManager.current_rewind.connect(_on_current_rewind)

func _on_start_rewind() -> void:
	current_clone = clone_prefab.instantiate()
	get_tree().current_scene.add_child(current_clone)
	AudioController.play_music(1, true)
	
func _on_stop_rewind() -> void:
	current_clone.queue_free()
	AudioController.stop_music(true)
	
func _on_current_rewind(position: Vector2) -> void:
	current_clone.position = position
