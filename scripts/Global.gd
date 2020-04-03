extends Node


var current_scene = null
var queue = preload("res://scripts/resource_queue.gd").new()
var is_loading = false
var currently_loading = ""
func _ready():
	queue.start()
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
			
func load_new_scene(scene):
	queue.queue_resource(scene, true)

func set_new_scene(scene_resource):
	current_scene.queue_free()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)

func set_new_level(scene_resource, linear, angular):
	current_scene.queue_free()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	current_scene.get_node("Car").set_speed(linear,angular)
