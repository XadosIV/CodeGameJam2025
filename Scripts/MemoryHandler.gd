extends Area2D

signal player_entered

@onready var player = %Melody
@onready var sprite = $Sprite2D

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body == player:
		emit_signal("player_entered")
		_play_disable()

func _play_disable():
	var material = sprite.material
	if material is not ShaderMaterial:
		return
	shader = material
	currentSize = shader.get_shader_parameter("Size")
	shouldPlayAnimation = true
		


func _disable_interaction() -> void:
	collision_layer = 0
	collision_mask = 0
	visible = false
	set_physics_process(false)
