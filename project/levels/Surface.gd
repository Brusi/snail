extends Level


# Called when the node enters the scene tree for the first time.
func _ready():
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
		textbox.show_text('A beautiful autumn day!')
		await textbox.done
	
	if player_position.y < 0:
		get_parent().up_one_level(get_parent().current_depth - 1)
	if near(player_position, $Sign.global_position):
		textbox.show_tooltip("Press [Z] to read sign")
		if Input.is_action_just_pressed("interact") and not textbox.text_shown:
			textbox.show_text('"Here lives Mr. Snail."')
			await textbox.done
			textbox.show_text("That's me!")
			await textbox.done
	elif get_node_or_null("Flower") != null and near(player_position, $Flower.global_position):
		textbox.show_tooltip("Press [Z] to pick flower")
		if Input.is_action_just_pressed("interact") and not textbox.text_shown:
			$Flower.queue_free()
			Status.current_item = Status.Item.FLOWER
	elif get_node_or_null("Hedge") != null and near(player_position, $Hedge.global_position):
		if not Status.seen_bushes:
			Status.seen_bushes = true
			textbox.show_text("Oh no, the way is blocked by those hedges!")
			await textbox.done
			textbox.show_text("They must have grown during the summer.")
			await textbox.done
			textbox.show_text("I have some hedge clippers back in my shell.")
			await textbox.done
		if Status.current_item == Status.Item.CLIPPERS and not textbox.text_shown:
			textbox.show_tooltip("Press [Z] to clip hedges.")
			if Input.is_action_just_pressed("interact") and not textbox.text_shown:
				$Hedge.queue_free()
				Status.current_item = Status.Item.NONE
	else:
		$SnailShell.global_position = player_position
		if Status.seen_bushes and not Status.seen_go_in_tooltip and not Status.cupboard_open:
			textbox.show_tooltip("Press [X] to enter your shell.")
		else:
			textbox.hide_tooltip()

func get_allow_going_higher() -> bool:
	# True by default.
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
