extends Control

@onready var start_button: Button = $Button_Start
@onready var quit_button: Button = $Button_Quit

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	start_button.grab_focus()  

func _on_start_pressed() -> void:

	get_tree().change_scene_to_file("res://scenes/main.tscn")   # ← 换成你第一关的路径

func _on_quit_pressed() -> void:
	get_tree().quit()
