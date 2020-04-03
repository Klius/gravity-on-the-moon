extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Label.text = "fps:"+ String(Engine.get_frames_per_second() ) 


func _on_Car_update_kph(kph,max_kph):
	$brcontainer/speedometer.update_speedometer(kph,max_kph)
