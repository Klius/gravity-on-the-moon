extends VehicleBody
############################################################
# Signals

signal update_kph
signal on_air
signal on_air_over
signal update_camera
############################################################
# score control
var cont_on_air = false
############################################################
# Behaviour values

export var MAX_ENGINE_FORCE = 180.0
export var MAX_BRAKE_FORCE = 5.0
export var MAX_STEER_ANGLE = 0.35
export var LIGHTS = true
export var steer_speed = 1.0
export var air_friction= 1.0
export var MAX_KPH = 180.0
var steer_target = 0.0
var steer_angle = 0.0
var handbrake = 0.0
#############################################
# Roll over logic

var time_to_next_roll = 4
var is_touching_floor = false

var spawn_pos = null
############################################################
# Speed and drive direction

var current_speed_mps = 0.0
var had_throttle_or_brake_input = false
var is_reverse = false
var last_pos = Vector3(0.0, 0.0, 0.0)


func get_speed_kph():
	var kph = current_speed_mps * 3600.0 / 1000.0
	emit_signal("update_kph", kph, MAX_KPH)
	return kph

func set_speed(linear, angular):
	set_linear_velocity(linear)
	set_angular_velocity(angular)
	
func respawn(spawn,conserveSpeed=false):
	print("Spawning at cordinates:"+String(spawn))
	if (!conserveSpeed):
		set_linear_velocity ( Vector3 (0,0,0) )
		set_angular_velocity ( Vector3 (0,0,0) )
	#set_sleeping(true)
	global_transform = spawn
	emit_signal("update_camera",spawn)
	set_sleeping(false)
############################################################
# Input

export var joy_steering = JOY_ANALOG_LX
export var steering_mult = -1.0
export var joy_throttle = JOY_ANALOG_R2
export var throttle_mult = 1.0
export var joy_brake = JOY_ANALOG_L2
export var brake_mult = 1.0

#func roll_over():
#	set_visible(false)
#	set_axis_velocity( Vector3(0, 6, 0))
#	yield(get_tree().create_timer(1.0), "timeout")
#	set_sleeping(true)
#	rotate_x(PI)#rotate_x(deg2rad(180))
#	transform.orthonormalized()
#	set_sleeping(false)
#	set_visible(true)
#	time_to_next_roll = 4
		
func _ready():
	# Called every time the node is added to the scene.
	spawn_pos = global_transform
	lights()
	connect("body_entered",self,"collision_now")
	connect("body_exited",self,"collision_now")
	pass
func collision_over(who):
	print(self.get_name()," is NOT colliding with ",who.get_name())
	is_touching_floor = false

func collision_now(who):
	print(self.get_name()," is colliding with ",who.get_name())
	is_touching_floor = (who.get_name() == "Floor")
	if (is_touching_floor):
		cont_on_air = false
		emit_signal("on_air_over")
		
func brake_lights(on):
		$light_brake_left.visible = on
		$light_brake_right.visible = on
		if (LIGHTS) :
			$lights/light_position_left.visible = !on
			$lights/light_position_right.visible = !on
		
func lights():
	$lights.visible = LIGHTS

func engine_sfx(_throttle):
	var pitch = get_speed_kph()/MAX_KPH
	if (pitch > 1.2):
		pitch = 1.2
	$sfx_engine.pitch_scale = 0.8+pitch
		
func _physics_process(delta):
	time_to_next_roll -= delta
	# how fast are we going in meters per second?
	current_speed_mps = (translation - last_pos).length() / delta
	#print (current_speed_mps)
	# get our joystick inputs
	var steer_val = steering_mult * Input.get_joy_axis(0, joy_steering)
	var throttle_val = throttle_mult * Input.get_joy_axis(0, joy_throttle)
	var brake_val = brake_mult * Input.get_joy_axis(0, joy_brake)

	if (throttle_val < 0.0):
		throttle_val = 0.0
	
	if (brake_val < 0.0):
		brake_val = 0.0
	
	if(!$front_right.is_in_contact()&& !$front_left.is_in_contact() &&
		!$rear_left.is_in_contact() && !$rear_right.is_in_contact() ):
			emit_signal("on_air")
			cont_on_air = true
	else:
		cont_on_air = false
		emit_signal("on_air_over")
#	#Shim for automatic respawning
#	if(!$front_right.is_in_contact() && !$front_left.is_in_contact() &&
#		!$rear_left.is_in_contact() && !$rear_right.is_in_contact()
#		&& current_speed_mps < 0.05 && time_to_next_roll < 0 && is_touching_floor ):
#		time_to_next_roll = 4
#		respawn(spawn_pos)#roll_over()
	
	# overrules for keyboard
	if Input.is_action_just_pressed("ui_reset") :
		respawn(spawn_pos)
	if Input.is_action_pressed("car_accelerate"):
		throttle_val = 1.0
	if Input.is_action_pressed("car_brake"):
		brake_val = 1.0

	if Input.is_action_pressed("ui_accept"):
		handbrake = 2.0 
	else:
		handbrake = 0.0
	if Input.is_action_pressed("ui_left"):
		steer_val = 1.0
	elif Input.is_action_pressed("ui_right"):
		steer_val = -1.0
	
	#############################################
	## Handbrake
	if (handbrake > 0.0):
		$rear_left.wheel_friction_slip = 7.0
		$rear_right.wheel_friction_slip = 7.0
	else:
		$rear_left.wheel_friction_slip = 10.5
		$rear_right.wheel_friction_slip = 10.5
	
	
	
	# check if we need to be in reverse to have to press reverse put this: had_throttle_or_brake_input == false and 
	if (brake_val > 0.0  and current_speed_mps < 1.0):
		had_throttle_or_brake_input = true
		is_reverse = true
	elif (throttle_val > 0.0 and is_reverse and current_speed_mps < 1.0):
		is_reverse = false
		had_throttle_or_brake_input = true
	

#brake lights, brake lights is my life
	if (brake_val > 0.0):
		brake_lights(true)
	else:
		brake_lights(false)
	
	# are we in reverse?
	if (is_reverse):
		var swap = throttle_val
		throttle_val = -brake_val
		brake_val = swap
	elif (throttle_val == 0.0 and brake_val == 0.0 and current_speed_mps < 3.0):
		# if no throttle input, brake lightly
		brake_val = 0.1
	
	if (get_speed_kph() < MAX_KPH):
		engine_force = throttle_val * MAX_ENGINE_FORCE 
		#engine_force = MAX_ENGINE_FORCE
	else:
		engine_force = 0	
	brake = brake_val * MAX_BRAKE_FORCE + air_friction + handbrake
	steer_target = steer_val * MAX_STEER_ANGLE
	if (steer_target < steer_angle):
		steer_angle -= steer_speed * delta
		if (steer_target > steer_angle):
			steer_angle = steer_target
	elif (steer_target > steer_angle):
		steer_angle += steer_speed * delta
		if (steer_target < steer_angle):
			steer_angle = steer_target
	
	steering = steer_angle
	engine_sfx(throttle_val)
	# remember where we are
	last_pos = translation


func _on_teleport_teleport_car(pos):
	self.respawn(pos,true)
