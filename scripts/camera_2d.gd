extends Camera2D

@export var aiming_offset_x : float = 0.0
@export var aiming_offset_y : float = 0.0
@export var launched_offset_x : float = 375.0
@export var launched_offset_y : float = 120.0
@export var floor_limit : float = 400.0
@export var enable_limit : bool = true

var tween : Tween


func _process(delta):
	#TODO figure out how to smoothly transition the limit
	pass

func doAiming():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "position", Vector2(aiming_offset_x, aiming_offset_y), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	limit_bottom = 10000000
	
func doLaunched():
	if enable_limit:
		if tween:
			tween.kill()
		
		tween = create_tween()
		tween.tween_property(self, "position", Vector2(launched_offset_x, -125), 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "limit_bottom", floor_limit, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "position", Vector2(launched_offset_x, launched_offset_y), 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
