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
		textbox.show_text("My clippers!")
		await textbox.done
	
	
	if get_node_or_null("Nut") != null and near(get_player_position(), $Nut.global_position):
		textbox.show_tooltip("Press [Z] to pick up nut.")
		if Input.is_action_just_pressed("interact"):
			Status.current_item = Status.Item.NUT
			$Nut.queue_free()
			
		pass
	elif get_node_or_null("Clippers") != null and near(get_player_position(), $Clippers.global_position):
		textbox.show_tooltip("Press [Z] to pick up clippers.")
		if Input.is_action_just_pressed("interact"):
			$Clippers.queue_free()
			Status.current_item = Status.Item.CLIPPERS
			textbox.show_text("My clippers, finally!")
			await textbox.done
			
	elif near(get_player_position(), $Rat.global_position) and not textbox.text_shown:
		if Status.rat_dead:
			textbox.show_tooltip("Press [Z] to talk to Akbarat.")
			if Input.is_action_just_pressed("interact"):
				textbox.show_text("He is passed out.")
				await textbox.done
				
		else:  # Rat is alive
			if Status.current_item == Status.Item.COIN:
				textbox.show_tooltip("Press [Z] to give gem to Akbarat.")
				if Input.is_action_just_pressed("interact"):
					Status.current_item = Status.Item.NONE
					textbox.show_text("Akbarat: Good gem, shines a lot")
					await textbox.done
					textbox.show_text("Akbarat: I'll keep it, why not")
					await textbox.done
			elif Status.current_item == Status.Item.NUT:
				textbox.show_tooltip("Press [Z] to give nut to Akbarat.")
				if Input.is_action_just_pressed("interact"):
					textbox.show_text("Akbarat: I cannot crack this nut")
					await textbox.done
					textbox.show_text("Akbarat: My teeth are all rot")
					await textbox.done
			elif Status.current_item == Status.Item.CRACKED_NUT:
				textbox.show_tooltip("Press [Z] to give cracked nut to Akbarat.")
				if Input.is_action_just_pressed("interact"):
					Status.current_item = Status.Item.NONE
					textbox.show_text("Akbarat: Thank you a lot")
					await textbox.done
					textbox.show_text("Akbarat: This nut is all cracked")
					await textbox.done
					textbox.show_text("Akbarat: Nom nom nom, that's a good nut")
					await textbox.done
					textbox.show_text("Akbarat: Blat, I forgot,")
					await textbox.done
					textbox.show_text("Akbarat: I'm allergic to nuts!")
					await textbox.done
					textbox.show_text("Akbarat: That's the end of Akbarat")
					await textbox.done
					textbox.show_text("Akbarat: The Rat in the Haaaa...")
					await textbox.done
					Status.rat_dead = true
					textbox.show_text("He passed out")
					await textbox.done
			else:
				textbox.show_tooltip("Press [Z] to talk to Akbarat.")
				if Input.is_action_just_pressed("interact"):
					textbox.show_text("Akbarat: I’m Akbarat, The Rat in the Hat")
					await textbox.done
					textbox.show_text("Akbarat: The clippers are mine, that’s that!")
					await textbox.done
					textbox.show_text("Akbarat: I love them, so shiny and bright!")
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
