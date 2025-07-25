class_name MainGame extends Node2D

var card_being_dragged

func _process(delta):
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = mouse_pos

func _input(event):
	if event.is_action_pressed('left_click'):
		var card = raycast_check_for_card()
		if card:
			card_being_dragged = card
	if event.is_action_released('left_click'):
		card_being_dragged = null
	print("Click Left Button")

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null
