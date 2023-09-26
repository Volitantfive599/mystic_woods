extends HBoxContainer

func update_health(value):
	for i in get_child_count():
		get_child(i).visible = value > i


func _on_player_got_hit(health):
	update_health(health)
