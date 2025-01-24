extends Node

var clone_prefab: Resource = preload("res://Prefab/melody_clone.tscn")
var current_clone: Node2D

func _ready() -> void:
	RewindManager.start_rewind.connect(_on_start_rewind)
	RewindManager.stop_rewind.connect(_on_stop_rewind)
	RewindManager.current_rewind.connect(_on_current_rewind)

func _on_start_rewind() -> void:
	print("RewindController: start rewind")
	current_clone = clone_prefab.instantiate()
	get_parent().add_child(current_clone)
	
func _on_stop_rewind() -> void:
	print("RewindController: stop rewind")
	current_clone.queue_free()
	
func _on_current_rewind(position: Vector2) -> void:
	print("RewindController: current rewind")
	current_clone.position = position
