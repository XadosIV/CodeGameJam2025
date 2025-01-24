extends CanvasLayer

@onready var options_menu = $OptionsMenu

@export var options_key: String = "ui_options"

func _ready() -> void:
	options_menu.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(options_key):
		options_menu.visible = not options_menu.visible
	
