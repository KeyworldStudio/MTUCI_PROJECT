extends SoupStayAt



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !(
			enabled 
			and target_node 
			and bone_node
			and _parent_enable_check() 
		):
		return
	
	var result_position: Vector2 = target_node.global_position
	if easing and use_easing:
		easing.update(delta,target_node.global_position)
		result_position = easing.state
	
	var fixed_position: Vector2 = \
	_mod_stack.apply_bone_position_mod(
			bone_node, 
			position_global_to_local(
				result_position, bone_node.get_parent()
			)
		)
	
	if fixed_position and easing and use_easing:
		easing.state = position_local_to_global(fixed_position, bone_node.get_parent())
		

func _process(delta: float) -> void:
	pass
