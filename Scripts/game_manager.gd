extends Node2D

signal mental_health_decrease(new)
signal mental_health_increase(new)

signal start_play_box
signal stop_play_box

signal start_rewind_box
signal stop_rewind_box

signal game_over

signal memory_collected(id: int)

@export var max_mental: float = 30
@export var decrease_rate: float = 1
@export var increase_rate: float = 5
var mental_health: float = max_mental

var player_pos: Vector2 = Vector2(200,0)
var enter_side: String  = ""
var corridor_offset: int = 0
var current_animation: String = "face"
var last_dir: Vector2 = Vector2.ZERO

var memories: Array[bool] = [false, false, false]

var is_playing_box: bool = false
var is_rewind_box: bool = false

var is_playing_memory: bool = false

var mainMenu: String = "res://Scenes/ui/MainMenu.tscn"

@onready var current_scene: Node = get_tree().current_scene

func _ready() -> void:
	game_over.connect(_on_game_over)

func _process(delta) -> void:
	if is_playing_memory: 
		return
	
	if not is_playing_box:
		mental_health -= (decrease_rate * delta)
		if mental_health <= 0:
			game_over.emit()	
		mental_health_decrease.emit(mental_health)
	else:
		if mental_health > max_mental:
			mental_health = max_mental
		else:
			mental_health += (increase_rate * delta)
		mental_health_increase.emit(mental_health)
		
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
	
	if not valid_map(mapcord):
		mapcord = find_map(enter_side, mapcord)
	
	print("changed to : " + mapcord[0]+"_"+mapcord[1]+".tscn")
	get_tree().change_scene_to_file("res://Scenes/Map/"+mapcord[0]+"_"+mapcord[1]+".tscn")

func valid_map(coord):
	return FileAccess.file_exists("res://Scenes/Map/"+coord[0]+"_"+coord[1]+".tscn")

func find_map(side, coord):
	var floor = floor(int(coord[0])/10)
	match side:
		"left":
			for i in range(floor*10+1,floor*10+10):
				if valid_map([str(i), coord[1]]):
					return [str(i), coord[1]]
		"right":
			for i in range(floor*10+9, floor*10, -1):
				if valid_map([str(i), coord[1]]):
					return [str(i), coord[1]]
		"top":
			for i in range(1,10):
				print(coord[0], " ", str(i))
				if valid_map([coord[0], str(i)]):
					return [coord[0], str(i)]
		"bot":
			for i in range(9, 0, -1):
				if valid_map([coord[0], str(i)]):
					return [coord[0], str(i)]
	
func collect_memory(id:int):
	if id >= 0 and id < memories.size():
		memories[id] = true
		memory_collected.emit(id)
		get_tree().current_scene.get_node("RenderCommon/TilemapController").update_tilemap()
	
func _set_is_play_box(value: bool) -> void:
	if value:
		start_play_box.emit()
	else:
		stop_play_box.emit()
	is_playing_box = value
	
func _set_is_rewind_box(value: bool) -> void:
	if value:
		start_rewind_box.emit()
	else:
		stop_rewind_box.emit()
	is_rewind_box = value
	
func _on_game_over() -> void:
	get_tree().change_scene_to_file(mainMenu)
