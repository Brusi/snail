extends Control

class_name TextBox

enum Speaker {
	SNAIL,
	GENIE,
	CRACKER,
	AKBARAT,
}

const HEBREW_FONT = preload("res://font/BibushChunky.ttf")
const ENGLISH_FONT = preload("res://font/MatchupPro.ttf")

# Signal to
signal continue_in

signal shown
signal done

var text_shown: = false
var tooltip_shown: = false

var _hebrew_font: FontVariation
var _applied_hebrew = null

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_ensure_layout()

func _configure_pixel_font(f: FontFile) -> void:
	f.antialiasing = TextServer.FONT_ANTIALIASING_NONE
	f.hinting = TextServer.HINTING_NONE
	f.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED
	f.keep_rounding_remainders = false
	f.oversampling = 1.0

func _ensure_layout() -> void:
	if _applied_hebrew == Status.hebrew:
		return
	_applied_hebrew = Status.hebrew
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if _hebrew_font == null:
		_configure_pixel_font(HEBREW_FONT)
		_configure_pixel_font(ENGLISH_FONT)
		_hebrew_font = FontVariation.new()
		_hebrew_font.base_font = HEBREW_FONT
		_hebrew_font.fallbacks = [ENGLISH_FONT]

	$Label.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	if Status.hebrew:
		offset_left = -16.0
		offset_right = -16.0
		$Portraits.position.x = 322.0
		for c in $Portraits.get_children():
			(c as TextureRect).flip_h = true
		$Label.add_theme_font_override("font", _hebrew_font)
		$Label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		$Label.text_direction = Control.TEXT_DIRECTION_RTL
	else:
		offset_left = 16.0
		offset_right = 16.0
		$Portraits.position.x = 0.0
		for c in $Portraits.get_children():
			(c as TextureRect).flip_h = false
		$Label.remove_theme_font_override("font")
		$Label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		$Label.text_direction = Control.TEXT_DIRECTION_LTR

func show_text(speaker: Speaker, en_text: String, he_text: String):
	_ensure_layout()
	var text_to_show: String = he_text if Status.hebrew else en_text
	tooltip_shown = false
	text_shown = true
	visible = true
	emit_signal("shown")
	
	# Handle portrait.
	$Portraits.visible = true
	for c in $Portraits.get_children():
		c.visible = false

	match speaker:
		Speaker.GENIE:
			if Status.hat_down:
				$Portraits/Genie.visible = true
			else:
				$Portraits/GenieHat.visible = true
		Speaker.CRACKER:
			$Portraits/Crab.visible = true
		Speaker.AKBARAT:
			$Portraits/Rat.visible = true
		Speaker.SNAIL:
			if get_parent().get_parent().current_depth == 0:
				$Portraits/SnailShell.visible = true
			else:
				$Portraits/Snail.visible = true
	
	$Label.text = text_to_show
	$Timer.start()
	for i in range(text_to_show.length() + 1):
		$Label.visible_characters = i
		await $Timer.timeout
	$Label.visible_characters = -1
	
	await self.continue_in
	visible = false
	text_shown = false
	emit_signal("done")
	
func show_tooltip(en_text: String, he_text: String):
	if text_shown:
		# Tooltip should not override dialogue.
		return
	var game = get_parent().get_parent() as Game
	if game and game.level_to_scale != null:
		return
	_ensure_layout()
	visible = true
	tooltip_shown = true
	$Label.visible_characters = -1
	$Label.text = he_text if Status.hebrew else en_text
	#$Label.align = Label.ALIGNMENT_CENTER
	
	$Portraits.visible = false
	
func hide_tooltip():
	if text_shown or not tooltip_shown:
		# Turning off tooltip should not affect dialogue.
		return
	visible = false
	tooltip_shown = false
	
func _process(delta:float):
	var game = get_parent().get_parent() as Game
	if game and game.level_to_scale != null:
		if not text_shown:
			visible = false
			tooltip_shown = false
	if Input.is_action_just_pressed("enter") or Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("exit"):
		emit_signal("continue_in")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
