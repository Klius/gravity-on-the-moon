extends PathFollow


export var speed = 10
export var active = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
