extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	# 判断碰到的是不是玩家
	if body.name == "Player":
		# 结束游戏
		get_tree().reload_current_scene()
 
