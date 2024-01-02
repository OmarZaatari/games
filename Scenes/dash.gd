extends Node



@onready var cooldown = %cooldown

@onready var timer = %timer

func start_dash(dur, cd):
	cooldown.wait_time = dur 
	timer.wait_time = cd
	cooldown.start()
	timer.start()

	
func is_dashing():
	return !cooldown.is_stopped()

func dash_available():
	return !timer.is_stopped()
