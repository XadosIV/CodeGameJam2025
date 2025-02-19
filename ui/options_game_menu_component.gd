extends Control

@onready var global_label = $MarginContainer/VBoxContainer/Volumes/Global/VolumeAmount
@onready var music_label = $MarginContainer/VBoxContainer/Volumes/Music/VolumeAmount
@onready var sfx_label = $MarginContainer/VBoxContainer/Volumes/Sound/VolumeAmount

@onready var global_slider = $MarginContainer/VBoxContainer/Volumes/Global/Volume
@onready var music_slider = $MarginContainer/VBoxContainer/Volumes/Music/Volume
@onready var sfx_slider = $MarginContainer/VBoxContainer/Volumes/Sound/Volume

@onready var fullscreen : CheckButton = $MarginContainer/VBoxContainer/Fullscreen/CheckButton

@export var main_menu: String = "res://Scenes/ui/MainMenu.tscn"

func _ready() -> void:
	var displayType: int = DisplayServer.mouse_get_mode();
	var isFullscreen: bool = false
	if displayType == DisplayServer.WINDOW_MODE_FULLSCREEN:
		isFullscreen = true
	elif displayType == DisplayServer.WINDOW_MODE_WINDOWED:
		isFullscreen = false
	fullscreen.button_pressed = isFullscreen
	
	global_label.text = str(AudioController.get_global_volume_percentage())
	music_label.text = str(AudioController.get_music_volume_percentage())
	sfx_label.text = str(AudioController.get_sound_volume_percentage())

	global_slider.value = AudioController.get_global_volume_percentage()
	music_slider.value = AudioController.get_music_volume_percentage()
	sfx_slider.value = AudioController.get_sound_volume_percentage()

func _on_back_pressed() -> void:
	visible = false

func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	var displayType: int = 0
	if toggled_on:
		displayType = DisplayServer.WINDOW_MODE_FULLSCREEN
	else:
		displayType = DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(displayType)


func _on_global_value_changed(value: float) -> void:
	AudioController.set_global_volume_percentage(value)
	global_label.text = str(value)


func _on_music_value_changed(value: float) -> void:
	AudioController.set_music_volume_percentage(value)
	music_label.text = str(value)


func _on_sound_value_changed(value: float) -> void:
	AudioController.set_sound_volume_percentage(value)
	sfx_label.text = str(value)
