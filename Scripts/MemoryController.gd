extends Control

@onready var animator = $AnimationPlayer

@export var memory_1: String = "memory_1"
@export var memory_2: String = "memory_2"
@export var memory_3: String = "memory_3"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.memory_collected.connect(_on_memory_collected)
	animator.animation_finished.connect(_on_animation_finished)
	visible = false
	
func _on_memory_collected(id: int) -> void:
	AudioController.play_music(0,true)
	GameManager.is_playing_memory = true
	match id:
		0:
			play_first_memory()
		1:
			play_second_memory()
		2:
			play_third_memory()
	
func _on_animation_finished(_anime_name: String) -> void:
	visible = false
	GameManager.is_playing_memory = false
	AudioController.stop_music(true)
	
func play_first_memory() -> void:
	visible = true
	animator.play(memory_1)
	
func play_second_memory() -> void:
	visible = true
	animator.play(memory_2)
	
func play_third_memory() -> void:
	visible = true
	animator.play(memory_3)
