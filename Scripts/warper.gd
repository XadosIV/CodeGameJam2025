extends Area2D

var left = []
var right = []
var top = []
var bot = []
var border
var initiated = false

func _enter_tree():
	var magic_number = get_parent().get_node("%Melody").get_node("CollisionShape2D").position.y * 2
	var map = get_parent().get_node("TileMapLayer")
	border = get_node("Shape").shape.get_rect()
	
	#find top exit
	var y = border.position.y
	for i in range(border.position.x, border.end.x, 32):
		var mapcoor = map.local_to_map(Vector2(i, y))
		if map.get_cell_source_id(mapcoor) != -1:
			top.append(map.map_to_local(mapcoor)[0]-16)
			mapcoor[0] += 2
			top.append(map.map_to_local(mapcoor)[0]-16)
			break
	
	#find bot exit
	y = border.end.y
	for i in range(border.position.x, border.end.x, 32):
		var mapcoor = map.local_to_map(Vector2(i, y))
		if map.get_cell_source_id(mapcoor) != -1:
			bot.append(map.map_to_local(mapcoor)[0]-16)
			mapcoor[0] += 2
			bot.append(map.map_to_local(mapcoor)[0]-16)
			break
			
	#find left exit
	var x = border.position.x
	for i in range(border.position.y, border.end.y, 32):
		var mapcoor = map.local_to_map(Vector2(x, i))
		if map.get_cell_source_id(mapcoor) != -1:
			left.append(map.map_to_local(mapcoor)[1]-16)# - magic_number)
			mapcoor[1] += 2
			left.append(map.map_to_local(mapcoor)[1]-16)# - magic_number)
			break

	#find right exit
	x = border.end.x
	for i in range(border.position.y, border.end.y, 32):
		var mapcoor = map.local_to_map(Vector2(x, i))
		if map.get_cell_source_id(mapcoor) != -1:
			right.append(map.map_to_local(mapcoor)[1]-16)#- magic_number)
			mapcoor[1] += 2
			right.append(map.map_to_local(mapcoor)[1]-16)#- magic_number)
			break
	initiated = true

func _on_body_exited(body):
	var player = get_parent().get_node("%Melody")
	var magic_number = player.get_node("CollisionShape2D").position.y * 2.5
	var ppos = player.position
	
	var collision_side
	var offset
	
	if ppos.x < border.position.x: #gauche -> droite
		offset = ppos.y - left[0]
		collision_side = "left"
	elif ppos.x > border.end.x: #droite -> gauche
		offset = ppos.y - right[0]
		collision_side = "right"
	elif ppos.y + magic_number < border.position.y: #haut -> bas
		offset = ppos.x - top[0]
		collision_side = "top"
	elif ppos.y + magic_number > border.end.y: #bas -> haut
		offset = ppos.x - bot[0]
		collision_side = "bot"
	GameManager.change_scene(offset, collision_side, player)
