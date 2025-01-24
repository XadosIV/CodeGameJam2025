extends Area2D

func _on_body_exited(body):
	GameManager.change_scene()
