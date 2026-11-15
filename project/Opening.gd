extends Control

const HEBREW_FONT = preload("res://font/BibushChunky.ttf")
const ENGLISH_FONT = preload("res://font/MatchupPro.ttf")

var _starting := false

@onready var english_button: Button = $CenterContainer/HBoxContainer/EnglishButton
@onready var hebrew_button: Button = $CenterContainer/HBoxContainer/HebrewButton

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_configure_pixel_font(ENGLISH_FONT)
	_configure_pixel_font(HEBREW_FONT)
	hebrew_button.text_direction = Control.TEXT_DIRECTION_RTL
	english_button.mouse_entered.connect(english_button.grab_focus)
	hebrew_button.mouse_entered.connect(hebrew_button.grab_focus)
	english_button.grab_focus()

func _configure_pixel_font(f: FontFile) -> void:
	f.antialiasing = TextServer.FONT_ANTIALIASING_NONE
	f.hinting = TextServer.HINTING_NONE
	f.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED
	f.keep_rounding_remainders = false
	f.oversampling = 1.0

func _unhandled_input(event: InputEvent) -> void:
	if _starting:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("enter"):
		var focused := get_viewport().gui_get_focus_owner() as BaseButton
		if focused != null:
			get_viewport().set_input_as_handled()
			focused.pressed.emit()

func _select_language(is_hebrew: bool) -> void:
	if _starting:
		return
	_starting = true
	Status.hebrew = is_hebrew
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_english_button_pressed() -> void:
	_select_language(false)

func _on_hebrew_button_pressed() -> void:
	_select_language(true)
