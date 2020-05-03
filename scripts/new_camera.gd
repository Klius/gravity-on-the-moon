extends Camera

export (NodePath) var follow_this_path = null
export var target_distance = 6.0
export var target_height = 2.0
var mouseSensitivity = 0.1
var joy_camera = JOY_ANALOG_RX
var yaw = 0.0
var pitch = 0.0
var origin = Vector3()

var follow_this = null
var last_lookat

func _ready():
	follow_this = get_node(follow_this_path)
	last_lookat = follow_this.global_transform.origin

func _physics_process(delta):
	var delta_v = global_transform.origin - follow_this.global_transform.origin
	var target_pos = global_transform.origin
	
	# ignore y
	delta_v.y = 0.0
	
	if (delta_v.length() > target_distance):
		delta_v = delta_v.normalized() * target_distance
		delta_v.y = target_height
		target_pos = follow_this.global_transform.origin + delta_v
	else:
		target_pos.y = follow_this.global_transform.origin.y + target_height
		
	global_transform.origin = global_transform.origin.linear_interpolate(target_pos, delta * 20.0)
	
	last_lookat = last_lookat.linear_interpolate(follow_this.global_transform.origin, delta * 20.0)
	
	look_at(last_lookat, Vector3(0.0, 1.0, 0.0))
	var cam_joy = Vector2(Input.get_joy_axis(0, joy_camera),0.0)
	if (cam_joy.x < 0.2 and cam_joy.x > -0.2 ):
		cam_joy.x = 0.0
		yaw = get_rotation_degrees().y
		pitch = 0.0
	else:
		yaw = fmod(yaw -cam_joy.x,360)
		pitch = max(min(pitch -cam_joy.y,90.0),-90.0)
		self.set_rotation(Vector3(deg2rad(pitch),deg2rad(yaw),0.0))
		var newpos = last_lookat-8.0 * self.project_ray_normal(get_viewport().get_visible_rect().size*0.5)
		newpos.y = global_transform.origin.y
		self.set_translation(global_transform.origin.linear_interpolate(newpos,delta*50.0)) 
#func _input(event):
#	if event is InputEventMouseMotion:
#		var mouseVec = event.get_relative()
#		yaw = fmod(yaw -mouseVec.x*mouseSensitivity,360.0)
#		pitch = max(min(pitch -mouseVec.y*mouseSensitivity,90.0),-90.0)
#		self.set_rotation(Vector3(deg2rad(pitch),deg2rad(yaw),0.0))
#		self.set_translation(global_transform.origin-3.0 * self.project_ray_normal(get_viewport().get_visible_rect().size*0.5)) 
