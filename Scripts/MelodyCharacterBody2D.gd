extends CharacterBody2D

@onready var animator = $AnimatedSprite2D
@onready var particle = $Music_Particles
@onready var record_timer: Timer = $Timer

@export var speed: float = 300

var last_direction: Vector2   = Vector2.ZERO
var current_animation: String = "face"

var box_key: String = "ui_box"
var rewind_key: String = "ui_rewind"

var updated: bool = false

var is_playing = false
var counter = 0

func _enter_tree():
	if not updated:
		update_pos()

func _ready():
	update_animation(last_direction)
	GameManager.start_play_box.connect(_on_start_play_box)
	GameManager.stop_play_box.connect(_on_stop_play_box)
	
	RewindManager.current_record.connect(_on_current_record) # each tick, ask the RewindManager to record the current position
	
	record_timer.one_shot = true
	record_timer.timeout.connect(_on_RecordTimer_timeout)

func _process(delta):
	if is_playing:
		counter+=delta

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
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
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(box_key):
		GameManager._set_is_play_box(true)
	elif event.is_action_released(box_key):
		GameManager._set_is_play_box(false)
		
	if event.is_action_pressed(rewind_key):
		GameManager._set_is_rewind_box(true)
	elif event.is_action_released(rewind_key):
		GameManager._set_is_rewind_box(false)	

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
		
func _on_start_play_box():
	particle.emitting = true
	record_timer.start()
	is_playing = true
	if counter > 134:
		counter = 0
	AudioController.play_music(1, true, counter)
	
func _on_stop_play_box():
	particle.emitting = false	
	if(not record_timer.is_stopped()):
		record_timer.stop()
	is_playing = false
	AudioController.stop_music(true, true)
	
func _on_current_record():
	RewindManager._append_position(get_global_position())	
	
func _on_RecordTimer_timeout():
	RewindManager._set_is_recording(false)
