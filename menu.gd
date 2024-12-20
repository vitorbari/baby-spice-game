extends CanvasLayer

signal normal_mode_pressed
signal zen_mode_pressed
signal turbo_mode_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_normal_mode_button_pressed() -> void:
	normal_mode_pressed.emit()

func _on_zen_mode_button_pressed() -> void:
	zen_mode_pressed.emit()

func _on_turbo_mode_pressed() -> void:
	turbo_mode_pressed.emit()
