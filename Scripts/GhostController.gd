extends Node

var rng = RandomNumberGenerator.new()
var ghost: PackedScene = preload("res://Prefab/ghost.tscn")

func _ready() -> void:
	GameManager.mental_health_decrease.connect(_on_mental_health_decrease)
	
func _on_mental_health_decrease(new: float) -> void:
	if new < 20:
		if rng.randi_range(1,60) == 7:
			var instance: Node = ghost.instantiate()
			get_tree().current_scene.add_child(instance)
