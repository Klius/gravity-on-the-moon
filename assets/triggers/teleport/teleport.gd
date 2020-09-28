extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal teleport_car
signal update_camera
export (Vector3) var tp_point = Vector3(0,0,0)
# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_teleport_body_entered(body):
	if (body.get_name() == "Car"):
		print(String($"teleport-point".global_transform))
		emit_signal("teleport_car",$"teleport-point".global_transform)
		emit_signal("update_camera")
