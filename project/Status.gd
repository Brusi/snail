extends Node

enum Item {
	NONE,
	CUPBOARD_KEY,
	HAMMER,
	COIN,
	FLOWER,
	CLIPPERS,
	NUT,
	CRACKED_NUT,
}

@export var hebrew: bool = false

var current_item:int = Item.NONE

var first_time_outside_shown: = false
var first_time_text_shown: = false
var seen_bushes: = false
var seen_go_in_tooltip: = false
var cupboard_open: = false
var chest_open: = false
var genie_talked_for_the_first_time: = false
var hat_down: = false
var first_time_see_clippers_shown: = false
var rat_dead: = false
var hedges_clipped: = false
 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func restart():
	cupboard_open = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
