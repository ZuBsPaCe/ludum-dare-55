extends Area2D

@export var music_type: Enums.MusicType

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Music.queue(music_type)


func _on_body_exited(body):
	if body.is_in_group("Player"):
		Music.unqueue(music_type)
