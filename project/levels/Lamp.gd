extends Level

var statetime: = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	pass # Replace with function body.

func _process(delta):
	$Genie.visible = Status.hat_down
	$GenieWithHat.visible = not Status.hat_down
	$Hat.visible = Status.hat_down
	
	statetime += delta
	var offset: float = round(sin(statetime))
	$GenieWithHat.offset.y = offset
	$Genie.offset.y = offset
	
	var textbox: = get_textbox()
	if near(get_player_position(), $Genie.global_position) and not textbox.text_shown:
		if not Status.genie_talked_for_the_first_time:
			textbox.show_tooltip("Press [Z] to talk to Genie.")
			if Input.is_action_just_pressed("interact"):
				Status.genie_talked_for_the_first_time = true
				textbox.show_text("Genie: I have been stuck in this lamp")
				await textbox.done
				textbox.show_text("Genie: For 10,000 years!")
				await textbox.done
				textbox.show_text("Genie: Or so...")
				await textbox.done
				textbox.show_text("Genie: Lost track of time, really")
				await textbox.done
				textbox.show_text("Genie: I miss the world outside...")
				await textbox.done
		elif Status.current_item == Status.Item.COIN:
			textbox.show_tooltip("Press [Z] to give gem to Genie.")
			if Input.is_action_just_pressed("interact"):
				Status.current_item = Status.Item.NONE
				textbox.show_text("Genie: Gems have little value for me")
				await textbox.done
				textbox.show_text("Genie: I'll put it with the rest of my treasure")
				await textbox.done
				textbox.show_text("Genie: I wish I had something truly unique")
				await textbox.done
		elif Status.hat_down:
			textbox.show_tooltip("Press [Z] to talk to Genie.")
			if Input.is_action_just_pressed("interact"):
				textbox.show_text("Genie: Thank you for this beautiful flower!")
				await textbox.done
		elif Status.current_item == Status.Item.FLOWER:
			textbox.show_tooltip("Press [Z] to give flower to Genie.")
			if Input.is_action_just_pressed("interact"):
				textbox.show_text("Genie: Is that... for me?")
				await textbox.done
				textbox.show_text("Genie: It's beautiful!")
				await textbox.done
				textbox.show_text("Genie: I'll put it in my hat.")
				Status.current_item = Status.Item.NONE
			
				Status.hat_down = true
		else:
			textbox.show_tooltip("Press [Z] to talk to Genie.")
			if Input.is_action_just_pressed("interact"):
				textbox.show_text("Genie: I miss the outside")
				await textbox.done
				textbox.show_text("Genie: I can barely remember how it was")
				await textbox.done
	elif near(get_player_position(), $Anchor.global_position):
		if Status.hat_down:
			textbox.show_tooltip("Press [X] to enter hat.")
	else:
		textbox.hide_tooltip()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_allow_going_deeper() -> bool:
	return Status.hat_down
