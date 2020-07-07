extends Area

export (bool) var active = false
export (float) var ttl = 0.3
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if !active:
		return
	else:
		ttl -= delta
		if ttl < 0 :
			$".".queue_free()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.get_name() =="Car":
		body.exploded = true


func _on_servicegas_body_entered(body):
	if body.get_name() =="Car":
		active = true
		$wave.disabled = false
		$wave/CPUParticles.emitting = true
		print("BUM!")
	
