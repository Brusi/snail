extends Node

var enable_sound: = true
var current_depth: = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if Input.is_action_just_pressed("toggle_sound"):
		enable_sound = not enable_sound
		if enable_sound:
			play_depth(current_depth)
		else:
			stop_music()

func stop_music():
	for c in get_children():
		(c as AudioStreamPlayer).stop()

func play_depth(depth:int) -> void:
	current_depth = depth
	
	if not enable_sound:
		return
	
	var stream: = get_node_or_null("Music"+str(depth))
	if stream == null:
		return
		
	for c in get_children():
		if c != stream:
			(c as AudioStreamPlayer).stop()
		
	(stream as AudioStreamPlayer).play()
	
func swoosh_in():
	if not enable_sound:
		return
	$SwooshIn.play()
	
func swoosh_out():
	if not enable_sound:
		return
	$SwooshOut.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
