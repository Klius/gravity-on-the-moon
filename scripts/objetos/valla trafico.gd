extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal barrier_broken  

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass
#
#func _process(delta):
#	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.get_name() == "Car":
		emit_signal("barrier_broken")
