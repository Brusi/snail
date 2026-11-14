extends Node2D

class_name Game

const CENTER = Vector2(192, 120)
const ZOOM_TIME = 1.5

var current_depth: = 1
var current_level:Level

var scale_anchor:Vector2
var level_to_scale:Node2D

func get_level_anchor(level:Node2D) -> Vector2:
	return level.get_node("Anchor").position + CENTER

func distance_man(a:Vector2, b:Vector2) -> float:
	return abs(a.x - b.x) + abs(a.y - b.y)

func scene_from_depth(depth:int):
	match depth:
		-1: return load("res://levels/TheEnd.tscn")
		0: return load("res://levels/Surface.tscn")
		1: return load("res://levels/Shell.tscn")
		2: return load("res://levels/Terrarium.tscn")
		3: return load("res://levels/Chest.tscn")
		4: return load("res://levels/Lamp.tscn")
		5: return load("res://levels/Hat.tscn")
	return null

func down_one_level(depth:int) -> void:
	if level_to_scale != null:
		print("Already zooming...",depth)
		return
	
	var packed_new_level = scene_from_depth(depth)
	if packed_new_level == null:
		print("No level at depth ",depth)
		return
		
	Music.swoosh_in()
		
	current_level.active = false
	
	current_depth = depth
		
	var new_level:Node2D = packed_new_level.instantiate()
	new_level.position = position
	new_level.scale.x = 1.0/16
	new_level.scale.y = 1.0/16
	level_to_scale = new_level
	add_child(new_level)
	# Move level to back.
	move_child(new_level, 0)
	
	scale_anchor = get_level_anchor(current_level)
		
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(zoom_in_level, 0.0, 1.0, ZOOM_TIME)
	tween.tween_callback(zoom_done)
	
func up_one_level(depth:int) -> void:
	if level_to_scale != null:
		print("Already zooming...",depth)
		return
	
	var packed_new_level = scene_from_depth(depth)
	if packed_new_level == null:
		print("No level at depth ",depth)
		return
		
	Music.swoosh_out()
		
	current_level.active = false
		
	current_depth = depth
		
	# Edit below.
	var new_level:Node2D = packed_new_level.instantiate()
	new_level.position = position
	new_level.scale.x = 1.0/16
	new_level.scale.y = 1.0/16
	level_to_scale = new_level
	add_child(new_level)
	# Move level to back.
	move_child(new_level, 0)
	
	scale_anchor = get_level_anchor(new_level)
	
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(zoom_out_level, 1.0, 0.0, ZOOM_TIME)
	tween.tween_callback(zoom_done)

func zoom_in_level(t:float) -> void:
	$Player.visible = false
	
	var scale: = 1.0 / 16.0 + t * 15.0/16.0
	level_to_scale.scale.x = scale
	level_to_scale.scale.y = scale
	
	level_to_scale.position = scale_anchor * (1.0-t) + CENTER * t
	
	var current_level_scale = scale * 16.0
	current_level.scale.x = current_level_scale
	current_level.scale.y = current_level_scale
	current_level.position = (CENTER - scale_anchor) * (current_level_scale - (1.0-t)) + CENTER
	
	level_to_scale.modulate.a = t
	current_level.modulate.a = 1.0-t
	
func zoom_out_level(t:float) -> void:
	$Player.visible = false
	$Player.position = CENTER
	
	var scale: = 1.0 / 16.0 + t * 15.0/16.0
	current_level.scale.x = scale
	current_level.scale.y = scale
	
	current_level.position = scale_anchor * (1.0-t) + CENTER * t
	
	var current_level_scale = scale * 16.0
	level_to_scale.scale.x = current_level_scale
	level_to_scale.scale.y = current_level_scale
	level_to_scale.position = (CENTER - scale_anchor) * (current_level_scale - (1.0-t)) + CENTER
	
	level_to_scale.modulate.a = 1.0-t
	current_level.modulate.a = t

func zoom_done():
	remove_child(current_level)
	current_level.queue_free()
	current_level = level_to_scale
	level_to_scale = null
	
	(current_level as Level).init_level()
	Music.play_depth(current_depth)
	
	$Player.position = CENTER
	$Player.visible = true
	$Item.global_position = $Player.global_position

func _ready():
	current_level = $Level
	current_level.init_level()
	Music.play_depth(1)
	pass # Replace with function body.
	
func _physics_process(delta):
	$Item.position = $Player.position * 0.4 + $Item.position * 0.6

func _process(delta):
	update_item()
	if level_to_scale != null:
		get_textbox().hide_tooltip()
	
	if ($UI/TextBox.text_shown):
		return
	
	#if Input.is_action_pressed("override"):
	if Input.is_action_just_pressed("enter") and distance_man(get_level_anchor(current_level), $Player.position) < 24 and current_level.get_allow_going_deeper():
		get_textbox().hide_tooltip()
		down_one_level(current_depth + 1)
	if Input.is_action_just_pressed("exit") and (current_level.get_allow_going_higher() or Input.is_action_pressed("override")):
		get_textbox().hide_tooltip()
		up_one_level(current_depth - 1)
		
	if Input.is_action_pressed("override") and Input.is_action_just_pressed("enter"):
		down_one_level(current_depth + 1)
		
	
func update_item():
	# Do not show item if player is hidden.
	$Item.visible = $Player.visible
	
	for c in $Item.get_children():
		c.visible = false
		
	match Status.current_item:
		Status.Item.CUPBOARD_KEY: $Item/Key.visible = true
		Status.Item.HAMMER: $Item/Hammer.visible = true
		Status.Item.COIN: $Item/Coin.visible = true
		Status.Item.FLOWER: $Item/Flower.visible = true
		Status.Item.CLIPPERS: $Item/Clippers.visible = true
		Status.Item.NUT: $Item/Nut.visible = true
		Status.Item.CRACKED_NUT: $Item/CrackedNut.visible = true
		
func get_textbox() -> TextBox:
	return $UI/TextBox as TextBox
	


func _on_TextBox_done():
	$Player.can_move = true
	pass # Replace with function body.


func _on_TextBox_shown():
	print("_on_TextBox_shown")
	$Player.can_move = false
	pass # Replace with function body.
