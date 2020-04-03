extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var Global
var NEXT_LEVEL = "res://assets/level/windows-test/2ronda.tscn"
var start_game = false
func _ready():
	Global = get_node("/root/Global")
	Global.load_new_scene(NEXT_LEVEL)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.queue.is_ready(NEXT_LEVEL) && start_game:
		Global.set_new_scene(Global.queue.get_resource(NEXT_LEVEL))	



func _on_guimain_start_new_game():
	start_game = true
	#print(get_tree().change_scene("res://assets/level/windows/windows.tscn"))#"res://assets/level/demo1/demo1.tscn"))


func _on_guimain_close_game():
	get_tree().quit()
