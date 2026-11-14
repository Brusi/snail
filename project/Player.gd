extends CharacterBody2D

const SPEED = 50
var vel: = Vector2.ZERO

var can_move: = false

func _ready():
	pass

func get_direction_pressed() -> Vector2:
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		dir += Vector2.DOWN
	elif Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		dir += Vector2.UP
		
	if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		dir += Vector2.LEFT
	elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		dir += Vector2.RIGHT
		
	return dir
	

func _physics_process(delta):
	var dir: = Vector2.ZERO
	if can_move:
		# Move.
		dir = get_direction_pressed()
		vel += dir * SPEED
		vel *= 0.7
		set_velocity(vel)
		move_and_slide()
		position = Vector2(round(position.x), round(position.y))
		
	$WithShell.flip_h = vel.x > 0
	$NoShell.flip_h = vel.x > 0
	
	if dir != Vector2.ZERO:
		$WithShell.play("walk")
		$NoShell.play("walk")
	else:
		$WithShell.play("idle")
		$NoShell.play("idle")
	
func set_shell(show_shell:bool):
	$WithShell.visible = show_shell
	$NoShell.visible = not show_shell
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
