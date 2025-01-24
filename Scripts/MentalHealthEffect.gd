extends Node

@onready var rect = $ColorRect
@export var shader: ShaderMaterial
@export var env: Environment

@export var max_chaos: int = 32
@export var effect_curve: Curve

const value: String = "chaos"

func _ready() -> void:
	GameManager.mental_health_changed.connect(_on_health_changed)
	shader.set_shader_parameter(value, 0)
	env.adjustment_saturation = 1
	
func _on_health_changed(newValue):
	var percentage: float = newValue / GameManager.max_mental
	percentage = 1 - percentage
	var effect: float = effect_curve.sample(percentage)
	var chaos: int = int(effect * max_chaos)
	shader.set_shader_parameter(value,chaos)
	env.adjustment_saturation = 1 - effect
