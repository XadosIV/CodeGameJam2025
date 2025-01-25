extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

var rng = RandomNumberGenerator.new()

var switch
var limit = rng.randi_range(10,20)

func _ready():
	var melody: Node = get_tree().current_scene.get_node("Melody")
	if melody == null:
		queue_free()
		return
	
	var ppos = melody.position
	
	position = Vector2(rng.randi_range(ppos.x-500, ppos.x+500), rng.randi_range(ppos.y-500, ppos.y+500))
	
	if rng.randi_range(1,2) == 1:
		var color = Color(1,1,1, rng.randf_range(0.3,0.8))
		modulate = color
	if rng.randi_range(1,5) == 1:
		animator.sprite_frames = load("res://Sprites/melody/normal_anim.tres")
	switch = rng.randf_range(0.5, 3)

func _process(delta):
	if GameManager.is_playing_box:
		if GameManager.mental_health >= limit:
			queue_free()
	switch -= delta
	if switch <= 0:
		switch = rng.randf_range(0.5, 3)
		var number = rng.randi_range(0,3)
		if number == 0:
			animator.flip_h = false
			animator.play("back_idle")
		elif number == 1:
			animator.play("face_idle")
			animator.flip_h = false
		elif number == 2:
			animator.flip_h = false
			animator.play("side_idle")
		elif number == 3:
			animator.flip_h = true
			animator.play("side_idle")
