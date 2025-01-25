extends Node2D

@export var audio_folder: String = "res://Audio"
var global_volume: float = 1.0  # Volume global (0.0 - 1.0)

# Internes
var _sounds: Array[AudioStream] = []
var _musics: Array[AudioStream] = []
var _current_music: int = -1
var _is_fading_out: bool = false

func _ready() -> void:
	_load_audio_files(audio_folder)
	print("Loaded musics: ", _musics.size())
	print("Loaded sounds: ", _sounds.size())

# --- Gestion des volumes ---
func get_global_volume_percentage() -> float:
	return global_volume

func set_global_volume_percentage(value: float) -> void:
	global_volume = clamp(value, 0.0, 1.0)
	_update_volume()

func get_music_volume_percentage() -> float:
	var db = $Music.volume_db
	return db_to_percentage(db)

func set_music_volume_percentage(percentage: float) -> void:
	percentage = clamp(percentage, 0.0, 1.0)
	$Music.volume_db = percentage_to_db(percentage)

func get_sound_volume_percentage() -> float:
	var db = $Sound.volume_db
	return db_to_percentage(db)

func set_sound_volume_percentage(percentage: float) -> void:
	percentage = clamp(percentage, 0.0, 1.0)
	$Sound.volume_db = percentage_to_db(percentage)

# --- Contrôle des musiques ---

func play_music(index: int, fade_in: bool = false, time:float=0.0) -> void:
	if index < 0 or index >= _musics.size():
		print("Invalid music index.")
		return
	_current_music = index
	$Music.stream = _musics[index]
	$Music.volume_db = percentage_to_db(global_volume)
	if fade_in:
		$Music.volume_db = -80  # Commencer à un volume bas
		$Music.play(time)
		_fade_in_music()
	else:
		$Music.play(time)

func stop_music(fade_out: bool = false, save: bool = false) -> void:
	if fade_out:
		_fade_out_music()
	else:
		$Music.stop()

# --- Contrôle des sons ---

func play_sound(index: int) -> void:
	if index < 0 or index >= _sounds.size():
		print("Invalid sound index.")
		return
	$Sound.stream = _sounds[index]
	$Sound.volume_db = percentage_to_db(global_volume)
	$Sound.play()

func stop_sound():
	$Sound.stop()

# --- Gestion des transitions (fade) ---

func _fade_in_music(duration: float = 1.0) -> void:
	var target_volume: float = percentage_to_db(global_volume)
	$Music.volume_db = -80
	await _animate_volume($Music, -80, target_volume, duration)

func _fade_out_music(duration: float = 1.0) -> void:
	_is_fading_out = true
	var start_volume: float = $Music.volume_db
	await _animate_volume($Music, start_volume, -80, duration)
	$Music.stop()
	_is_fading_out = false

func _animate_volume(player: AudioStreamPlayer, start_db: float, end_db: float, duration: float) -> void:
	var timer = Timer.new()
	timer.wait_time = 0.016  # Approximativement 60 FPS (16ms par frame)
	timer.one_shot = false
	add_child(timer)
	timer.start()

	var elapsed_time: float = 0.0
	while elapsed_time < duration and not _is_fading_out:
		await timer.timeout  # Utilisation d'await avec timeout
		elapsed_time += timer.wait_time
		var t: float = elapsed_time / duration
		player.volume_db = lerp(start_db, end_db, t)

	timer.stop()
	timer.queue_free()

# --- Utilitaires de volume ---

func db_to_percentage(db: float) -> float:
	if db <= -80.0:
		return 0.0
	return pow(10, db / 20)

func percentage_to_db(percentage: float) -> float:
	if percentage <= 0.0:
		return -80.0  # Volume minimal
	return 20 * log(percentage) / log(10)

func _update_volume() -> void:
	$Music.volume_db = percentage_to_db(global_volume)
	$Sound.volume_db = percentage_to_db(global_volume)

# --- Chargement des fichiers audios ---

func _load_audio_files(base_path: String) -> void:
	var music_path: String = base_path + "/Musics"
	var sound_path: String = base_path + "/Sounds"

	_load_audio_from_directory(music_path, _musics)
	_load_audio_from_directory(sound_path, _sounds)

func _load_audio_from_directory(directory_path: String, target_array: Array[AudioStream]) -> void:
	var dir: DirAccess = DirAccess.open(directory_path)
	if !dir:
		return

	dir.list_dir_begin()
	while true:
		var file_name: String = dir.get_next()
		if file_name == "":
			break
		if file_name == "." or file_name == "..":
			continue
		var file_path: String = directory_path + "/" + file_name
		if not dir.current_is_dir():
			if file_name.ends_with(".mp3") or file_name.ends_with(".wav"):
				var stream: AudioStream = load(file_path) as AudioStream
				if stream:
					target_array.append(stream)
	dir.list_dir_end()
