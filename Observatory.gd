tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func get_camera_matrix(cam: Camera3D):
#	cam.projection


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(get_viewport_rect())
#	var sky = get_camera().environment.sky
	var cam = get_node("Node3D/Camera3D")
	var mat = cam.environment.sky.sky_material

#	var proj = Transform(Basis.IDENTITY, Vector3(0, 0.7, 0.2))
#	mat.set_shader_param("projection_matrix", proj)

	var res = Vector2(get_viewport_rect().size)
	mat.set_shader_param("resolution", res)

	var tan_fov = tan(deg2rad(cam.fov) * 0.5)
	if cam.keep_aspect == Camera3D.KEEP_WIDTH:
		mat.set_shader_param("tan_fov", Vector2(tan_fov, tan_fov * res.y / res.x))
	else:
		mat.set_shader_param("tan_fov", Vector2(tan_fov * res.x / res.y, tan_fov))
	pass
