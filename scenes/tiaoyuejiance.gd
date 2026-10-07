extends Area2D
var jump_count: int = 0
var player_inside: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		print("玩家进入了跳跃区域！")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		reset_count()
func _unhandled_input(event: InputEvent) -> void:
	if player_inside and event.is_action_pressed("jump"):
		jump_count += 1
		print("跳跃次数：", jump_count)

	if jump_count >= 3:
			trigger_event() # 触发了！
			reset_count()
func reset_count() -> void:
	jump_count = 0
func trigger_event() -> void:
	print("★ 玩家在这里跳了3次！隐藏机关触发！")	
