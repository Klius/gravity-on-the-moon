extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal assign_checkpoint
var timeout = 5
var assigned = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if assigned:
		timeout -= delta
		if timeout < 0:
			$".".queue_free()

func _on_trigger_body_entered(body):
		if (body.get_name() == "Car"):
			emit_signal("assign_checkpoint",$trigger/checkpoint.global_transform)
			assigned = true
