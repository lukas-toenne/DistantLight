#tool
extends DirectionalLight3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	look_at(Vector3(0, 0, 0), Vector3(0, 1, 0))
#	print("LOOK!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		look_at(Vector3(0, 0, 0), Vector3(0, 1, 0))
		print("LOOK!")
