extends Node

signal start_record
signal stop_record

signal start_rewind
signal stop_rewind

signal current_rewind(position)
signal current_record()

var is_recording: bool = false : set=_set_is_recording
var is_rewinding: bool = false : set=_set_is_rewinding

var recording_player_inputs: Array = []

func _ready() -> void:
	GameManager.start_play_box.connect(func () -> void:
		_set_is_recording(true))
	GameManager.stop_play_box.connect(func () -> void:
		_set_is_recording(false))
	
	GameManager.start_rewind_box.connect(func () -> void:
		_set_is_rewinding(true))
	GameManager.stop_rewind_box.connect(func () -> void:
		_set_is_rewinding(false))
	
func _process(delta: float) -> void:
	if is_recording:
		current_record.emit()
	elif is_rewinding:
		if recording_player_inputs.size() > 0:
			current_rewind.emit(recording_player_inputs.pop_back())
		else:
			_set_is_rewinding(false)	
			
func _set_is_recording(value: bool) -> void:
	if value and not is_recording and not is_rewinding:
		_clear_record()
		start_record.emit()
		is_recording = value
	elif is_recording:
		stop_record.emit()
		is_recording = value
		recording_player_inputs.reverse()
	
func _set_is_rewinding(value: bool) -> void:
	if value and recording_player_inputs.size() > 0 and not is_rewinding and not is_recording:
		start_rewind.emit()
		is_rewinding = value
	elif is_rewinding:
		stop_rewind.emit()
		is_rewinding = value
		
func _append_position(position: Vector2) -> void:
	recording_player_inputs.append(position)
	
func _clear_record() -> void:
	recording_player_inputs.clear()		
