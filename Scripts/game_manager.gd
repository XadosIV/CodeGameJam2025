extends Node2D

var player_pos = Vector2(200,0)
var current_animation = "face"
var last_dir = Vector2.ZERO

var is_playing = false

var mental_health = 2000

func _ready():
	pass

func _process(delta):
	if not is_playing:
		mental_health -= 1
	else:
		if mental_health > 2000:
			mental_health = 2000
		else:
			mental_health += 5

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