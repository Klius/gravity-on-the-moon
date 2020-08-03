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
var handbrakeTime = 0.0
var exploded = false

#############################################
# Roll over logic

var time_to_next_roll = 4
var is_touching_floor = false

var spawn_pos = null
var player_vars
var global 
var just_loaded = true
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
	print("real coordinates"+String(global_transform))
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

##################################################################
# Skids
export var skid = "res://assets/cars/Skid/skid.tscn"


#func roll_over():
#	set_visible(false)
#	set_axis_velocity( Vector3(0, 6, 0))
#	yield(get_tree().create_timer(1.0), "timeout")
#	set_sleeping(true)
#	rotation.x = 0
#	rotation.z = 0#rotate_x(PI)#rotate_x(deg2rad(180))
#	transform.orthonormalized()
#	set_sleeping(false)
#	set_visible(true)
#	time_to_next_roll = 4

# Called when the node enters the scene tree for the first time.
	
func _ready():
	# Called every time the node is added to the scene.
	skid = load(skid)
	global = get_node("/root/Global")
	player_vars = get_node("/root/PlayerVariables")
	spawn_pos = global_transform
	lights()
	connect("body_entered",self,"collision_now")
	connect("body_exited",self,"collision_now")

	
func collision_over(who):
	print(self.get_name()," is NOT colliding with ",who.get_name())
	is_touching_floor = false

func collision_now(who):
	print(self.get_name()," is colliding with ",who.get_name())
	is_touching_floor = (who.get_name() == "Floor")
	var diff = get_speed_kph()/MAX_KPH
	if who.get_class() == "StaticBody":
		Input.start_joy_vibration ( 0, 1*diff , 1*diff, 0.1 )
	elif who.get_class() == "RigidBody":
		if weight > who.weight:
			Input.start_joy_vibration ( 0, 1*diff , 0, 0.1 )
		else:
			Input.start_joy_vibration ( 0, 1*diff , 1*diff, 0.1 )
		
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
#	if pitch > 0.3: 
#		pitch=0.3
#	$sfx_squeal.pitch_scale = 0.5+ pitch
#
func _physics_process(delta):
	if just_loaded:
		just_loaded = false
		set_speed(global.linear_speed,global.angular_speed)
	
	handbrake = 0.0
	time_to_next_roll -= delta
	# how fast are we going in meters per second?
	current_speed_mps = (translation - last_pos).length() / delta
	#print (current_speed_mps)
	# get our joystick inputs
	var joy_steer = Input.get_joy_axis(0, joy_steering)
	#deadzone
	if joy_steer < 0.25 and joy_steer > -0.25:
		joy_steer = 0
	var steer_val = steering_mult * Input.get_joy_axis(0, joy_steering)
	var throttle_val = throttle_mult * Input.get_joy_axis(0, joy_throttle)
	var brake_val = brake_mult * Input.get_joy_axis(0, joy_brake)

	if (throttle_val < 0.0):
		throttle_val = 0.0
	
	if (brake_val < 0.0):
		brake_val = 0.0
	
	if(!$front_right.is_in_contact()&& !$front_left.is_in_contact() &&
		!$rear_left.is_in_contact() && !$rear_right.is_in_contact() ):
			emit_signal("on_air",$".")
			cont_on_air = true
	if($front_right.is_in_contact()&& $front_left.is_in_contact() &&
		$rear_left.is_in_contact() && $rear_right.is_in_contact()  && cont_on_air):
		cont_on_air = false
		emit_signal("on_air_over")
	#Shim for automatic respawning
#	if(!$front_right.is_in_contact() && !$front_left.is_in_contact() &&
#		!$rear_left.is_in_contact() && !$rear_right.is_in_contact()
#		&& current_speed_mps < 0.05 && time_to_next_roll < 0 ):
#		time_to_next_roll = 4
#		roll_over()
	
	# overrules for keyboard
	if Input.is_action_just_pressed("ui_reset") :
		if player_vars.current_checkpoint:
			respawn(player_vars.current_checkpoint)
		else:
			respawn(spawn_pos)
	if Input.is_action_pressed("car_accelerate"):
		throttle_val = 1.0
	if Input.is_action_pressed("car_brake"):
		brake_val = 1.0

	if Input.is_action_pressed("car_handbrake"):
		handbrake = 1.0
		brake_val = 4.0

	if Input.is_action_pressed("car_left"):
		steer_val = 1.0
	elif Input.is_action_pressed("car_right"):
		steer_val = -1.0
	
	#############################################
	## Handbrake
	if (handbrake > 0.0):
		$rear_left.wheel_friction_slip = 0
		$rear_right.wheel_friction_slip = 0
		$front_left.wheel_friction_slip = 3
		$front_right.wheel_friction_slip = 3
	else:
		$front_left.wheel_friction_slip = 3
		$front_right.wheel_friction_slip = 3
		$rear_left.wheel_friction_slip = 10.5
		$rear_right.wheel_friction_slip = 10.5
		
	
	# check if we need to be in reverse to have to press reverse put this: had_throttle_or_brake_input == false and 
	if (brake_val > 0.0  and current_speed_mps < 1.0 and handbrake == 0.0):
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
	brake = brake_val * MAX_BRAKE_FORCE + air_friction 
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
#EXPLOSION	
	if exploded:
		set_linear_velocity(-linear_velocity)
		set_axis_velocity( Vector3(0, 6, 0))
		rotate_y(deg2rad(rand_range(0,180)))
		rotate_z(deg2rad(rand_range(0,90)))
		exploded = false
#YOU GOT TO BE SKIDDING ME
	skid_logic(throttle_val)


func skid_logic(throttle):
	var rl= skid($rear_left,$rear_left_smoke,throttle)
	var rr = skid($rear_right,$rear_right_smoke,throttle)
	var fl = skid($front_left,$front_left_smoke,throttle)
	var fr = skid($front_right,$front_right_smoke,throttle)
	if rl or rr or fl or fr: 
			if !$sfx_squeal.is_playing():
				$sfx_squeal.play()
	else:
		$sfx_squeal.stop()
		
func skid(wheel,smoke,throttle):
	if (wheel.get_skidinfo() == 0 and wheel.is_in_contact()) and get_speed_kph() > 10 or \
		(wheel.is_in_contact() and throttle > 0.8 and get_speed_kph() < 30 and handbrake == 0):
		smoke.emitting = true
		smoke.direction.z = -1*(get_speed_kph()*0.2)
		smoke.initial_velocity = get_speed_kph()*0.05
		spawn_skid(wheel)
		return true
	else:
		smoke.emitting = false
		return false
		
func spawn_skid( wheel):
	var ray = wheel.get_node("RayCast")
	if ray.is_colliding():
			var col_point = ray.get_collision_point ()
			col_point.y += 0.1
			var skid_instance = skid.instance()
			skid_instance.set_translation(col_point)
			#print (col_point+"  "+skid_instance.translation)
			skid_instance.rotate_y(get_rotation().y)
			skid_instance.set_name("skid")
			get_parent().add_child(skid_instance)
			
func _on_teleport_teleport_car(pos):
	self.respawn(pos,true)



