extends Control


onready var progress_bar = $"VBoxContainer/MarginContainer/ProgressBar"
onready var car_sprite = $"VBoxContainer/MarginContainer/CarSprite"
var offset = 32

func _ready():
	car_sprite.set_position(Vector2(-offset,0))


func set_progress(_progress : float):
	var progress = _progress*100
	progress_bar.set_value(progress)
	var pos = Vector2((progress_bar.get_size().x*progress/progress_bar.get_max())-offset, 0)
	car_sprite.set_position(pos)

