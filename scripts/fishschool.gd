extends MultiMeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range($".".multimesh.instance_count):
		var position = Transform()
		position = position.translated(Vector3(randf() *3-1, randf()*3-2, randf() *4-1))
		$".".multimesh.set_instance_transform(i, position)
		$".".multimesh.set_instance_custom_data(i, Color(randf(), randf(), randf(), randf()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
