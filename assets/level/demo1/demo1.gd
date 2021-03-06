extends Spatial
###############################
#Loading stuff

export var NEXT_LEVEL = "res://assets/level/main-menu/main-menu.tscn"
export var ENVIRONMENT = "res://assets/environments/phoenix.tres"
export var forward = Vector3 ()
export var end_demo = false
##############################
## Player stuff
var on_air_points = 0
var cur_rot = Vector3(0,0,0)
var old_rot = Vector3(0,0,0)
var rot_so_far = Vector3(0,0,0)
var score_to_add = 0
var load_next_level = false
var flips = 0
var player_vars
var Global

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_tree().paused = false
	player_vars = get_node("/root/PlayerVariables")
	player_vars.current_checkpoint = null
	Global = get_node("/root/Global")
	Global.audio_init_volume(player_vars.settings)
	Global.display_init(player_vars.settings)
	#Set worldEnvironment
	var env = get_node("/root/WorldEnvironment")
	if env == null:
		env = WorldEnvironment.new()
		env.set_environment(load(ENVIRONMENT))
		get_tree().get_root().call_deferred("add_child",env,true)#add_child(env,true)
	else:
		env.set_environment(load(ENVIRONMENT))
	#set audio
	if !player_vars.normal_mode:
		var strm = $Music.stream as AudioStreamOGGVorbis
		strm.set_loop(true)
	#$AnimationPlayer.play("traffic")
func _process(_delta):
	if load_next_level:
		$Music.volume_db -= _delta*10
	if Global.queue.is_ready(NEXT_LEVEL) and load_next_level:
		Global.set_new_level(Global.queue.get_resource(NEXT_LEVEL),$Car.get_linear_velocity(), $Car.get_angular_velocity())	
		
#func _physics_process(_delta):
#	#$Car.rotate_x(1.0*_delta)
#	#$Car.rotate_z(1.0*_delta)
#	pass
	

func _on_Area_body_entered(body):
	pass
	if (body.get_name() == "Car"):
		$Music.play()
		


func _on_Area_body_exited(body):
	if (body.get_name() == "Car"):
		$Music.set_bus("Audio")

func _on_load_body_entered(body):
	if (body.get_name() == "Car"):
		Global.load_new_scene(NEXT_LEVEL)
		load_next_level = true
		$HUD._on_level_finish()
		player_vars.demo_complete = end_demo
		
		#get_tree().change_scene(NEXT_LEVEL)




func _on_MusicStart_body_entered(body):
	if (body.get_name() == "Car") and !$Music.playing:
		#$MusicStart.act
		$Music.play()





func _on_checkpoint_assign_checkpoint(checkpoint):
	player_vars.current_checkpoint = checkpoint 




func _on_Pause_enter_camera_mode():
	#$Pause/Camera.global_transform = $Camera.global_transform
	$Pause/Camera.rotateIt($Camera,$Car.global_transform.origin)
	#$Pause/Camera.global_transform.looking_at($Car.global_transform.origin,Vector3(0,1,0))


func _on_Pause_exit_camera_mode():
	pass # Replace with function body.


func _on_Music_finished():
	if player_vars.normal_mode and !load_next_level:
		$game_over.visible = true
		$Pause.disabled = true
