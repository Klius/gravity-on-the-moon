extends TextureProgress

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_speedometer(kph,max_kph):
	kph = round(kph)
	if(kph < 10):
		$l_speed.text = "00"+ String (kph)	
	elif (kph < 100):
		$l_speed.text = "0"+ String (kph)
	else:
		$l_speed.text = String (kph)
	$".".value = float(kph)/max_kph
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
