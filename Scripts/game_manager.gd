extends Node2D

signal mental_health_decrease(new)
signal mental_health_increase(new)

@export var max_mental: float = 30
@export var decrease_rate: float = 1
@export var increase_rate: float = 5
var mental_health: float = max_mental

@export var music_key: String = "ui_music"

var enter_side = ""
var corridor_offset = 0
var current_animation = "face"
var last_dir = Vector2.ZERO

var is_playing = false

func _ready():
	pass

func _process(delta):
	if not is_playing:
		mental_health -= (decrease_rate * delta)
		mental_health_decrease.emit(mental_health)
	else:
		if mental_health > max_mental:
			mental_health = max_mental
		else:
			mental_health += (increase_rate * delta)
		mental_health_increase.emit(mental_health)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(music_key):
		is_playing = true
	elif event.is_action_released(music_key):
		is_playing = false
		

func change_scene(offset, side, player):
	var name = get_tree().current_scene.scene_file_path
	var mapcord = name.split("/")[4].split(".")[0].split("_")
	current_animation = player.current_animation
	last_dir = player.last_direction
	var ppos = player.position
	if side == "left": #gauche -> droite
		mapcord[0] = str(int(mapcord[0])-1)
		enter_side = "right"
	elif side == "right": #droite -> gauche
		mapcord[0] = str(int(mapcord[0])+1)
		enter_side = "left"
	elif side == "top": #haut -> bas
		enter_side = "bot"
		mapcord[1] = str(int(mapcord[1])-1)
	elif side == "bot": #bas -> haut
		mapcord[1] = str(int(mapcord[1])+1)
		enter_side = "top"
	
	corridor_offset = offset
	print("changed to : " + mapcord[0]+"_"+mapcord[1]+".tscn")
	get_tree().change_scene_to_file("res://Scenes/Map/"+mapcord[0]+"_"+mapcord[1]+".tscn")
