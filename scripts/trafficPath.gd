extends PathFollow


export var speed = 10
export var active = true
var player_on_area = false
#export(Color) var body_color = Color(0.090196, 0.266667, 0.160784)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$traffic.body_color = body_color
	#$traffic.set_body_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (active):
		var off = offset+speed*delta
		set_offset(stepify(off,0.01))




func _on_traffic_body_entered(body):
	#print("Traffic collided with:"+body.get_name())
	if (body.get_name() == "Car" && active):
		active = false
		var child = self.get_children()[0]#get_node("./traffic")
		var pos = child.global_transform
		var target = get_node("../..")
		remove_child(child)
		target.add_child(child)
		child.global_transform = pos
		print(child.global_transform)
		self.get_parent().remove_child(self)


func _on_Trigger_area_entered(area):
	if area.get_name() == "playerTrigger":
		player_on_area = true
		active = true
		
func _on_Trigger_area_exited(area):
	if area.get_name() == "playerTrigger":
		active = false
		player_on_area = false


func _on_traffic_overRamp():
	pass # Replace with function body.



func _on_T_Whiskers_body_entered(body):
	if body != $"./traffic" :
		active = true
		
func _on_T_Whiskers_body_exited(body):
	if body != $"./traffic" and !player_on_area:
		active = false


func _on_car_front_body_entered(body):
	if body.get_name() == "Car":
		active = false
		


func _on_car_front_body_exited(body):
	if body.get_name() == "Car":
		active = true


