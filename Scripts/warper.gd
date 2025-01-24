extends Area2D

func _ready():
	var map = get_parent().get_node("TileMapLayer")
	var border = get_node("Shape").shape.get_rect()
	
	#find top exit
	var y = border.position.y
	var top = []
	for i in range(border.position.x, border.end.x, 32):
		var mapcoor = map.local_to_map(Vector2(i, y))
		if map.get_cell_source_id(mapcoor) != -1:
			map.erase_cell(mapcoor)
			top.append(map.map_to_local(mapcoor)[0]-16)
			mapcoor[0] += 2
			top.append(map.map_to_local(mapcoor)[0]-16)
			break
	
	#find bot exit
	y = border.end.y
	var bot = []
	for i in range(border.position.x, border.end.x, 32):
		var mapcoor = map.local_to_map(Vector2(i, y))
		if map.get_cell_source_id(mapcoor) != -1:
			map.erase_cell(mapcoor)
			bot.append(map.map_to_local(mapcoor)[0]-16)
			mapcoor[0] += 2
			bot.append(map.map_to_local(mapcoor)[0]-16)
			break
			
	#find left exit
	var x = border.position.x
	var left = []
	for i in range(border.position.y, border.end.y, 32):
		var mapcoor = map.local_to_map(Vector2(x, i))
		if map.get_cell_source_id(mapcoor) != -1:
			map.erase_cell(mapcoor)
			left.append(map.map_to_local(mapcoor)[1]-16)
			mapcoor[1] += 2
			left.append(map.map_to_local(mapcoor)[1]-16)
			break

	#find right exit
	x = border.end.x
	var right = []
	for i in range(border.position.y, border.end.y, 32):
		var mapcoor = map.local_to_map(Vector2(x, i))
		if map.get_cell_source_id(mapcoor) != -1:
			map.erase_cell(mapcoor)
			right.append(map.map_to_local(mapcoor)[1])
			mapcoor[1] += 2
			right.append(map.map_to_local(mapcoor)[1])
			break

	print(right) # [-480, -416]

func _on_body_exited(body):
	GameManager.change_scene()
