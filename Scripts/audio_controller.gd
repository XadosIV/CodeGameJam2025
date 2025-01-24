extends Node2D

var sounds: Array[String] = []
var sounds_loaded: Array[AudioStream] = []
var musics: Array[String] = []
var musics_loaded: Array[AudioStream] = []

var global_volume: float = 1.0  # Volume global, 1.0 = 100%, 0.5 = 50%, etc.

var fading_music: bool
var fading_sound: bool

func _ready() -> void:		
	search_all_files("res://Audio")
	print("Musics: ", musics)
	print("Sounds: ", sounds)
	
	load_all_audios()

func play_music(index: int):
	if index >= 0 and index < musics_loaded.size():
		$Music.stream = musics_loaded[index]
		$Music.play()

func play_sound(index: int):
	if index >= 0 and index < sounds_loaded.size():
		$Sound.stream = sounds_loaded[index]
		$Sound.play()
		
func set_music_volume(volume: int):
	$Music.set_volume_db(volume * global_volume)

func set_sound_volume(volume: int):
	$Sound.set_volume_db(volume * global_volume)

func set_music_volume_percentage(percentage: float):
	# Définit le volume de la musique en pourcentage (0.0 - 1.0)
	percentage = clamp(percentage, 0.0, 1.0)
	var db = percentage_to_db(percentage)
	set_music_volume(db)

func set_sound_volume_percentage(percentage: float):
	# Définit le volume du son en pourcentage (0.0 - 1.0)
	percentage = clamp(percentage, 0.0, 1.0)
	var db = percentage_to_db(percentage)
	set_sound_volume(db)

func get_music_volume() -> float:
	# Retourne le volume de la musique en pourcentage (0.0 - 1.0)
	var db = $Music.get_volume_db()
	return db_to_percentage(db)

func get_sound_volume() -> float:
	# Retourne le volume du son en pourcentage (0.0 - 1.0)
	var db = $Sound.get_volume_db()
	return db_to_percentage(db)

func db_to_percentage(db: float) -> float:
	# Convertit un volume en décibels (dB) en une valeur entre 0.0 et 1.0
	if db <= -80.0:
		return 0.0
	return pow(10, db / 20)

func percentage_to_db(percentage: float) -> float:
	# Convertit une valeur entre 0.0 et 1.0 en décibels (dB)
	if percentage <= 0.0:
		return -80.0  # Volume minimal
	return 20 * (log(percentage) / log(10))

func fade_music():
	fading_music = true
		
func music_mixer(volume:int):
	$Music.set_volume_db(volume)
	
func sound_mixer(volume:int):
	$Sound.set_volume_db(volume)
	
func pause_sound():
	$Sound.set_stream_paused(!$Sound.get_stream_paused())

func pause_music():
	$Music.set_stream_paused(!$Music.get_stream_paused())

func play_music2D():
	$Music2D.play()

func play_sound2D():
	$Sound2D.play()

func set_global_volume(value: float):
	global_volume = clamp(value, 0.0, 1.0)  # Le volume global doit être entre 0 et 1
	set_music_volume($Music.get_volume_db())
	set_sound_volume($Sound.get_volume_db())

func search_all_files(base_path: String):
	var dir = DirAccess.open(base_path)
	if !dir:
		print("Path not found")
		return
	
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		
		if file_name == "":
			break
			
		if file_name == "." or file_name == "..":
			continue
		
		if dir.current_is_dir():
			search_all_files(base_path + "/" + file_name)
		else:
			if file_name.ends_with(".wav"):
				musics.append(base_path + "/" + file_name)
			elif file_name.ends_with(".mp3"):
				sounds.append(base_path + "/" + file_name)
	dir.list_dir_end()

func load_all_audios():
	for music in musics:
		musics_loaded.append(load(music))
	for sound in sounds:
		sounds_loaded.append(load(sound))
		
func _process(delta: float) -> void:
	if fading_music:
		$Music.volume_db -= 15*delta
		
		if $Music.volume_db <= 0:
			$Music.stop()
			$Music.set_volume_db(0)
			fading_music = false
