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
		textbox.show_tooltip("Press [Z] to pick up key.", "לחצו [Z] כדי לקחת את המפתח.")
		if not textbox.text_shown and Input.is_action_just_pressed("interact"):
			$Key.visible = false
			Status.current_item = Status.Item.CUPBOARD_KEY
	elif near(get_player_position(), $Anchor.global_position):
		if Status.chest_open:
			textbox.show_tooltip("Press [X] to enter chest.", "לחצו [X] כדי להיכנס לתיבה.")
		elif Status.current_item == Status.Item.HAMMER:
			textbox.show_tooltip("Press [Z] to hit chest with hammer.", "לחצו [Z] כדי להכות בתיבה עם הפטיש.")
			if Input.is_action_just_pressed("interact"):
				Status.chest_open = true
				Status.current_item = Status.Item.NONE
				$ChestOpen.visible = true
				$Chest.visible = false
				textbox.show_text(Speaker.SNAIL, "The lid broke open!", "המכסה נשבר ונפתח!")
				await textbox.done
				textbox.show_text(Speaker.SNAIL, "The hammer broke too...", "גם הפטיש נשבר...")
				await textbox.done
		else:
			textbox.show_tooltip("Press [Z] to examine chest.", "לחצו [Z] כדי להסתכל על התיבה.")
			if Input.is_action_just_pressed("interact") and not textbox.text_shown:
				textbox.show_text(Speaker.SNAIL, "The lid is stuck.", "המכסה תקוע.")
				await textbox.done
				if Status.current_item == Status.Item.CUPBOARD_KEY:
					textbox.show_text(Speaker.SNAIL, "Even the key won't help.", "גם המפתח לא יעזור.")
					await textbox.done
	elif near(get_player_position(), $Crab.global_position):
		if Status.current_item == Status.Item.NUT:
			textbox.show_tooltip("Press [Z] to give nut to crab.", "לחצו [Z] כדי לתת אגוז לסרטן.")
			if Input.is_action_just_pressed("interact") and not textbox.text_shown:
				textbox.show_text(Speaker.SNAIL, "Please crack this nut for me?", "תוכל לפצח את האגוז הזה בשבילי?")
				await textbox.done
				textbox.show_text(Speaker.CRACKER, "No problem!", "אין בעיה!")
				await textbox.done
				Status.current_item = Status.Item.CRACKED_NUT
				textbox.show_text(Speaker.SNAIL, "Thanks, you are the best!", "תודה, אין עליך!")
				await textbox.done
		else:
			textbox.show_tooltip("Press [Z] to talk to crab.", "לחצו [Z] כדי לדבר עם הסרטן.")
			if Input.is_action_just_pressed("interact") and not textbox.text_shown:
				textbox.show_text(Speaker.SNAIL, "This is Cracker, my pet crab.", "זה צבטני, סרטן המחמד שלי.")
				await textbox.done
				textbox.show_text(Speaker.SNAIL, "Hello cracker!", "שלום צבטני!")
				await textbox.done
				textbox.show_text(Speaker.CRACKER, "Hi there!", "היי!")
				await textbox.done
				textbox.show_text(Speaker.CRACKER, "You can press [C] to go out.", "אפשר ללחוץ על [C] כדי לצאת החוצה.")
				await textbox.done
				textbox.show_text(Speaker.SNAIL, "I know, thanks Cracker!", "אני יודע, תודה צבטני!")
				await textbox.done
	else:
		textbox.hide_tooltip()
