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

var enter_side: String  = ""
var corridor_offset: int = 0
var current_animation: String = "face"
var last_dir: Vector2 = Vector2.ZERO

var memories: Array[bool] = [false, false, false]
var plateEnigme: Dictionary = {}

var is_playing_box: bool = false
var is_rewind_box: bool = false

var is_playing_memory: bool = false

var mainMenu: String = "res://Scenes/ui/MainMenu.tscn"

var gameover

@onready var current_scene: Node = get_tree().current_scene

func _ready() -> void:
	game_over.connect(_on_game_over)
	
	gameover = TextureRect.new()
	gameover.texture = preload("res://gameover.png")
	gameover.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	gameover.size_flags_vertical = Control.SIZE_EXPAND_FILL
	gameover.visible = false
	
	AudioController.play_sound(0)

func start():
	is_playing_box = false
	is_playing_memory = false
	is_rewind_box = false
	plateEnigme = {}
	memories = [false, false, false]
	mental_health = max_mental

func _process(delta) -> void:
	if get_tree().current_scene is Control:
		return
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
	"""HARDCODE DES ASCENSEURS LETZGOO"""
	if mapcord[0] == "1" and mapcord[1] == "3" and side == "top": #sous-sol
		mapcord[0] = "11"
		mapcord[1] = "4"
		side = "bot"
		current_animation = "face_idle"
	elif mapcord[0] == "11" and mapcord[1] == "5" and side == "top":
		mapcord[0] = "1"
		mapcord[1] = "2"
		side = "bot"
		current_animation = "face_idle"
	elif mapcord[0] == "10" and mapcord[1] == "6" and side == "top":
		mapcord[0] = "23"
		mapcord[1] = "4"
		side = "bot"
		current_animation = "face_idle"
	elif mapcord[0] == "23" and mapcord[1] == "5" and side == "top":
		mapcord[0] = "10"
		mapcord[1] = "5"
		side = "bot"
		current_animation = "face_idle"
	elif mapcord[0] == "23" and mapcord[1] == "3" and side == "top":
		mapcord[0] = "30"
		mapcord[1] = "0"
		side = "bot"
		current_animation = "face_idle"
	elif mapcord[0] == "30" and mapcord[1] == "1" and side == "top":
		mapcord[0] = "23"
		mapcord[1] = "2"
		side = "bot"
		current_animation = "face_idle"
	elif mapcord[0] == "14" and mapcord[1] == "3" and side == "top":
		mapcord[0] = "4"
		mapcord[1] = "1"
		side = "bot"
		current_animation = "face_idle"
	elif mapcord[0] == "4" and mapcord[1] == "2" and side == "top":
		mapcord[0] == "14"
		mapcord[1] == "2"
		side = "bot"
		current_animation = "face_idle"
	"""FIN DE LA TRICHE"""
	
	
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
	
	print(mapcord)	
	if not valid_map(mapcord):
		mapcord = find_map(enter_side, mapcord)
		
	print(mapcord)	
	print_directory_contents("res://Scenes/Map/")
	
	print("changed to : " + mapcord[0]+"_"+mapcord[1]+".tscn")
	get_tree().change_scene_to_file("res://Scenes/Map/"+mapcord[0]+"_"+mapcord[1]+".tscn")

func valid_map(coord):
	var dir = DirAccess.open("res://Scenes/Map/")
	if dir:
		return dir.file_exists(str(coord[0]) + "_" + str(coord[1]) + ".tscn.remap")
	return false
	
func print_directory_contents(directory_path: String, indent: String = ""):
	var dir = DirAccess.open(directory_path)
	if dir:
		dir.list_dir_begin()  # Commence à lister les fichiers
		var file_name = dir.get_next()
		
		while file_name != "":
			# Si c'est un répertoire, on appelle récursivement la fonction
			if dir.current_is_dir():
				print(indent + "[DIR] " + file_name)
				print_directory_contents(directory_path + "/" + file_name, indent + "  ")
			else:
				# Sinon, on imprime le fichier
				print(indent + "[FILE] " + file_name)
			
			file_name = dir.get_next()  # Passe au fichier suivant
		
		dir.list_dir_end()  # Termine la liste des fichiers
	

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
