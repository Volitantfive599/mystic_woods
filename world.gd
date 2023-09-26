extends TileMap

func _ready():
	var map_area = get_used_rect()
	$Player/Camera2D.limit_left = (map_area.position.x + 1) * 16
	$Player/Camera2D.limit_top = (map_area.position.y + 1) * 16
	$Player/Camera2D.limit_right = (map_area.end.x - 1) * 16
	$Player/Camera2D.limit_bottom = (map_area.end.y - 1) * 16


