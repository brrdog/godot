extends CharacterBody2D

@export_category("移动参数")
@export var double_press_interval := 0.3
@export var move_speed: float = 75.0
@export var acceleration: float = 600.0
@export var deceleration: float = 800.0
@export var jump_velocity: float = -190.0
@export_category("冲刺参数")  #冲刺参数
@export var dash_speed: float = 320.0     
@export var dash_duration: float = 0.18     
@export var dash_cooldown: float = 0.4   #冲刺
@export var death_y: float = 300.0
@export var death_x: float = 470.0
var is_dashing: bool = false
var dash_time_left: float = 0.0
var dash_cooldown_left: float = 0.0
var dash_direction: Vector2 = Vector2.RIGHT
var on_ladder: bool = false


@onready var sprite: Sprite2D = $Sprite2D

var flying : bool = false
var last_space_press_time := -1000

func _physics_process(delta: float) -> void:
	if global_position.x > death_x:
		die()
		return
	if global_position.y > death_y: #死
		die()
		return
	handle_dash(delta) #判断冲刺
	if is_dashing:
		update_sprite_direction()
		move_and_slide()
		return
	if on_ladder:   #爬梯优先
			handle_ladder_movement(delta)
	elif !flying:
		apply_gravity(delta)
		handle_jump()
	
	else:
		handle_vertical_movement(delta)
	
	handle_horizontal_movement(delta)
	update_sprite_direction()
	move_and_slide()
	

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_vertical_movement(delta:float) -> void:
	var direction := Input.get_axis("squat", "jump")
	var target_speed := direction * jump_velocity
	
	if direction != 0.0:
		velocity.y = move_toward(
				velocity.y,
				target_speed,
				acceleration * delta
		)
	else:
		velocity.y = move_toward(
				velocity.y,
				0.0,
				acceleration * delta
		)
	
func handle_horizontal_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var target_speed := direction * move_speed

	if direction != 0.0:
		velocity.x = move_toward(
				velocity.x,
				target_speed,
				acceleration * delta
		)
	else:
		velocity.x = move_toward(
				velocity.x,
				0.0,
				deceleration * delta
		)

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
func update_sprite_direction() -> void:
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fly") and !event.is_echo():
		handle_space_pressed()
	
func handle_space_pressed() -> void:
	var current_time := Time.get_ticks_msec()
	var elapsed_time := current_time - last_space_press_time

	if elapsed_time <= double_press_interval * 1000.0:
		flying = not flying
		last_space_press_time = -1000
	else:
		last_space_press_time = current_time

#下为梯子
func _on_spikes_01_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
func handle_ladder_movement(delta: float) -> void:
	var input_y := Input.get_axis("jump", "squat")
	velocity.y = input_y * move_speed
	var input_x := Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, input_x * move_speed, acceleration * delta)
#冲刺函数	
func handle_dash(delta: float) -> void:
	if dash_cooldown_left > 0:
		dash_cooldown_left -= delta
	if Input.is_action_just_pressed("dash") \
			and dash_cooldown_left <= 0 \
			and not is_dashing:
		start_dash()
	if is_dashing:
		velocity = dash_direction * dash_speed
		dash_time_left -= delta
		if dash_time_left <= 0:
			end_dash()

func start_dash() -> void:
	is_dashing = true
	dash_time_left = dash_duration
	dash_cooldown_left = dash_cooldown
	var input_x := Input.get_axis("move_left", "move_right")
	if abs(input_x) > 0.1:
		dash_direction = Vector2(sign(input_x), 0)
	else:
		dash_direction = Vector2(-1 if sprite.flip_h else 1, 0)

func end_dash() -> void: 
	is_dashing = false
	velocity.x *= 0.3  	
func die() -> void:
	get_tree().reload_current_scene()

	
