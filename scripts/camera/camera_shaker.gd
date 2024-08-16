class_name CameraShaker extends Resource

signal shake_finished

var shake_factor:float = 10.0
var shake_duration:float = 0.1
var shake_per_sec:float = 0.01

var duration: Timer
var physics: Timer
	
func screen_shake(factor:float, time_duration:float):
	if duration == null or physics == null:
		duration = Timer.new()
		physics = Timer.new()
		duration.timeout.connect(_duration_timeout)
		physics.timeout.connect(func ():
			_shake()
		)
		Camera.instance.add_child(duration)
		Camera.instance.add_child(physics)
	
	shake_factor = factor
	shake_duration = time_duration
	
	duration.wait_time = shake_duration
	duration.one_shot = true
	duration.autostart = false
	
	physics.wait_time = shake_per_sec
	physics.one_shot = false
	physics.autostart = false
	
	duration.start()
	physics.start()

func _shake():
	var shake_duration_normalized = duration.time_left/shake_duration
	var rng = Vector2(	randf_range(-shake_factor*shake_duration_normalized,shake_factor*shake_duration_normalized)	,
						randf_range(-shake_factor*shake_duration_normalized,shake_factor*shake_duration_normalized)	)
	Camera.instance.global_position += rng

func _duration_timeout():
	duration.queue_free()
	physics.queue_free()
	shake_finished.emit()
