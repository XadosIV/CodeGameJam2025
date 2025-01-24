extends Area2D

signal on_plate_push
signal on_plate_release

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D

@export var pushed: String = "pushed"
@export var released: String = "released"

@export var scale_pushed: float = 0.5
@export var scale_released: float = 0.1

@export var allowed_bodies: Array = ["Clone", "Melody"]
	
var is_pushed: bool = false
var bodies: Array = []

func _ready() -> void:
	on_plate_push.connect(_on_plate_push)
	on_plate_release.connect(_on_plate_release)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not allowed_bodies.has(body.name):
		return
	is_pushed = true
	bodies.append(body)
	on_plate_push.emit()

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if not allowed_bodies.has(body.name):
		return
		
	bodies.erase(body)
	if bodies.size() == 0:
		is_pushed = false
		on_plate_release.emit()
		
func _on_plate_push() -> void:
	animator.play(pushed)
	light.set_texture_scale(scale_pushed)
	
func _on_plate_release() -> void:
	animator.play(released)
	light.set_texture_scale(scale_released)
	
