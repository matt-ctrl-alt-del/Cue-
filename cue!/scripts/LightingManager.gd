class_name LightingManager
extends CanvasLayer

## Drives the custom lighting / fog-of-war overlay.
## Drop this to a node anywhere. Give it a ColorRect child. Every frame
## this manager the scene for nodes in the LIGHT_GROUP / OBSTRUCTOR_GROUP, converts
## their world positions into viewport-pixel coordinates, and feeds them to the overlay shader.

const MAX_LIGHTS := 48
const MAX_OBSTRUCTORS := 24
const LIGHT_GROUP := "tdl_light"
const OBSTRUCTOR_GROUP := "tdl_obstructor"

@export_group("Look")
@export var ambient: float = 0.05
@export var darkness_color: Color = Color(0.02, 0.02, 0.06)
@export_range(1.0, 16.0) var dither_levels: float = 6.0
@export_range(0.0, 1.0) var softness: float = 0.30
@export_range(0.3, 3.0) var light_curve: float = 1.6
@export_range(1.0, 6.0) var dither_pixel_size: float = 2.0
@export_range(0.0, 1.0) var light_glow: float = 0.15
@export var occlusion_enabled: bool = true

@export_group("Wiring")
@export var color_rect: ColorRect

var _mat: ShaderMaterial

var _positions := PackedVector2Array()
var _radii := PackedFloat32Array()
var _colors := PackedVector3Array()
var _intensities := PackedFloat32Array()
var _o_positions := PackedVector2Array()
var _o_radii := PackedFloat32Array()

func _ready() -> void:
	if color_rect == null:
		color_rect = get_node_or_null("ColorRect")
	if color_rect == null or color_rect.material == null:
		push_warning("LightingManager: no ColorRect with a ShaderMaterial assigned.")
		set_process(false)
		return
	_mat = color_rect.material as ShaderMaterial
	_positions.resize(MAX_LIGHTS)
	_radii.resize(MAX_LIGHTS)
	_colors.resize(MAX_LIGHTS)
	_intensities.resize(MAX_LIGHTS)
	_o_positions.resize(MAX_OBSTRUCTORS)
	_o_radii.resize(MAX_OBSTRUCTORS)
	_apply_look()

func _apply_look() -> void:
	_mat.set_shader_parameter("ambient", ambient)
	_mat.set_shader_parameter("darkness_color", darkness_color)
	_mat.set_shader_parameter("dither_levels", dither_levels)
	_mat.set_shader_parameter("softness", softness)
	_mat.set_shader_parameter("light_curve", light_curve)
	_mat.set_shader_parameter("dither_pixel_size", dither_pixel_size)
	_mat.set_shader_parameter("light_glow", light_glow)
	_mat.set_shader_parameter("occlusion_enabled", occlusion_enabled)

func _process(_delta: float) -> void:
	var vp := get_viewport()
	if vp == null:
		return
	var ct := vp.get_canvas_transform()
	var scale: float = ct.get_scale().x
	var vp_size := vp.get_visible_rect().size

	var count := 0
	for n in get_tree().get_nodes_in_group(LIGHT_GROUP):
		if count >= MAX_LIGHTS:
			break
		if not is_instance_valid(n) or not n.enabled:
			continue
		var node2d := n as Node2D
		if node2d == null:
			continue
		var pos: Vector2 = ct * node2d.global_position
		var sr: float = max(n.radius * scale, 1.0)
		if pos.x + sr < 0.0 or pos.x - sr > vp_size.x \
		or pos.y + sr < 0.0 or pos.y - sr > vp_size.y:
			continue
		_positions[count] = pos
		_radii[count] = sr
		_colors[count] = Vector3(n.color.r, n.color.g, n.color.b)
		var flick: float = 1.0 - n.flicker * randf()
		_intensities[count] = n.intensity * flick
		count += 1

	_mat.set_shader_parameter("light_count", count)
	_mat.set_shader_parameter("light_positions", _positions)
	_mat.set_shader_parameter("light_radii", _radii)
	_mat.set_shader_parameter("light_colors", _colors)
	_mat.set_shader_parameter("light_intensities", _intensities)

	var o_count := 0
	for n in get_tree().get_nodes_in_group(OBSTRUCTOR_GROUP):
		if o_count >= MAX_OBSTRUCTORS:
			break
		if not is_instance_valid(n) or not n.enabled:
			continue
		var node2d := n as Node2D
		if node2d == null:
			continue
		var pos: Vector2 = node2d.get_global_transform_with_canvas().origin
		var sr: float = max(n.radius * scale, 1.0)
		# Cull off-screen obstructors (they can't shadow visible pixels).
		if pos.x + sr < 0.0 or pos.x - sr > vp_size.x \
		or pos.y + sr < 0.0 or pos.y - sr > vp_size.y:
			continue
		_o_positions[o_count] = pos
		_o_radii[o_count] = sr
		o_count += 1

	_mat.set_shader_parameter("obstructor_count", o_count)
	_mat.set_shader_parameter("obstructor_positions", _o_positions)
	_mat.set_shader_parameter("obstructor_radii", _o_radii)
