extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var cam_out
export(NodePath) var level
var reenable = false
var delay_pause = 0.2
var pause = false
# Called when the node enters the scene tree for the first time.
func _ready():
	cam_out = get_node(cam_out)
	level = get_node(level)
	pass # Replace with function body.

func _process(delta):
	delay_pause -= delta
	if Input.is_action_pressed("pause") and delay_pause < 0:
		back_to_game()

#(Un)pauses a single node
func set_pause_node(node : Node, pause : bool) -> void:
	node.set_process(!pause)
	node.set_process_input(!pause)
	node.set_process_internal(!pause)
	node.set_physics_process(!pause)
	node.set_physics_process_internal(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)

#(Un)pauses a scene
#Ignored childs is an optional argument, that contains the path of nodes whose state must not be altered by the function
func set_pause_scene(rootNode : Node, pause : bool, ignoredChilds : PoolStringArray = [null]):
	set_pause_node(rootNode, pause)
	for node in rootNode.get_children():
		if not (String(node.get_path()) in ignoredChilds):
			set_pause_scene(node, pause, ignoredChilds)

func back_to_game():
	delay_pause = 0.2
	pause = !pause
	$".".visible = pause
	if pause:
		set_pause_scene(level,pause,["fxdashboard"])
		level.get_node("HUD").visible = false
		$cam_inside.current = true
		cam_out.current = false
	else:
		set_pause_scene(level,pause,["fxdashboard"])
		level.get_node("HUD").visible = true
		$cam_inside.current = false
		cam_out.current = true
		 #Grab focus onto something

func _on_3DSettings_back_from_settings():
	$AnimationPlayer.play_backwards("main_to_settings")
	reenable = true


func _on_ov_settings_mouse_entered():
	$ov_settings/mesh.visible = true


func _on_ov_settings_mouse_exited():
	$ov_settings/mesh.visible = false


func _on_ov_settings_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		$AnimationPlayer.play("main_to_settings")
		$ov_settings.visible = false
		$ov_settings/mesh.visible = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "main_to_settings" and reenable:
		$ov_settings.visible = true
		reenable = false
