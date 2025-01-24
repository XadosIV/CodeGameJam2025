extends Node

@onready var rect = $ColorRect

@export var shader: ShaderMaterial
@export var env: Environment

@export var max_chaos: int = 32
@export var effect_curve: Curve

const value: String = "chaos"

func _ready() -> void:
	GameManager.mental_health_decrease.connect(_on_health_decrease)
	GameManager.mental_health_increase.connect(_on_health_increase)
	shader.set_shader_parameter(value, 0)
	env.adjustment_saturation = 1
	
func _on_health_decrease(newValue):
	var effect: float = getCurveValue(newValue)
	var chaos: int = int(effect * max_chaos)
	shader.set_shader_parameter(value,chaos)
	env.adjustment_saturation = 1 - effect

func _on_health_increase(newValue):
	var effect: float = getCurveValue(newValue)
	var chaos: int = int(effect * max_chaos)
	shader.set_shader_parameter(value,chaos)
	env.adjustment_saturation = 1 - effect
	
func getPercents(amount: float) -> float:
	return 1 - (amount / GameManager.max_mental)
	
func getCurveValue(amount: float) -> float:
	var percentage: float = getPercents(amount)
	return effect_curve.sample(percentage)	
