extends Area2D
var triggered: bool = false
@export_file("*.tscn") var four: String="res://scenes/four.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return
	if body.name == "Player":
		triggered = true
		win()
func win() -> void:
	get_tree().change_scene_to_file(four)
	
