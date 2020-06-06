extends Area

export var activate = true
export var underwater = false
var bus = AudioServer.get_bus_index("Master")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_tunnelAudio_body_entered(body):
	if body.get_name() == "Car":
		if activate:
			AudioServer.set_bus_effect_enabled(bus,2,true)
			if underwater:
				AudioServer.set_bus_effect_enabled(bus,1,true)
		else:
			AudioServer.set_bus_effect_enabled(bus,2,false)

func _on_tunnelAudio_body_exited(body):
	if body.get_name() == "Car":
		if activate:
			AudioServer.set_bus_effect_enabled(bus,2,false)
			if underwater:
				AudioServer.set_bus_effect_enabled(bus,1,false)
