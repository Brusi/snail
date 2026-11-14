extends Level


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Status.current_item == Status.Item.COIN:
		$Coin.queue_free()
	pass # Replace with function body.


func _process(delta):
	if near(get_player_position(), $Anchor.global_position):
		get_textbox().show_tooltip("Press [X] to enter lamp.")
	elif get_node_or_null("Coin") != null and near(get_player_position(), $Coin.global_position):
		get_textbox().show_tooltip("Press [Z] to pick up gem.")
		if (Input.is_action_just_pressed("interact")):
			$Coin.queue_free()
			Status.current_item = Status.Item.COIN
			
	else:
		get_textbox().hide_tooltip()
