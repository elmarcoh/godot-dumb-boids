extends CharacterBody3D

@onready var group: Area3D = $GroupDetector

@export var turn_rate: float = PI/10 # deg/sec
@export var target: Node3D
@export var speed: float =  2.0

func _physics_process(delta: float) -> void:
	if not target:
		return

	var local_target = to_local(target.global_position)
	var direction: Vector3 = Vector3.FORWARD

	for body in group.get_overlapping_bodies():
		direction -= to_local(body.position)
	direction += local_target
	var angle = Vector3.FORWARD.angle_to(direction)

	if not is_zero_approx(angle):
		var rot_axis = Vector3.FORWARD.cross(local_target).normalized()
		rotate_object_local(rot_axis, min(angle, turn_rate))
		DebugDraw3D.draw_line(position, position+rot_axis, Color.SEA_GREEN)

	DebugDraw3D.draw_line(
		global_position, target.global_position, Color.DARK_RED)

	var translation = Vector3.FORWARD * speed * delta
	var to_target = target.global_position - global_position
	translate_object_local(translation)

	if translation.length_squared() > to_target.length_squared():
		target.global_position = Vector3(
			randf_range(-20.0, 20.0),
			randf_range(-20.0, 20.0),
			randf_range(-20.0, 20.0))

