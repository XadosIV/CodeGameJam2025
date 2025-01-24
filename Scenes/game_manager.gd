extends Node2D

var player_pos = Vector2(500,0)

func _ready():
	pass

func _process(delta):
	pass

func change_scene(new, name):
	player_pos = Vector2(0,0)
	
	get_tree().change_scene_to_file("res://Scenes/"+new+".tscn")
