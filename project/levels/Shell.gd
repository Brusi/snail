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
		textbox.show_text("Good morning! (Press [Z] to continue)")
		await textbox.done
		textbox.show_text("I'm Mr. Snail.")
		await textbox.done
		textbox.show_text("Summer is over, and it's all wet outside")
		await textbox.done
		textbox.show_text("Perfect for me")
		await textbox.done
		textbox.show_text("It's time for a little autumn hike")
		await textbox.done
	
func _process(delta):
	if not active:
		return
	update()
		
func update():
	var textbox: = get_textbox()
	if near(get_player_position(), $Closet.global_position):
		if $Hammer.visible:
			textbox.show_tooltip("Press [Z] to pick up hammer.")
		elif not Status.cupboard_open:
			textbox.show_tooltip("Press [Z] to open cupboard.")
		
		if not textbox.text_shown and Input.is_action_just_pressed("interact"):
			if Status.cupboard_open and $Hammer.visible:
				textbox.show_text("That's my best hammer.")
				await textbox.done
				Status.current_item = Status.Item.HAMMER
				$Hammer.visible = false
			elif Status.current_item == Status.Item.CUPBOARD_KEY:
				Status.cupboard_open = true
				Status.current_item = Status.Item.NONE
				
				$Closet.visible = false
				$OpenCloset.visible = true
				$Hammer.visible = true
				textbox.show_text("Oh no!")
				await textbox.done
				textbox.show_text("Someone took my hedge clippers!")
				await textbox.done
				textbox.show_text("Who would do such a hideous thing?")
				await textbox.done
			elif not Status.cupboard_open:
				textbox.show_text("It's locked!")
				await textbox.done
				textbox.show_text("Where did I put my key?")
				await textbox.done
	elif near(get_player_position(), $Anchor.global_position):
		get_textbox().show_tooltip("Press [X] to enter terrarium.")
	elif first_time_scene:
		get_textbox().show_tooltip("Press [C] to exit your shell.")
	else:
		get_textbox().hide_tooltip()
		
	# Actions
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
