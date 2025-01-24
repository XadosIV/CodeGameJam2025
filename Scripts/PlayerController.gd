extends CharacterBody2D

@onready var animator = $AnimatedSprite2D
@onready var particle = $Music_Particles

@export var speed: float = 300

var last_direction: Vector2   = Vector2.ZERO
var current_animation: String = "face"

var updated: bool = false

func _enter_tree():
	if not updated:
		update_pos()

func _ready():
	update_animation(last_direction)
	GameManager.mental_health_increase.connect(_on_health_increase)
	GameManager.mental_health_decrease.connect(_on_health_decrease)


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

func update_pos():
	updated = true
	current_animation = GameManager.current_animation
	last_direction = GameManager.last_dir
	var map = get_parent().get_node("MapBorder")
	if not map.initiated:
		await get_parent().get_node("MapBorder").tree_entered
	match GameManager.enter_side:
		"left":
			position = Vector2(map.border.position.x + 2, map.left[0]+GameManager.corridor_offset)
		"right":
			position = Vector2(map.border.end.x - 2, map.right[0]+GameManager.corridor_offset)
		"top":
			position = Vector2(map.top[0]+GameManager.corridor_offset, map.border.position.y + 50)
		"bot":
			position = Vector2(map.bot[0] + GameManager.corridor_offset, map.border.end.y - 50)
	

func _on_draw():
	if not updated:
		update_pos()
		
func _on_health_increase(newValue):
	particle.emitting = true
	
func _on_health_decrease(newValue):
	particle.emitting = false	
