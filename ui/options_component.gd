extends Control

@onready var global_label = $MarginContainer/VBoxContainer/Volumes/Global/VolumeAmount
@onready var music_label = $MarginContainer/VBoxContainer/Volumes/Music/VolumeAmount
@onready var sfx_label = $MarginContainer/VBoxContainer/Volumes/Sound/VolumeAmount

@onready var global_slider = $MarginContainer/VBoxContainer/Volumes/Global/Volume
@onready var music_slider = $MarginContainer/VBoxContainer/Volumes/Music/Volume
@onready var sfx_slider = $MarginContainer/VBoxContainer/Volumes/Sound/Volume

@export var main_menu: String = "res://Scenes/ui/MainMenu.tscn"

func _ready() -> void:
	global_label.text = str(AudioController.global_volume)
	music_label.text = str(AudioController.get_music_volume())
	sfx_label.text = str(AudioController.get_sound_volume())
	
	global_slider.value = AudioController.global_volume
	music_slider.value = AudioController.get_music_volume()
	sfx_slider.value = AudioController.get_sound_volume()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(main_menu)

func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	var displayType: int = 0
	if toggled_on:
		displayType = DisplayServer.WINDOW_MODE_FULLSCREEN
	else:
		displayType = DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(displayType)


func _on_global_value_changed(value: float) -> void:
	AudioController.global_volume = value
	global_label.text = str(value)


func _on_music_value_changed(value: float) -> void:
	AudioController.set_music_volume_percentage(value)
	music_label.text = str(value)


func _on_sound_value_changed(value: float) -> void:
	AudioController.set_sound_volume_percentage(value)
	sfx_label.text = str(value)
