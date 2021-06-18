extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var Global
var player_vars
var NEXT_LEVEL = "res://assets/level/windows-test/2ronda.tscn"
var ENVIRONMENT = "res://default_env.tres"
var start_game = false

signal loading_progress

func _ready():
	player_vars = get_node("/root/PlayerVariables")
	Global = get_node("/root/Global")
	$GuiMain/demo_message.visible = player_vars.demo_complete
	var env = get_node("/root/WorldEnvironment")
	if env != null:
		env.set_environment(load(ENVIRONMENT))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.queue.is_ready(NEXT_LEVEL) && start_game:
		Global.set_new_scene(Global.queue.get_resource(NEXT_LEVEL))	
	elif !Global.queue.is_ready(NEXT_LEVEL) && start_game:
		#check on progress
		print(Global.queue.get_progress(NEXT_LEVEL))
		$GuiMain.set_progress(Global.queue.get_progress(NEXT_LEVEL))
		



func _on_guimain_start_new_game(normal_mode):
	start_game = true
	player_vars.normal_mode = normal_mode
	Global.load_new_scene(NEXT_LEVEL)
	#print(get_tree().change_scene(NEXT_LEVEL))#"res://assets/level/demo1/demo1.tscn"))


func _on_guimain_close_game():
	get_tree().quit()
