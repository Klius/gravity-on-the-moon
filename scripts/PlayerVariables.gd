extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = 0
var current_checkpoint = null
onready var settings = {"a_master":100,
				"a_sfx":100,
				"a_music":100,
				"fov":70,
				"far":1000,
				"window": true,
				"res":0
				}
var resolutions = [Vector2(1024,768),Vector2(1280,720),Vector2(1920,1080)]
# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()

##
# returns a dict with all the stuff to save
func save():
	var save_dict = {
		"settings": settings
	}
	return save_dict
##
#saves the game
func save_game():
	var save_game = File.new()
	save_game.open("user://gravity.save",File.WRITE)
	save_game.store_line(to_json(save()))
	save_game.close()
##
# Loads the game
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://gravity.save"):
		 save_game()# Error! We don't have a save to load->Create one

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in save_nodes:
#		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://gravity.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line:
			settings = current_line["settings"]
		# Firstly, we need to create the object and add it to the tree and set its position.
#		var new_object = load(current_line["filename"]).instance()
#		get_node(current_line["parent"]).add_child(new_object)
#		new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
#		# Now we set the remaining variables.
#		for i in current_line.keys():
#			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#				continue
#			new_object.set(i, current_line[i])
	save_game.close()
