extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_live_score():
	$Score.hide()
	$ScoreLabel.hide()
	$Timer.hide()
	$TimerLabel.hide()

func show_live_score():
	$Score.show()
	$ScoreLabel.show()
	$Timer.show()
	$TimerLabel.show()

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over(score):	
	show_message(str(score) + " latinhas!")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Tente Novamente"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$Score.text = str(score)
	
func update_time(time):
	$Timer.text = str(time)


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
