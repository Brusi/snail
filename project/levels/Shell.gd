extends Level


var first_time_scene: = false
	


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	first_time_scene = not Status.first_time_text_shown
	$Closet.visible = not Status.cupboard_open
	$OpenCloset.visible = not $Closet.visible
	$Hammer.visible = Status.cupboard_open and Status.current_item != Status.Item.HAMMER and not Status.chest_open

func init_level() -> void:
	get_parent().get_node("Player").set_shell(false)
	
	active = true
	if not Status.first_time_text_shown:
		Status.first_time_text_shown = true
		var textbox:TextBox = get_textbox()
		textbox.show_text(Speaker.SNAIL, "Good morning! (Press [Z] to continue)", "בוקר טוב! (לחצו [Z] כדי להמשיך)")
		await textbox.done
		textbox.show_text(Speaker.SNAIL, "I'm Mr. Snail.", "אני מר שבלול.")
		await textbox.done
		textbox.show_text(Speaker.SNAIL, "Summer is over, and it's all wet outside", "הקיץ נגמר, והכל רטוב בחוץ")
		await textbox.done
		textbox.show_text(Speaker.SNAIL, "Perfect for me", "מושלם בשבילי")
		await textbox.done
		textbox.show_text(Speaker.SNAIL, "It's time for a little autumn hike", "זה הזמן לטיול סתיו קטן")
		await textbox.done
	
func _process(delta):
	if not active:
		return
	update()
		
func update():
	var textbox: = get_textbox()
	if near(get_player_position(), $Closet.global_position):
		if $Hammer.visible:
			textbox.show_tooltip("Press [Z] to pick up hammer.", "לחצו [Z] כדי לקחת את הפטיש.")
		elif not Status.cupboard_open:
			textbox.show_tooltip("Press [Z] to open cupboard.", "לחצו [Z] כדי לפתוח את הארון.")
		
		if not textbox.text_shown and Input.is_action_just_pressed("interact"):
			if Status.cupboard_open and $Hammer.visible:
				textbox.show_text(Speaker.SNAIL, "That's my best hammer.", "זה הפטיש הכי טוב שיש לי.")
				await textbox.done
				Status.current_item = Status.Item.HAMMER
				$Hammer.visible = false
			elif Status.current_item == Status.Item.CUPBOARD_KEY:
				Status.cupboard_open = true
				Status.current_item = Status.Item.NONE
				
				$Closet.visible = false
				$OpenCloset.visible = true
				$Hammer.visible = true
				textbox.show_text(Speaker.SNAIL, "Oh no!", "אוי לא!")
				await textbox.done
				textbox.show_text(Speaker.SNAIL, "Someone took my hedge clippers!", "מישהו לקח לי את המזמרה!")
				await textbox.done
				textbox.show_text(Speaker.SNAIL, "Who would do such a hideous thing?", "מי יכול היה לעשות דבר כזה נורא?")
				await textbox.done
			elif not Status.cupboard_open:
				textbox.show_text(Speaker.SNAIL, "It's locked!", "זה נעול!")
				await textbox.done
				textbox.show_text(Speaker.SNAIL, "Where did I put my key?", "איפה שמתי את המפתח?")
				await textbox.done
	elif near(get_player_position(), $Anchor.global_position):
		get_textbox().show_tooltip("Press [X] to enter terrarium.", "לחצו [X] כדי להיכנס לטרריום.")
	elif first_time_scene:
		get_textbox().show_tooltip("Press [C] to exit your shell.", "לחצו [C] כדי לצאת מהקונכייה.")
	else:
		get_textbox().hide_tooltip()
		
	# Actions
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
