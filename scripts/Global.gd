extends Node


var current_scene = null
var copy_scene = null
var queue = preload("res://scripts/resource_queue.gd").new()
var is_loading = false
var currently_loading = ""
var linear_speed = Vector3()
var angular_speed = Vector3()
func _ready():
	queue.start()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass
			
func load_new_scene(scene):
	queue.queue_resource(scene, true)


func set_new_scene(scene_resource):
	if scene_resource != null:
		current_scene.queue_free()
		current_scene = scene_resource.instance()
		copy_scene = scene_resource
		get_node("/root").add_child(current_scene)

func set_new_level(scene_resource, linear, angular):
	copy_scene = scene_resource # seems to fix crash on loading a new level
	current_scene.queue_free()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	#mover al ready del nivel
	linear_speed = linear
	angular_speed = angular

func reload_level():
	current_scene.queue_free()
	current_scene = copy_scene.instance()
	get_node("/root").add_child(current_scene)

func audio_set_volume(value,channel):
	if value == 0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(channel), true)
	else:
		value = -1*((value/100)*-16+16)
		AudioServer.set_bus_mute(AudioServer.get_bus_index(channel), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(channel), value)

func audio_init_volume(settings):
	audio_set_volume(settings["a_master"],"Master")
	audio_set_volume(settings["a_music"],"music")
	audio_set_volume(settings["a_sfx"],"sfx")
	
func camera_set_fov(fov):
	get_viewport().get_camera().fov = fov

func camera_set_far(far):
	get_viewport().get_camera().far = far
	
func display_init(settings):
	camera_set_fov(settings["fov"])
	camera_set_fov(settings["far"])
