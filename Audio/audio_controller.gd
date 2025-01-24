extends Node2D

var sounds: Array[String]
var sounds_loaded: Array[AudioStream]
var musics: Array[String]
var musics_loaded: Array[AudioStream]

func _ready() -> void:		
	search_all_files("res://Audio")
	print("Musics: ", musics)
	print("Sounds: ", sounds)
	
	load_all_audios()
	
	music_mixer(15)
	play_music(6)
	sound_mixer(-15)
	play_sound(0)

func play_music(index:int):
	if index >= 0 and index < musics_loaded.size():
		$Music.stream = musics_loaded[index]
		$Music.play()
	
func play_sound(index:int):
	if index >= 0 and index < sounds_loaded.size():
		$Sound.stream = sounds_loaded[index]
		$Sound.play()
		
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
