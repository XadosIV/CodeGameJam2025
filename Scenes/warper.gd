extends Area2D

enum xy {HORIZONTAL,VERTICAL, BOTH}

@export var point: Node2D
@export var coord: xy


func _process(delta):
	pass


func _on_body_entered(body):
	if coord == HORIZONTAL:
		body.position.x = point.position.x
	elif coord == VERTICAL:
		body.position.y = point.position.y
	else:
		body.position = point.position
