extends Control

@onready var text_label: RichTextLabel = $Panel/RichTextLabel

# 显示对话框
func show_message(message: String) -> void:
	text_label.text = message
	visible = true

# 隐藏对话框
func hide_message() -> void:
	visible = false

# 如果你想让玩家按任意键或者再次跳跃关闭对话框，可以加这个
func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("jump"):
		hide_message()
