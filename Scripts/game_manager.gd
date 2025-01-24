extends Node2D

signal mental_health_decrease(new)
signal mental_health_increase(new)

@export var max_mental: float = 30
@export var decrease_rate: float = 1
@export var increase_rate: float = 5
var mental_health: float = max_mental

@export var music_key: String = "ui_music"

var memories: Array[bool] = [false, false, false]

var player_pos = Vector2(200,0)
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
		

func change_scene():
	var name = get_tree().current_scene.scene_file_path
	var mapcord = name.split("/")[4].split(".")[0].split("_")
	
	var player = get_tree().current_scene.get_node("Melody")
	var ppos = player.position
	
	current_animation = player.current_animation
	last_dir = player.last_direction
	
	var border = get_tree().current_scene.get_node("MapBorder").get_node("Shape").shape.get_rect()
	
	if ppos.x < border.position.x: #gauche -> droite
		mapcord[0] = str(int(mapcord[0])-1)
		player_pos[0] = border.end.x -1
		player_pos[1] = ppos[1]
	elif ppos.x > border.end.x: #droite -> gauche
		mapcord[0] = str(int(mapcord[0])+1)
		player_pos[0] = border.position.x +1
		player_pos[1] = ppos[1]
	elif ppos.y < border.position.y: #haut -> bas
		mapcord[1] = str(int(mapcord[1])-1)
		player_pos[1] = border.end.y -1
		player_pos[0] = ppos[0]
	elif ppos.y > border.end.y: #bas -> haut
		mapcord[1] = str(int(mapcord[1])+1)
		player_pos[1] = border.position.y +1
		player_pos[0] = ppos[0]
	
	
	print("changed to : " + mapcord[0]+"_"+mapcord[1]+".tscn")
	get_tree().change_scene_to_file("res://Scenes/Map/"+mapcord[0]+"_"+mapcord[1]+".tscn")
	
func collect_memory(id:int):
	if id >= 0 and id < memories.size():
		memories[id] = true
		print("Memory collected:", id)
		print(memories)
