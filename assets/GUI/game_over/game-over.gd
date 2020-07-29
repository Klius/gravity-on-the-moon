extends Control

var Global
var MAIN_MENU = "res://assets/level/main-menu/main-menu.tscn"
var restart_delay = 1.0
var restart = false
var exit
var transition_speed = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition.visible = false
	Global = get_node("/root/Global")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if exit:
		$Transition.modulate = Color(0,0,0,$Transition.modulate.a+transition_speed*delta)
		if Global.queue.is_ready(MAIN_MENU):
			Global.set_new_scene(Global.queue.get_resource(MAIN_MENU))
	elif restart and restart_delay < 0:
		restart_level()
	elif restart:
		restart_delay -= delta
		$Transition.modulate = Color(0,0,0,$Transition.modulate.a+transition_speed*delta)


func restart_level():
# warning-ignore:return_value_discarded
	var err =get_tree().reload_current_scene()
	if (err > 0):
		Global.reload_level()


func _on_btn_restart_pressed():
	$Transition.visible = true
	restart = true


func _on_game_over_visibility_changed():
	if self.visible:
		#Pause the game
		self.get_tree().paused = true
		$Panel/MarginContainer/VBoxContainer/HBoxContainer/btn_restart.grab_focus()


func _on_btn_exit_pressed():
	exit = true
	$Transition.visible = true
	Global.load_new_scene(MAIN_MENU)
