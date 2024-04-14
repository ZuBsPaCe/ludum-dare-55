extends Sprite2D

@export var image: Texture2D

func _ready():
	get_node("Image").texture = image
