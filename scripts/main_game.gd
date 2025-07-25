class_name MainGame extends Node2D

func _input(event):
	if event.is_action_pressed('left_click'):
		raycast_check_for_card()
		print("Click Left Button")

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	print(result)
