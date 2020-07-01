tool
extends Control


var enable_rotation: bool = false
var start_angles: Vector2
var start_euler: Vector3

#var mouse_speed: float = 0.01
export(float, 0.5, 2.0, 0.001) var scroll_zoom = 4.0/3.0


func _ready():
	pass # Replace with function body.


#func _unhandled_input(event):
#	print("EVENT: ", event)
#	if event is InputEventMouseButton:
#		if event.button_index == 1:
#			enable_rotation = event.pressed
##			var cam = get_node("Node3D/Camera3D")
##			cam.transform = cam.transform.rotated(Vector3(0, 1, 0), event)
#	elif event is InputEventMouseMotion:
#		print(event.relative)

#func _input(event):
#	if enable_rotation and event is InputEventMouseMotion:
#		var cam = get_node("Node3D/Camera3D")
#		cam.unproject_position(cam.transform * Vector3())
#		cam.transform = cam.transform.rotated(Vector3(0, 1, 0), event.relative.x * mouse_speed)

func get_polar_coordinates(v: Vector3) -> Vector2:
	var n = v.normalized()
	return Vector2(atan2(n.x, n.z), acos(n.z))


func get_mouse_angles(cam: Camera3D) -> Vector2:
	var m = get_viewport().get_mouse_position()
	var scale = get_viewport_rect().size.x if cam.keep_aspect == Camera3D.KEEP_WIDTH else get_viewport_rect().size.y
	return (m / scale - Vector2(0.5, 0.5)) * deg2rad(cam.fov)
#	var v = cam.project_local_ray_normal(m)
#	return get_polar_coordinates(v)


func get_camera_projection_matrix(cam: Camera3D, res: Vector2) -> Transform:
	var rfov
	var aspect
	if cam.keep_aspect == Camera3D.KEEP_WIDTH:
		# use vertical aspect
		aspect = res.y / res.x
		rfov = atan(aspect * tan(deg2rad(cam.fov) * 0.5))
	else:
		# use horizontal aspect
		aspect = res.x / res.y
		rfov = 0.5 * deg2rad(cam.fov)
	
	var deltaz = cam.far - cam.near
	var sinfov = sin(rfov)
	if deltaz == 0 or sinfov == 0 or aspect == 0:
		return Transform()
	var cotanfov = cos(rfov) / sinfov
	
	var M: Transform = Transform()
	M.basis[0][0] = cotanfov / aspect
	M.basis[1][1] = cotanfov
	M.basis[2][2] = -(cam.far + cam.near) / deltaz
	M.origin[2] = -2.0 * cam.near * cam.far / deltaz
	return M

func get_camera_matrix(cam: Camera3D, res: Vector2) -> Transform:
	var proj: Transform = Transform()
	if cam.projection == Camera3D.PROJECTION_PERSPECTIVE:
		proj = get_camera_projection_matrix(cam, res)
	if cam.projection == Camera3D.PROJECTION_FRUSTUM:
		pass
	if cam.projection == Camera3D.PROJECTION_ORTHOGONAL:
		pass
	return cam.transform * proj.inverse()


func _process(delta):
	var cam = get_node("Node3D/Camera3D")
	var mat = cam.environment.sky.sky_material
	var res = Vector2(get_viewport_rect().size)

	if Input.is_action_just_released("enable_look"):
		enable_rotation = false
	elif Input.is_action_just_pressed("enable_look"):
		enable_rotation = true
		start_angles = get_mouse_angles(cam)
		start_euler = cam.transform.basis.get_euler()
	elif Input.is_action_pressed("enable_look"):
		var angles: Vector2 = get_mouse_angles(cam)
		var diff: Vector2 = angles - start_angles
		cam.transform.basis = Basis(start_euler + Vector3(diff.y, diff.x, 0))

	if Input.is_action_just_released("zoom_in"):
		cam.fov = cam.fov / scroll_zoom
	if Input.is_action_just_released("zoom_out"):
		cam.fov = cam.fov * scroll_zoom

#	var proj = Transform(Basis.IDENTITY, Vector3(0, 0.7, 0.2))
	var model_view_proj: Transform = get_camera_matrix(cam, res)
	mat.set_shader_param("model_view_proj", model_view_proj)
	mat.set_shader_param("inv_model_view_proj", model_view_proj.inverse())

	mat.set_shader_param("resolution", res)

	var tan_fov = tan(deg2rad(cam.fov) * 0.5)
	if cam.keep_aspect == Camera3D.KEEP_WIDTH:
		mat.set_shader_param("tan_fov", Vector2(tan_fov, tan_fov * res.y / res.x))
	else:
		mat.set_shader_param("tan_fov", Vector2(tan_fov * res.x / res.y, tan_fov))
	pass
