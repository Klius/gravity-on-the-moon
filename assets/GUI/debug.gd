extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	$Label.text = "\n fps:"+ String(Engine.get_frames_per_second() )
	$Label.text += "\n Running on: "+OS.get_name ( )
	$Label.text += "\n SRAM: "+String(Performance.get_monitor(Performance.MEMORY_STATIC)/1024/1024)+"MB/ " +String(Performance.get_monitor(Performance.MEMORY_STATIC_MAX)/1024/1024)+"MB"
	$Label.text += "\n DRAM: "+String(Performance.get_monitor(Performance.MEMORY_DYNAMIC)/1024/1024)+"MB/ " +String(Performance.get_monitor(Performance.MEMORY_DYNAMIC_MAX)/1024/1024)+"MB"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
