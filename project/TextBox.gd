extends Control

class_name TextBox

# Signal to
signal continue_in

signal shown
signal done

var text_shown: = false
var tooltip_shown: = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func consume(s:String, to_consume:String) -> String:
	if s.begins_with(to_consume):
		return s.substr(to_consume.length())
	return s;

func show_text(text_to_show:String):
	tooltip_shown = false
	text_shown = true
	visible = true
	emit_signal("shown")
	
	# Handle portrait.
	$Portraits.visible = true
	for c in $Portraits.get_children():
		c.visible = false

	if text_to_show.begins_with("Genie: "):
		text_to_show = consume(text_to_show, "Genie: ")
		if Status.hat_down:
			$Portraits/Genie.visible = true
		else:
			$Portraits/GenieHat.visible = true
	elif text_to_show.begins_with("Cracker: "):
		text_to_show = consume(text_to_show, "Cracker: ")
		$Portraits/Crab.visible = true
	elif text_to_show.begins_with("Akbarat: "):
		text_to_show = consume(text_to_show, "Akbarat: ")
		$Portraits/Rat.visible = true
	elif get_parent().get_parent().current_depth == 0:
		$Portraits/SnailShell.visible = true
	else:
		$Portraits/Snail.visible = true
	
	$Timer.start()
	for i in range(text_to_show.length()+1):
		$Label.text = text_to_show.substr(0, i)
		#$Label.align = Label.ALIGN_LEFT
		await $Timer.timeout
	
	await self.continue_in
	visible = false
	text_shown = false
	emit_signal("done")
	
func show_tooltip(text_to_show:String):
	if text_shown:
		# Tooltip should not override dialogue.
		return
	visible = true
	tooltip_shown = true
	$Label.text = text_to_show
	#$Label.align = Label.ALIGNMENT_CENTER
	
	$Portraits.visible = false
	
func hide_tooltip():
	if text_shown or not tooltip_shown:
		# Turning off tooltip should not affect dialogue.
		return
	visible = false
	tooltip_shown = false
	
func _process(delta:float):
	if Input.is_action_just_pressed("enter") or Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("exit"):
		emit_signal("continue_in")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
