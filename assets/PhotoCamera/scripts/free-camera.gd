# Based on Code by Guillaume Roy, 2019
# This script is a code for a basic "flying camera". The camera's orientation is guided by the mouse, and its position by the
# directional keys
# Extended to use the gamepad and screencap

extends Camera

export (bool) var movEnabled = true
export (float) var mouseSensitivity = 0.5
export (float) var joySensitivity = 2
export (float) var joyMoveSensitivity = 5
export (float) var zoomSensitivity = 10 
export (float) var flyspeed = 100
export (bool) var debug = false
export var joy_yaw = JOY_ANALOG_RX
export var joy_pitch = JOY_ANALOG_RY
export var joy_forward = JOY_ANALOG_LY
export var joy_strafe = JOY_ANALOG_LX
export var deadzone = 0.2
export var output_path = "user://img/"
export var file_prefix = "img"
export var cooldown = 1
var yaw : float = 0.0
var pitch : float = 0.0
var newRotation = Vector3()
var update_rotation = false

func _ready():
	yaw = 0.0
	pitch = 0.0
	$HUD.visible = false
#
func _input(event):
#	if event.is_action_pressed("leftClick") and debug:
#		movEnabled = !movEnabled
#		self.set_process(!is_processing())

	if event is InputEventMouseMotion and movEnabled:
		var mouseVec : Vector2 = event.get_relative()

		yaw = fmod(yaw  - mouseVec.x * mouseSensitivity , 360)
		pitch = max(min(pitch - mouseVec.y * mouseSensitivity , 90), -90)
		self.set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0))

func _process(delta):
	cooldown -= delta
	if not movEnabled:
		return
	if Input.get_connected_joypads ().size() > 0:
		readJoystick(delta)
	if(Input.is_action_pressed("ui_up")):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * delta * flyspeed * .01)
	if(Input.is_action_pressed("ui_down")):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * delta * flyspeed * -.01)
	if(Input.is_action_pressed("ui_left")):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * delta * flyspeed * .01)
	if(Input.is_action_pressed("ui_right")):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * delta * flyspeed * -.01)
	if (Input.is_action_pressed("zoom_in")):
		self.fov -= zoomSensitivity*delta
		setZoom()
	if (Input.is_action_pressed("zoom_out")):
		self.fov += zoomSensitivity*delta 
		if self.fov >70:
			self.fov = 70
		setZoom()
	if(Input.is_action_pressed("ui_accept") and cooldown < 0 ):
		screenCap()
		cooldown =1


func rotateIt(degrees):
	print(degrees)
	newRotation = degrees
	yaw = fmod(newRotation.x, 360)
	pitch = max(min(newRotation.y , 90), -90)
	rotate_y(deg2rad(degrees.x))
	rotate_x(deg2rad(degrees.y))
	update_rotation = true

func screenCap():
	$HUD.visible = false
	var time = OS.get_datetime()
	time = "%s_%02d_%02d_%02d%02d%02d" % [time['year'], time['month'], time['day'], 
											time['hour'], time['minute'], time['second']]
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")		
	$camera_click.play()
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png("%s%s_%s.png" % [output_path, time, file_prefix])
	$HUD/label/rtl.updateText("Photograph Saved as %s_%s.png" % [ time, file_prefix])
	$HUD.visible = true

func setZoom():
	$HUD/zoom/zoom.value = 70-self.fov
	if $HUD/zoom/zoom.value > 63:
		 $HUD/zoom/zoom.value = 63
	if $HUD/zoom/zoom.value < 5:
		 $HUD/zoom/zoom.value = 5
		
func readJoystick(delta):
	var cam_forward = Input.get_joy_axis(0, joy_forward)
	if abs(cam_forward) < deadzone:
		cam_forward = 0
	var cam_strafe = Input.get_joy_axis(0, joy_strafe)
	if abs(cam_strafe) < deadzone:
		cam_strafe = 0
	var cam_yaw = Input.get_joy_axis(0, joy_yaw)
	var cam_pitch = Input.get_joy_axis(0, joy_pitch)
	if abs(cam_yaw) < deadzone :
		cam_yaw = 0
	if abs(cam_pitch) < deadzone :
		cam_pitch = 0
	#move CAMERA
	self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(-cam_strafe,0,0) * delta * joyMoveSensitivity )
	self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,-cam_forward) * delta * joyMoveSensitivity)
	yaw = fmod(yaw  - cam_yaw* joySensitivity , 360)
	pitch = max(min(pitch - cam_pitch * joySensitivity , 90), -90)
	self.set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0))
	
func enable ():
	self.movEnabled = true
	self.visible = true
	self.current = true
	$HUD.visible = true

func disable():
	self.movEnabled = false
	self.visible = false
	self.current = false
	$HUD.visible = false
