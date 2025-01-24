extends Node2D

var player_pos = Vector2(500,0)
var current_animation = "face"
var last_dir = Vector2.ZERO

func _ready():
	pass

func _process(delta):
	pass

func change_scene():
	var name = get_tree().current_scene.scene_file_path
	var mapcord = name.split("/")[3].split(".")[0].split("_")
	
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
	get_tree().change_scene_to_file("res://Map/"+mapcord[0]+"_"+mapcord[1]+".tscn")
