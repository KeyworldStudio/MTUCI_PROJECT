extends Node

signal turret_selected(turret_index)

func emit_turret_selected(index):
	emit_signal("turret_selected", index)
