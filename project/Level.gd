extends Node2D

class_name Level

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var active: = false

func near(a:Vector2, b:Vector2) -> bool:
	return abs(a.x - b.x) + abs(a.y - b.y) < 24

func get_textbox() -> TextBox:
	return get_parent().get_textbox()

func get_player_position() -> Vector2:
	return $"../Player".global_position as Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	$TileMap.visible = false
	$Anchor.visible = false
	pass # Replace with function body.

# To be overriden
func init_level() -> void:
	active = true
	pass
	
func get_allow_going_deeper() -> bool:
	# True by default.
	return true

func get_allow_going_higher() -> bool:
	# True by default.
	return true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
