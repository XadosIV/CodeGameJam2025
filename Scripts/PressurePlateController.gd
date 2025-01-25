extends Node

signal _on_all_plate_push

@export var pressurePlate: Array[PressurePlateStaticBody2D] = []
@export var pressurePlateActive: Array = []

@export var objectsToDisable: Array[StaticBody2D] = []

@export var enigmeName: String

func _ready() -> void:
	if(GameManager.plateEnigme.has(enigmeName)):
		_on_all_plate_push_emitted()
		return
		
		
	_on_all_plate_push.connect(_on_all_plate_push_emitted)
	for i in range(pressurePlate.size()):
		pressurePlateActive.append(false)
		var plate = pressurePlate[i]
		plate.on_plate_push.connect(func () -> void:
			_on_plate_push(i)
		)
		plate.on_plate_release.connect(func () -> void: 
			_on_plate_release(i)
		)
		
func _on_plate_push(index: int) -> void:
	pressurePlateActive[index] = true
	if all_plate_pushed():
		GameManager.plateEnigme[enigmeName] = true
		_on_all_plate_push.emit()
		
func _on_plate_release(index: int) -> void:
	pressurePlateActive[index] = false		
	
func all_plate_pushed() -> bool:
	for i in range(pressurePlateActive.size()):
		if not pressurePlateActive[i]:
			return false
	return true

func _on_all_plate_push_emitted() -> void:
	for object in objectsToDisable:
		object.collision_layer = 0
		object.visible = false
	
