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
			textbox.show_tooltip("Press [Z] to talk to Genie.", "לחצו [Z] כדי לדבר עם הג'יני.")
			if Input.is_action_just_pressed("interact"):
				Status.genie_talked_for_the_first_time = true
				textbox.show_text(Speaker.GENIE, "I have been stuck in this lamp", "אני תקוע בתוך המנורה הזאת")
				await textbox.done
				textbox.show_text(Speaker.GENIE, "For 10,000 years!", "כבר 10,000 שנה!")
				await textbox.done
				textbox.show_text(Speaker.GENIE, "Or so...", "פחות או יותר...")
				await textbox.done
				textbox.show_text(Speaker.GENIE, "Lost track of time, really", "איבדתי תחושת זמן, אם לומר את האמת")
				await textbox.done
				textbox.show_text(Speaker.GENIE, "I miss the world outside...", "אני מתגעגע לעולם שבחוץ...")
				await textbox.done
		elif Status.current_item == Status.Item.COIN:
			textbox.show_tooltip("Press [Z] to give gem to Genie.", "לחצו [Z] כדי לתת את אבן החן לג'יני.")
			if Input.is_action_just_pressed("interact"):
				Status.current_item = Status.Item.NONE
				textbox.show_text(Speaker.GENIE, "Gems have little value for me", "לאבני חן אין הרבה ערך בשבילי")
				await textbox.done
				textbox.show_text(Speaker.GENIE, "I'll put it with the rest of my treasure", "אשים אותה עם שאר האוצר שלי")
				await textbox.done
				textbox.show_text(Speaker.GENIE, "I wish I had something truly unique", "הלוואי והיה לי משהו מיוחד באמת")
				await textbox.done
		elif Status.hat_down:
			textbox.show_tooltip("Press [Z] to talk to Genie.", "לחצו [Z] כדי לדבר עם הג'יני.")
			if Input.is_action_just_pressed("interact"):
				textbox.show_text(Speaker.GENIE, "Thank you for this beautiful flower!", "תודה על הפרח היפהפה הזה!")
				await textbox.done
		elif Status.current_item == Status.Item.FLOWER:
			textbox.show_tooltip("Press [Z] to give flower to Genie.", "לחצו [Z] כדי לתת פרח לג'יני.")
			if Input.is_action_just_pressed("interact"):
				textbox.show_text(Speaker.GENIE, "Is that... for me?", "זה... בשבילי?")
				await textbox.done
				textbox.show_text(Speaker.GENIE, "It's beautiful!", "הוא יפהפה!")
				await textbox.done
				textbox.show_text(Speaker.GENIE, "I'll put it in my hat.", "אשים אותו בטורבן שלי.")
				Status.current_item = Status.Item.NONE
			
				Status.hat_down = true
		else:
			textbox.show_tooltip("Press [Z] to talk to Genie.", "לחצו [Z] כדי לדבר עם הג'יני.")
			if Input.is_action_just_pressed("interact"):
				textbox.show_text(Speaker.GENIE, "I miss the outside", "אני מתגעגע לעולם שבחוץ")
				await textbox.done
				textbox.show_text(Speaker.GENIE, "I can barely remember how it was", "אני בקושי מצליח לזכור אותו")
				await textbox.done
	elif near(get_player_position(), $Anchor.global_position):
		if Status.hat_down:
			textbox.show_tooltip("Press [X] to enter hat.", "לחצו [X] כדי להיכנס לטורבן.")
	else:
		textbox.hide_tooltip()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_allow_going_deeper() -> bool:
	return Status.hat_down
