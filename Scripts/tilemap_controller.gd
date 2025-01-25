extends Node2D


func _ready():
	hide_tilemaps()
	update_tilemap()

func hide_tilemaps():
	for i in range(0,3):
		var tilemap = get_tree().current_scene.get_node("Key"+str(i))
		if tilemap:
			tilemap.visible = not GameManager.memories[i]

func update_tilemap():
	var bt = get_tree().current_scene.get_node("TileMapLayer")
	var used_tiles = bt.get_used_cells()
	for i in range(0,3):
		if not GameManager.memories[i]:
			var adj = []
			var horizontal_check = []
			var vertical_check = []
			var tilemap = get_tree().current_scene.get_node("Key"+str(i))
			if tilemap:
				var ut = tilemap.get_used_cells()
				for tile in used_tiles:
					var x = tile.x
					var y = tile.y
					if ut.has(Vector2i(x,y+1)):
						adj.append(tile)
						horizontal_check.append(Vector2i(x,y+1))
					elif ut.has(Vector2i(x,y-1)):
						adj.append(tile)
						horizontal_check.append(Vector2i(x,y-1))
					elif ut.has(Vector2i(x-1,y)):
						adj.append(tile)
						vertical_check.append(Vector2i(x-1,y))
						 
					elif ut.has(Vector2i(x+1,y)):
						adj.append(tile)
						vertical_check.append(Vector2i(x+1,y))
			
				for tile in adj:
					bt.set_cell(tile, 0, Vector2i(1,1))
				for tile in horizontal_check:
					if ut.has(Vector2i(tile.x+1,tile.y)): # si droite
						if ut.has(Vector2i(tile.x-1,tile.y)): # si gauche
							tilemap.set_cell(tile, 0, Vector2i(1,1))
						else:
							tilemap.set_cell(tile, 0, Vector2i(0,1))
					elif ut.has(Vector2i(tile.x-1,tile.y)): # si gauche
						tilemap.set_cell(tile, 0, Vector2i(2,1))
					else:
						tilemap.set_cell(tile, 0, Vector2i(4,1))
				for tile in vertical_check:
					if ut.has(Vector2i(tile.x,tile.y-1)): # si haut
						if ut.has(Vector2i(tile.x,tile.y+1)): # si bas
							tilemap.set_cell(tile, 0, Vector2i(1,1))
						else:
							tilemap.set_cell(tile, 0, Vector2i(1,2))
					elif ut.has(Vector2i(tile.x,tile.y+1)): # si bas
						tilemap.set_cell(tile, 0, Vector2i(1,0))
					else:
						tilemap.set_cell(tile, 0, Vector2i(7,0))
