extends CamFollowState

func _on_enter() -> void:
	cur_lead_offset = -char_center_dist

func _startup_check() -> bool:
	return not self.character.is_grounded()

func _stop_check() -> bool:
	return not _startup_check()
