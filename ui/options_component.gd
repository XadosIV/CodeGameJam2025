extends Control

@onready var volume_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/VolumeAmount

@export var main_menu: String = "res://Scenes/ui/MainMenu.tscn"

func _ready() -> void:
	volume_label.text = str(0)

func _on_volume_value_changed(value: float) -> void:
	volume_label.text = str(value)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(main_menu)
