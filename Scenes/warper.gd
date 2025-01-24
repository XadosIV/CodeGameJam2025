extends Area2D

enum xy {HORIZONTAL,VERTICAL, BOTH}

@export var point: Node2D
@export var coord: xy


func _process(delta):
	pass


func _on_body_entered(body):
	GameManager.change_scene("main", "name")
