extends CharacterBody3D
class_name Boid

@onready var group: Area3D = $GroupDetector

@export var turn_rate: float = PI/2.0 # deg/sec
@export var target: Node3D
@export var max_speed: float = 20.0

func _physics_process(delta: float) -> void:
	if not target:
		return

	var local_target = to_local(target.global_position)
	var separation = separation_vec()
	DebugDraw3D.draw_line(global_position, global_position + separation, Color.ORANGE)
	var local_velocity =  separation + target_vec()
	var angle = Vector3.FORWARD.angle_to(local_velocity)

	if not is_zero_approx(angle):
		var rot_axis = Vector3.FORWARD.cross(local_velocity).normalized()
		rotate_object_local(rot_axis, min(angle, turn_rate * delta))
		DebugDraw3D.draw_line(position, position+local_velocity, Color.SEA_GREEN)

	DebugDraw3D.draw_line(
		global_position, target.global_position, Color.DARK_RED)

	var translation = Vector3.FORWARD * max_speed * delta
	translate_object_local(translation)

	if local_target.length_squared() < 1.0:
		target.global_position = Vector3(
			randf_range(-20.0, 20.0),
			randf_range(-20.0, 20.0),
			randf_range(-20.0, 20.0))

func separation_vec() -> Vector3:
	var direction: Vector3 = Vector3.ZERO
	for body in group.get_overlapping_bodies():
		# printt(body, body == self)
		if body != self:
			var local_pos = to_local(body.position)
			direction -= local_pos.normalized()
	return direction

func target_vec() -> Vector3:
	return to_local(target.global_position).normalized()

func rand_deviation() -> Vector3:
	var fact = 0.2
	return Vector3(
		randf_range(-fact, fact),
		randf_range(-fact, fact),
		randf_range(-fact, fact),
	)
