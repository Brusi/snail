extends Level

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if Status.current_item == Status.Item.NUT or Status.current_item == Status.Item.CRACKED_NUT or Status.rat_dead:
		$Nut.queue_free()
	if Status.current_item == Status.Item.CLIPPERS or Status.hedges_clipped:
		$Clippers.queue_free()
	
func _physics_process(delta):
	if Status.rat_dead:
		$Rat/AnimatedSprite2D.play("dead")
	elif abs($Rat.global_position.y - get_player_position().y) > 0.5:
		$Rat.global_position.y = $Rat.global_position.y * 0.8 + get_player_position().y * 0.2
		$Rat/AnimatedSprite2D.play("run")
	else:
		$Rat/AnimatedSprite2D.play("idle")
	
func _process(delta):
	if not active:
		return

	var textbox: = get_textbox()
	
	if Status.rat_dead:
		$Rat.flip_v = true
		
	if not Status.first_time_see_clippers_shown:
		Status.first_time_see_clippers_shown = true
		textbox.show_text(Speaker.SNAIL, "My clippers!", "המזמרה שלי!")
		await textbox.done
	
	
	if get_node_or_null("Nut") != null and near(get_player_position(), $Nut.global_position):
		textbox.show_tooltip("Press [Z] to pick up nut.", "לחצו [Z] כדי לקחת את האגוז.")
		if Input.is_action_just_pressed("interact"):
			Status.current_item = Status.Item.NUT
			$Nut.queue_free()
			
		pass
	elif get_node_or_null("Clippers") != null and near(get_player_position(), $Clippers.global_position):
		textbox.show_tooltip("Press [Z] to pick up clippers.", "לחצו [Z] כדי לקחת את המזמרה.")
		if Input.is_action_just_pressed("interact"):
			$Clippers.queue_free()
			Status.current_item = Status.Item.CLIPPERS
			textbox.show_text(Speaker.SNAIL, "My clippers, finally!", "המזמרה שלי, סוף סוף!")
			await textbox.done
			
	elif near(get_player_position(), $Rat.global_position) and not textbox.text_shown:
		if Status.rat_dead:
			textbox.show_tooltip("Press [Z] to talk to Akbarat.", "לחצו [Z] כדי לדבר עם עכברן.")
			if Input.is_action_just_pressed("interact"):
				textbox.show_text(Speaker.SNAIL, "He is passed out.", "הוא התעלף.")
				await textbox.done
				
		else:  # Rat is alive
			if Status.current_item == Status.Item.COIN:
				textbox.show_tooltip("Press [Z] to give gem to Akbarat.", "לחצו [Z] כדי לתת את אבן החן לעכברן.")
				if Input.is_action_just_pressed("interact"):
					Status.current_item = Status.Item.NONE
					textbox.show_text(Speaker.AKBARAT, "Good gem, shines a lot", "אבן יפה, נוצצת באור")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "I'll keep it, why not", "אקח אותה לעצמי ואשמור!")
					await textbox.done
			elif Status.current_item == Status.Item.NUT:
				textbox.show_tooltip("Press [Z] to give nut to Akbarat.", "לחצו [Z] כדי לתת את האגוז לעכברן.")
				if Input.is_action_just_pressed("interact"):
					textbox.show_text(Speaker.AKBARAT, "I cannot crack this nut", "איני יכול לפצח אגוזים")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "My teeth are all rot", "השיניים שלי על הפנים!")
					await textbox.done
			elif Status.current_item == Status.Item.CRACKED_NUT:
				textbox.show_tooltip("Press [Z] to give cracked nut to Akbarat.", "לחצו [Z] כדי לתת אגוז מפוצח לעכברן.")
				if Input.is_action_just_pressed("interact"):
					Status.current_item = Status.Item.NONE
					textbox.show_text(Speaker.AKBARAT, "Thank you a lot", "תודה רבה, זה ממש מצויין")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "This nut is all cracked", "הבאת אגוז מפוצח ומוכן")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "Nom nom nom, that's a good nut", "נום נום נום, זה ממש מעדן")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "Blat, I forgot,", "אוי בלאט, שכחתי מזמן")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "I'm allergic to nuts!", "אני אלרגי לאגוזים! איזה בלאגן!")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "That's the end of Akbarat", "זהו סופו של עכברן")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "The Rat in the Haaaa...", "העכברוש בטורבעעעע...")
					await textbox.done
					Status.rat_dead = true
					textbox.show_text(Speaker.SNAIL, "He passed out", "הוא התעלף")
					await textbox.done
			else:
				textbox.show_tooltip("Press [Z] to talk to Akbarat.", "לחצו [Z] כדי לדבר עם עכברן.")
				if Input.is_action_just_pressed("interact"):
					textbox.show_text(Speaker.AKBARAT, "I'm Akbarat, The Rat in the Hat", "אני עכברן, העכברוש בטורבן!")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "The clippers are mine, that's that!", "המזמרה היא שלי, אז תעוף כבר מכאן!")
					await textbox.done
					textbox.show_text(Speaker.AKBARAT, "I love them, so shiny and bright!", "מבריקה ויפה שחבל על הזמן!")
					await textbox.done
			
	else:
		textbox.hide_tooltip()
			
		
	
func get_allow_going_deeper() -> bool:
	# This is the most bottom depth.
	return false
	
func init_level() -> void:
	$Rat.global_position.y = get_player_position().y
	active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
