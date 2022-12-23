extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	set_text("FPS " + str(Engine.get_frames_per_second()))
	if Input.is_action_pressed("jump"):
		text += "\nJUMP"
	if Input.is_action_pressed("action"):
		text += "\nACTION"
	if Input.is_action_pressed("up"):
		text += "\nUP"
	if Input.is_action_pressed("down"):
		text += "\nDOWN"
	if Input.is_action_pressed("left"):
		text += "\nLEFT"
	if Input.is_action_pressed("right"):
		text += "\nRIGHT"
