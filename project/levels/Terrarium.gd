extends Level

func _ready():
	super()
	if Status.cupboard_open:
		$Key.visible = false
	
	$ChestOpen.visible = Status.chest_open
	$Chest.visible = not $ChestOpen.visible
	
	Status.seen_go_in_tooltip = true
	
func get_allow_going_deeper() -> bool:
	return Status.chest_open

func _process(delta):
	var textbox: = get_textbox()
	if near(get_player_position(), $Key.global_position) and $Key.visible:
		textbox.show_tooltip("Press [Z] to pick up key.")
		if not textbox.text_shown and Input.is_action_just_pressed("interact"):
			$Key.visible = false
			Status.current_item = Status.Item.CUPBOARD_KEY
	elif near(get_player_position(), $Anchor.global_position):
		if Status.chest_open:
			textbox.show_tooltip("Press [X] to enter chest.")
		elif Status.current_item == Status.Item.HAMMER:
			textbox.show_tooltip("Press [Z] to hit chest with hammer.")
			if Input.is_action_just_pressed("interact"):
				Status.chest_open = true
				Status.current_item = Status.Item.NONE
				$ChestOpen.visible = true
				$Chest.visible = false
				textbox.show_text("The lid broke open!")
				await textbox.done
				textbox.show_text("The hammer broke too...")
				await textbox.done
		else:
			textbox.show_tooltip("Press [Z] to examine chest.")
			if Input.is_action_just_pressed("interact") and not textbox.text_shown:
				textbox.show_text("The lid is stuck.")
				await textbox.done
				if Status.current_item == Status.Item.CUPBOARD_KEY:
					textbox.show_text("Even the key won't help.")
					await textbox.done
	elif near(get_player_position(), $Crab.global_position):
		if Status.current_item == Status.Item.NUT:
			textbox.show_tooltip("Press [Z] to give nut to crab.")
			if Input.is_action_just_pressed("interact") and not textbox.text_shown:
				textbox.show_text("Please crack this nut for me?")
				await textbox.done
				textbox.show_text("Cracker: No problem!")
				await textbox.done
				Status.current_item = Status.Item.CRACKED_NUT
				textbox.show_text("Thanks, you are the best!")
				await textbox.done
		else:
			textbox.show_tooltip("Press [Z] to talk to crab.")
			if Input.is_action_just_pressed("interact") and not textbox.text_shown:
				textbox.show_text("This is Cracker, my pet crab.")
				await textbox.done
				textbox.show_text("Hello cracker!")
				await textbox.done
				textbox.show_text("Cracker: Hi there!")
				await textbox.done
				textbox.show_text("Cracker: You can press [C] to go out.")
				await textbox.done
				textbox.show_text("I know, thanks Cracker!")
				await textbox.done
	else:
		textbox.hide_tooltip()
