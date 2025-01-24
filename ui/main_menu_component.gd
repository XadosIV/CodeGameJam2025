extends Control

@export var options_file: String = "res://Scenes/ui/OptionsMenu.tscn"
@export var game_file: String = "res://Scenes/Map/11_3.tscn"

func _ready() -> void:
	AudioController.play_music(0)

func _on_play_pressed() -> void:
	AudioController.fade_music()
	get_tree().change_scene_to_file(game_file)


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file(options_file)


func _on_exit_pressed() -> void:
	get_tree().quit()
