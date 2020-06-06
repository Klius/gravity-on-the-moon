extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var timeToFade = 3
var ttf = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	percent_visible = 0
	

func _process(delta):
	ttf -=delta
	
	if ttf<0 and percent_visible > 0:
		fadeText(delta)	
	

func updateText(text):
	bbcode_text = "[b][wave amp=50 freq=3][center]"+text+"[/center][/wave][/b]"
	ttf = timeToFade
	percent_visible = 1

func fadeText(delta):
	percent_visible -=delta
	if percent_visible < 0.1:
		percent_visible = 0
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
