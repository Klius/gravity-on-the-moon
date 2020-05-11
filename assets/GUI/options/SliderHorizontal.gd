extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (String) var suffix = ""
export (String) var title = ""
signal changed
# Called when the node enters the scene tree for the first time.
func _ready():
	_on_slider_value_changed($slider.value)
	$title.text = title
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_slider_value_changed(value):
	$Label.text = String(value)+ " " + suffix # Replace with function body.
	emit_signal("changed",value)
