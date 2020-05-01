extends Spatial
###############################
#Loading stuff

export var NEXT_LEVEL = "res://assets/level/main-menu/main-menu.tscn"
##############################
## Player stuff
var on_air_points = 0
var cur_rot = Vector3(0,0,0)
var old_rot = Vector3(0,0,0)
var rot_so_far = Vector3(0,0,0)
var score_to_add = 0
var flips = 0
var player_vars
var Global

# Called when the node enters the scene tree for the first time.
func _ready():
	player_vars = get_node("/root/PlayerVariables")
	player_vars.current_checkpoint = null
	Global = get_node("/root/Global")
	#$AnimationPlayer.play("traffic")
func _process(_delta):
	if Global.queue.is_ready(NEXT_LEVEL):
		Global.set_new_level(Global.queue.get_resource(NEXT_LEVEL),$Car.get_linear_velocity(), $Car.get_angular_velocity())	
		
		
func _physics_process(_delta):
	#$Car.rotate_x(1.0*_delta)
	#$Car.rotate_z(1.0*_delta)
	pass
	

func _on_Area_body_entered(body):
	pass
	if (body.get_name() == "Car"):
		$AudioStreamPlayer.play()
		


func _on_Area_body_exited(body):
	if (body.get_name() == "Car"):
		$AudioStreamPlayer.set_bus("Audio")

func _on_load_body_entered(body):
	if (body.get_name() == "Car"):
		$load.queue_free()
		Global.load_new_scene(NEXT_LEVEL)
		#get_tree().change_scene(NEXT_LEVEL)




func _on_MusicStart_body_entered(body):
	if (body.get_name() == "Car"):
		#$MusicStart.act
		$AudioStreamPlayer.play()





func _on_checkpoint_assign_checkpoint(checkpoint):
	player_vars.current_checkpoint = checkpoint 


