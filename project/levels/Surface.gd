extends Level


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if Status.hat_down:
		$Flower.queue_free()
	if Status.hedges_clipped:
		$Hedge.queue_free()

func _process(delta):
	var player = get_parent().get_node("Player")
	player.set_shell(true)
	$SnailShell.visible = not player.visible
	
	if not active:
		return
	update()
	
func update():
	# Anchor should follow snail at this level.
	var player_position: = get_player_position()
	$Anchor.global_position = player_position
	
	var textbox:TextBox = get_textbox()
	if not Status.first_time_outside_shown:
		Status.first_time_outside_shown = true
		textbox.show_text(Speaker.SNAIL, 'A beautiful autumn day!', "איזה בוקר סתיו נהדר!")
		await textbox.done
	
	if player_position.y < 0:
		get_parent().up_one_level(get_parent().current_depth - 1)
	if near(player_position, $Sign.global_position):
		textbox.show_tooltip("Press [Z] to read sign", "לחצו [Z] כדי לקרוא את השלט")
		if Input.is_action_just_pressed("interact") and not textbox.text_shown:
			textbox.show_text(Speaker.SNAIL, '"Here lives Mr. Snail."', '"כאן גר מר שבלול."')
			await textbox.done
			textbox.show_text(Speaker.SNAIL, "That's me!", "זה אני!")
			await textbox.done
	elif get_node_or_null("Flower") != null and near(player_position, $Flower.global_position):
		textbox.show_tooltip("Press [Z] to pick flower", "לחצו [Z] כדי לקטוף את הפרח")
		if Input.is_action_just_pressed("interact") and not textbox.text_shown:
			$Flower.queue_free()
			Status.current_item = Status.Item.FLOWER
	elif get_node_or_null("Hedge") != null and near(player_position, $Hedge.global_position):
		if not Status.seen_bushes:
			Status.seen_bushes = true
			textbox.show_text(Speaker.SNAIL, "Oh no, the way is blocked by those hedges!", "אוי לא, השיחים חוסמים את הדרך!")
			await textbox.done
			textbox.show_text(Speaker.SNAIL, "They must have grown during the summer.", "הם בטח צמחו במהלך הקיץ.")
			await textbox.done
			textbox.show_text(Speaker.SNAIL, "I have some hedge clippers back in my shell.", "יש לי מזמרה בבית, בתוך הקונכייה.")
			await textbox.done
		if Status.current_item == Status.Item.CLIPPERS and not textbox.text_shown:
			textbox.show_tooltip("Press [Z] to clip hedges.", "לחצו [Z] כדי לגזום את השיחים.")
			if Input.is_action_just_pressed("interact") and not textbox.text_shown:
				$Hedge.queue_free()
				Status.current_item = Status.Item.NONE
	else:
		$SnailShell.global_position = player_position
		if Status.seen_bushes and not Status.seen_go_in_tooltip and not Status.cupboard_open:
			textbox.show_tooltip("Press [X] to enter your shell.", "לחצו [X] כדי להיכנס לקונכייה.")
		else:
			textbox.hide_tooltip()

func get_allow_going_higher() -> bool:
	# True by default.
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
