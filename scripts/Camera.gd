extends Camera

export (NodePath) var follow_this_path = null
export var target_distance = 6.0
export var target_height = 2.0

export var joy_camera = JOY_ANALOG_RX
var cam_rot = 0.0
var max_rot = 1
var get_back = false;
var cam_mult = 0.2
var follow_this = null
var last_lookat

func _ready():
	follow_this = get_node(follow_this_path)
	last_lookat = follow_this.global_transform.origin

func update_camera(delta):
	var delta_v = global_transform.origin - follow_this.global_transform.origin
	var target_pos = global_transform.origin
	var up = Vector3(0.0, 1.0, 0.0)
	# ignore y
	delta_v.y = 0.0
	if (delta_v.length() > target_distance):
		delta_v = delta_v.normalized() * target_distance
		delta_v.y = target_height
		target_pos = follow_this.global_transform.origin + delta_v
	else:
		target_pos.y = follow_this.global_transform.origin.y + target_height
		target_pos.z = follow_this.global_transform.origin.z + delta_v.z
		
	global_transform.origin = global_transform.origin.linear_interpolate(target_pos, delta * 20.0)
	
	last_lookat = last_lookat.linear_interpolate(follow_this.global_transform.origin, delta * 20.0)
	look_at(last_lookat, up)

func _physics_process(delta):
	var delta_v = global_transform.origin - follow_this.global_transform.origin
	var target_pos = global_transform.origin
	var cam_joy = Input.get_joy_axis(0, joy_camera)
	if (cam_joy < 0.2 and cam_joy > -0.2 ):
		cam_joy = 0.0
		cam_rot = 0.0
		get_back = true
	else:
		get_back = false
	
	
		
	var up = Vector3(0.0, 1.0, 0.0)
	# ignore y
	delta_v.y = 0.0
	if (delta_v.length() > target_distance):
		delta_v = delta_v.normalized() * target_distance
		delta_v.y = target_height
		target_pos = follow_this.global_transform.origin + delta_v
	else:
		target_pos.y = follow_this.global_transform.origin.y + target_height
		target_pos.z = follow_this.global_transform.origin.z + delta_v.z
		
	global_transform.origin = global_transform.origin.linear_interpolate(target_pos, delta * 20.0)
	
	last_lookat = last_lookat.linear_interpolate(follow_this.global_transform.origin, delta * 20.0)
	look_at(last_lookat, up)
	
	if(not get_back):
		var cam_delta = cam_mult *cam_joy
		cam_rot += cam_delta
		if (cam_rot > max_rot):
			cam_rot = max_rot
		elif(cam_rot < -max_rot):
			cam_rot = -max_rot
		if (delta_v.x < 0):
			cam_rot *= -1
		global_translate(Vector3(0, 0, cam_rot))
		#rotate_object_local(Vector3(0.0, 1, 0), cam_rot)


func _on_teleport_update_camera():
	pass

func reset_camera(pos):
	global_transform.origin = pos.origin
	global_transform.origin = global_transform.origin.linear_interpolate(Vector3(-target_distance,0,0),20*0.1)
	self.update_camera(0.05)

func _on_Car_update_camera(pos):
	self.reset_camera(pos)
