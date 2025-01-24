extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

@export var speed: float = 300

var last_direction = Vector2.ZERO  # Variable pour suivre la dernière direction
var current_animation = ""  # Variable pour suivre l'animation en cours

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = direction.normalized()

	# Si la direction a changé, mettre à jour l'animation
	if direction != last_direction:
		last_direction = direction
		update_animation(direction)
	
	# Déplace le personnage en fonction de la direction
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	
	move_and_slide()

	# Si on n'est pas en mouvement, rester dans l'animation idle correspondant à la dernière direction
	if direction == Vector2.ZERO:
		play_animation(current_animation, direction)  # Garde l'animation idle correspondante

func update_animation(direction: Vector2) -> void:
	if direction.y < 0:
		play_animation("back", direction)
	elif direction.y > 0:
		if direction.x != 0:
			play_animation("side", direction)
		else:
			play_animation("face", direction)
	elif direction.x != 0:
		play_animation("side", direction)

func play_animation(anim: String, direction: Vector2) -> void:
	if direction.x < 0:
		animator.flip_h = true
	elif direction.x > 0:
		animator.flip_h = false
	current_animation = anim
	if direction == Vector2.ZERO:
		animator.play(anim+"_idle")
	else:
		animator.play(anim+"_walk")
