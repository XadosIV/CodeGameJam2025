extends Area2D

signal player_entered

@onready var player = %Melody
@onready var sprite = $Sprite2D
@onready var animator = $AnimationPlayer

@export var memory_id: int

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body == player:
		emit_signal("player_entered")
		animator.play("disable")
		print("enter")
		GameManager.collect_memory(memory_id)
		_disable_interaction()

func _disable_interaction() -> void:
	collision_layer = 0
	collision_mask = 0
	visible = false
	set_physics_process(false)
