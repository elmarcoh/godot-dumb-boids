extends Node3D


@onready var target: Node3D = $"../Target"

@export var amount: int:
	set(value):
		var diff = value - get_child_count()
		if diff >= 0:
			for i in range(diff):
				add_child(new_boid())
		else:
			var childs = get_children()
			for i in range(abs(diff)):
				remove_child(childs.pop_back())
		amount = value
				
var boid_scene: Resource = load("res://scenes/boid.tscn")

func _ready() -> void:
	for child in get_children():
		if not (child is Boid) or not target:
			continue
		# needed because the `amount` setter gets called before `target` is resolved
		child.target = target

func new_boid() -> Boid:
	var boid: Boid = boid_scene.instantiate() as Boid
	boid.target = target
	return boid
