extends "res://src/Abilities/Ability.gd"

export(PackedScene) var building :PackedScene
export var ore = 0
export var crystal = 0

func start(u,c):
	.start(u,c)
	var b = building.instance()

	var area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = b.get_collision_shape()
	get_tree().current_scene.add_child(area)
	area.global_position = command.position
	
	if not area.get_overlapping_bodies().empty():
		ability_fail("Overlapping!")
		area.queue_free()
		unit.command_end()
		return
	
	for player in get_tree().get_nodes_in_group("Player"):
		if player.player_index == unit.player_index:
			if not player.has_enough_resource(ore,crystal):
				ability_fail("Resource not enough")
				area.queue_free()
				unit.command_end()
				return
			else:
				player.consume_resource(ore,crystal)
	b.player_index = unit.player_index
	get_tree().current_scene.add_child(b)
	b.global_position = command.position
	unit.command_end()
	pass
	
