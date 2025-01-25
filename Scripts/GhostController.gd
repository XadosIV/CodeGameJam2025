extends Node

@export var spawning_curve: Curve
var rng = RandomNumberGenerator.new()
var ghost: PackedScene = preload("res://Prefab/ghost.tscn")

func _ready() -> void:
	GameManager.mental_health_decrease.connect(_on_mental_health_decrease)
	
func _on_mental_health_decrease(new: float) -> void:
	if new < 20:
		var spawn_chance: float = spawning_curve.sample_baked(rng.randf_range(0.0, 1.0))
		if rng.randf_range(0.0, 1.0) < spawn_chance: 
			var instance: Node = ghost.instantiate()
			get_tree().current_scene.add_child(instance)
